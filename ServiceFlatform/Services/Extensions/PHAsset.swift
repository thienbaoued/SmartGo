//
//  PHAsset.swift
//  ServicePlatform
//
//

import Photos
import MobileCoreServices

// MARK: - Photos
public extension PHAsset {

  public var isGif: Bool {
    if let resource = PHAssetResource.assetResources(for: self).first {
      let uti = resource.uniformTypeIdentifier as CFString
      let gif = UTTypeConformsTo(uti, kUTTypeGIF)
      if gif {
        return true
      }
      return resource.originalFilename.uppercased().hasSuffix("GIF")
    }
    return false
  }

}
