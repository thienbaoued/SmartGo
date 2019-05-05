//
//  UIImageExts.swift
//  Timo
//
//  Copyright © 2018 Timo. All rights reserved.
//

import UIKit
import ServiceFlatform
import Kingfisher
import AWSCore

extension ImageManager {
  
  /// Downloading and caching image from url and then rendering to imageview
  ///
  /// - Parameter urlString: image url string
  public static func renderS3Image(imgView: UIImageView, urlString: String, blur: Bool = false, effect: Bool = true, placeholder: UIImage? = nil, completionHandler: ((_ image: UIImage?) -> Void)?=nil) {
    let prefix = Config.S3PrefixURL + "/\(Config.S3Folder)/\(AWSCognitoSession.shared.clientID ?? "")/"
    let urlString = prefix + urlString
    if let url = URL(string: urlString) {
      imgView.kf.indicatorType = .activity
      if effect {
        var options: KingfisherOptionsInfo = [.transition(.fade(0.25))] + getOptionsInfo(s3Url: urlString)
        if blur {
          options.append(.processor(BlurImageProcessor(blurRadius: 10)))
        }
        imgView.kf.setImage(with: url, placeholder: placeholder, options: options, completionHandler: { (img, _, _, _) in
          completionHandler?(img)
        })
      } else {
        imgView.kf.setImage(with: url, placeholder: placeholder, options: getOptionsInfo(s3Url: urlString))
      }
    }
  }
  
  /// Performing a state of art image loading by giving two size of image in order of small and large
  /// The concept is like image progressive, if the large image has been cached in storage, it's immediately loaded to target imageview
  /// Otherwise, the download progress will take place from small size to larger
  ///
  /// - Parameters:
  ///   - imgView: target uiimageview
  ///   - photos: list of images' url, should be [small, large]
  ///   - downloading: outcoming callback for handling the download progress is executing
  ///   - downloaded: outcoming callback for handling the download progress did end
  public static func progressiveS3Image(imgView: UIImageView, photos: [String], placeholder: UIImage = #imageLiteral(resourceName: "image-placeholder"), downloading: Action? = nil, downloaded: Action? = nil) {
    let prefix = "\(Config.S3PrefixURL )/\(Config.S3BucketName)/\(Config.S3Folder)/\(AWSCognitoSession.shared.clientID ?? "")/"
    if let str = photos.last, let url = URL(string: prefix + str) {
      let origin = prefix + str
      DispatchQueue.global(qos: .utility).async {
        ImageCache.default.retrieveImage(forKey: origin, options: nil, completionHandler: { (img, type) in
          if let img = img {
            if ImageManager.isGif(origin) {
              /// If the target file is gif, should process to be able to render a gif to imageview
              if let gif = DefaultImageProcessor.default.process(item: .image(img), options: []) {
                DispatchQueue.main.async {
                  imgView.image = gif
                }
              }
            } else {
              /// Otherwise, rendering as a normal image
              DispatchQueue.main.async {
                imgView.image = img
              }
            }
          } else {
            downloading?()
            var options: KingfisherOptionsInfo?
            if !ImageManager.isGif(origin) {
              options = [.backgroundDecode]
            }
            /// If the origin is gif, just need to download it immediately and bypass small size because the function doesn't support gif
            if ImageManager.isGif(origin) {
              /// Downloading gif file
              imgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "image-placeholder"), options: (options ?? []) + getOptionsInfo(s3Url: origin), completionHandler: { (img, _, _, _) in
                downloaded?()
              })
            } else {
              /// Downloading normal image
              let thubmail = prefix + (photos.first ?? "")
              if let small = URL(string: thubmail) {
                /// Firstly, downloading small image and make blur effect
                let coptions: KingfisherOptionsInfo = (options ?? []) + [.processor(BlurImageProcessor(blurRadius: 10))] + getOptionsInfo(s3Url: thubmail)
                imgView.kf.setImage(with: small, placeholder: #imageLiteral(resourceName: "image-placeholder"), options: coptions, completionHandler: { (_, _, _, _) in
                  /// After that, start downloading original image
                  let finalOpts = (options ?? []) + [.keepCurrentImageWhileLoading] + getOptionsInfo(s3Url: origin)
                  imgView.kf.setImage(with: url, options: finalOpts, completionHandler: { (_, _, _, _) in
                    downloaded?()
                  })
                })
              } else {
                /// After that, start downloading original image
                imgView.kf.setImage(with: url, options: options, completionHandler: { (_, _, _, _) in
                  downloaded?()
                })
              }
            }
          }
        })
      }
    }
  }
  
  private static func getOptionsInfo(s3Url: String) -> KingfisherOptionsInfo {
    guard !s3Url.isEmpty else {
      return []
    }
    let url = URL(string: s3Url)!
    let req = self.credentialSign(url: url)
    let modifier = AnyModifier { request in
      var r = request
      r.allHTTPHeaderFields = req.allHTTPHeaderFields
      return r
    }
    
    return [.requestModifier(modifier)]
  }
  
  private static func credentialSign(url: URL) -> URLRequest {
    let credentials = AWSServiceManager.default()?.defaultServiceConfiguration.credentialsProvider
    let signature = AWSSignatureV4Signer(credentialsProvider: credentials!, endpoint: AWSEndpoint(region: .USEast1, service: .S3, url: url))
    let date = (NSDate.aws_clockSkewFixed()! as NSDate).aws_stringValue(AWSDateISO8601DateFormat2)!
    let req = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    req.httpMethod = "GET"
    req.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded", "X-Amz-Date": date]
    signature?.interceptRequest(req)?.continueWith(block: { _ in return nil })
    return req as URLRequest
  }
}

