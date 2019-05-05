//
//  Data.swift
//  ServicePlatform
//
//

import Foundation

public extension Data {

  public var image: UIImage? {
    return UIImage(data: self, scale: UIScreen.main.scale)
  }

  public var imageFormat: (String, String) {
    var buffer = [UInt8](repeating: 0, count: 1)
    (self as NSData).getBytes(&buffer, range: NSRange(location: 0,length: 1))
    if buffer == [0x89] || buffer == [0xFF] {
      return ("photo.jpeg", "image/jpeg")
    } else if buffer == [0x47]
    {
      return ("photo.gif", "image/gif")
    }
    return ("", "")
  }

  public var isGif: Bool {
    return imageFormat.1 == "image/gif"
  }
}
