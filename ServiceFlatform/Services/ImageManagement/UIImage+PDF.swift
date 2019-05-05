//
//  UIImage+PDF.swift
//
//  Created by Roman Bambura on 2/23/16.
//  Copyright © 2016 Roman Bambura. All rights reserved.
//  http://www.sonettic.com
//

import UIKit

public extension UIImage {

  // MARK:  Control cache
  fileprivate static var _imagesCache: NSCache<AnyObject, AnyObject>?
  fileprivate static var _shouldCache: Bool = false
  fileprivate static var _shouldCacheOnDisk: Bool = true
  fileprivate static var _assetName: String = ""
  fileprivate static var _resourceName: String = ""

  public static var cachedAssetsDirectory: String{
    get{
      return "CachedAssets"
    }
  }

  public static var resourceName: String {

    set{
      _resourceName = newValue
      _assetName = newValue.components(separatedBy: ".")[0]
    }
    get{
      return _resourceName
    }
  }

  public static var assetName: String {
    set{
      _assetName = newValue
      _resourceName = "Assets/" + _assetName + ".pdf"
    }
    get{
      return _assetName
    }
  }

  public static var shouldCacheInMemory:Bool{
    set{
      _shouldCache = newValue

      if( _shouldCache && _imagesCache.isNil)
      {
        _imagesCache = NSCache()
      }
    }
    get{
      return _shouldCache
    }
  }

  public static var shouldCacheOnDisk: Bool {

    set{
      _shouldCacheOnDisk = newValue;
    }
    get{
      return _shouldCacheOnDisk
    }
  }

  // Mark: Public Func

  public class func screenScale() -> CGFloat{
    return UIScreen.main.scale
  }

  // Mark: Get UIImage With PDF Name Without Extension

  // Mark: UIImage With Size
  public class func imageWithPDFNamed(_ name: String, size:CGSize) -> UIImage? {

    assetName = name
    if let resource = PDFResourceHelper.resourceURLForName(resourceName) {
      return self.imageWithPDFURL(resource, size:size)
    }
    return nil
  }

  // Mark: Resource URLs
  public class func imageWithPDFURL(_ URL: Foundation.URL?,  size:CGSize,  page: Int, preserveAspectRatio:Bool) -> UIImage? {

    if(URL.isNil || size.equalTo(CGSize.zero) || page == 0){
      return nil
    }

    var pdfImage: UIImage?

    let cacheFilename: String = self.cacheFileNameForResourceNamed(self.assetName, size: size)
    let cacheFilePath: String = self.cacheFilePathForResourceNamed(cacheFilename)

    /**
     * Check in Memory cached image before checking file system
     */
    if _shouldCache
    {
      pdfImage = _imagesCache?.object(forKey: cacheFilename as AnyObject) as? UIImage

      if pdfImage.notNil {
        return pdfImage
      }
    }

    if(_shouldCacheOnDisk && FileManager.default.fileExists(atPath: cacheFilePath))
    {
      pdfImage = UIImage(contentsOfFile: cacheFilePath)

    }
    else
    {

      let screenScale: CGFloat = UIScreen.main.scale
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      if let ctx: CGContext = CGContext(data: nil, width: Int(size.width * screenScale), height: Int(size.height * screenScale), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo().rawValue) {
        ctx.scaleBy(x: screenScale, y: screenScale);

        PDFResourceHelper.renderIntoContext(ctx, url:URL, data: nil, size:size, page:page, preserveAspectRatio:preserveAspectRatio)
        if let image: CGImage = ctx.makeImage(){
          pdfImage =  UIImage(cgImage: image, scale: screenScale, orientation: UIImage.Orientation.up)
        }

        if(_shouldCacheOnDisk)
        {
          if let img = pdfImage, let data = img.pngData() {
            try? data.write(to: Foundation.URL(fileURLWithPath: cacheFilePath), options: [])
          }
        }
      }
    }
    let res = pdfImage ?? UIImage(named: assetName)
    /**
     * Cache image to in memory if active
     */
    if let img = res, _shouldCache
    {
      _imagesCache?.setObject(img, forKey: cacheFilename as AnyObject)
    }

    return res;
  }

  public class func imageWithPDFURL(_ URL: Foundation.URL?,  size: CGSize) -> UIImage?{
    return self.imageWithPDFURL(URL, size:size, page:1, preserveAspectRatio:false)
  }

  // Mark: Cacheing
  fileprivate class func cacheFileNameForResourceNamed(_ resourceName: String, size: CGSize) -> String{
    return resourceName + "_\(Int(size.width))X\(Int(size.width))@\(Int(self.screenScale()))x"
  }

  fileprivate class func cacheFilePathForResourceNamed(_ resourceName: String,  size: CGSize) -> String{
    let fileName: String = self.cacheFileNameForResourceNamed(resourceName, size: size)
    return self.cacheFilePathForResourceNamed(fileName)
  }

  fileprivate class func cacheFilePathForResourceNamed(_ cacheResourseName: String, dir: Bool = false) -> String{

    let fileManager: FileManager = FileManager.default
    let documentsDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let cacheDirectory = documentsDirectoryPath + "/" + cachedAssetsDirectory
    do{
      try  fileManager.createDirectory(atPath: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }catch{
      print ("CACHES DIRECTORY IMAGE+PDF CAN'T BE CREATED!")
    }
    if dir {
      return cacheDirectory
    }
    return cacheDirectory + "/" + cacheResourseName + ".png"
  }

  public class func clearCache(assetNamed: String) {
    /// Clear all cached image in memory
    _imagesCache?.removeAllObjects()
    /// Clear relative images in disk
    let dir = cacheFilePathForResourceNamed("", dir: true)
    do {
      let contents = try FileManager.default.contentsOfDirectory(atPath: dir)
      try contents.filter({ $0.contains(assetNamed) }).forEach({ (path) in
        try FileManager.default.removeItem(atPath: "\(dir)/\(path)")
      })
    } catch let err {
      #if DEV
        logger.debug(err)
      #endif
    }
  }
}
