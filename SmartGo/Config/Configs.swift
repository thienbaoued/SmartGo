//
//  Configs.swift
//  Timo
//
//  Copyright © 2018 Timo. All rights reserved.
//

import Foundation
// All configuration variables based on the variety of environments must be placed here

struct Config {
  
  #if DEBUG
    static let apiURL = ""
    static let CognitoID = ""
    static let appStoreAppID = ""
    static let S3BucketName = "olak-userfiles-5a1879daf38e"
    static let S3PrefixURL = "https://s3.amazonaws.com"
    static let S3Folder = "private"
  #else
    static let apiURL = ""
    static let CognitoID = ""
    static let appStoreAppID = ""
    static let S3BucketName = "olak-userfiles-5a1879daf38e"
    static let S3PrefixURL = "https://s3.amazonaws.com"
    static let S3Folder = "private"
  #endif
  
}
