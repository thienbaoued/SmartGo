//
//  UDKey.swift
//  Timo
//
//  Copyright © 2018 Timo. All rights reserved.
//
import Foundation
import CryptoSwift

public protocol UD {
  
  associatedtype T
  var rawValue: String {get}
}

public extension UD {
  
  // MARK: - Getter and Setter
  var value: T? {
    let val = UserDefaults.standard.value(forKey: key) as? T
    return decrypt(val: val)
  }
  
  func set(ud: UserDefaults? = UserDefaults.standard, _ val: T?) {
    let value = encrypt(val)
    ud?.set(value, forKey: key)
  }
  
  var ud: UserDefaults? {
    return UserDefaults(suiteName: key)
  }
  
  func value(ud: UserDefaults?) -> T? {
    let val = ud?.value(forKey: key) as? T
    return decrypt(val: val)
  }
  
  // MARK: - Private handlers
  private var key: String {
    return rawValue
  }
  
  private var secureKey: String {
    return key.count > 16 ? String(key.prefix(16)) : key + String(repeating: "k", count: 16 - key.count)
  }
  
  // MARK: - Encrypt and Decrypt String using AES Method
  private func encrypt(_ val: T?) -> T? {
    guard let value = val as? String else { return val }
    do {
      let iv = AES.randomIV(AES.blockSize)
      let aes = try AES(key: secureKey.md5().bytes, blockMode: CBC(iv: iv))
      let encrypted = try aes.encrypt(value.bytes)
      let encryptedK = Data(bytes: encrypted)
      var encryptedKIV = Data(bytes: iv)
      encryptedKIV.append(encryptedK)
      return encryptedKIV.base64EncodedString() as? T
    } catch let err {
      print(err)
      return val
    }
  }
  
  private func decrypt(val: T?) -> T? {
    guard let value = val as? String else { return val }
    do {
      
      guard let data = Data(base64Encoded: value) else { return val }
      let count = [UInt8](data).count
      guard count > AES.blockSize else { return val }
      let iv = Array([UInt8](data)[0 ..< AES.blockSize])
      let bytes = Array([UInt8](data)[AES.blockSize ..< count])
      let aes = try AES(key: secureKey.md5().bytes, blockMode: CBC(iv: iv))
      let decrypted = try aes.decrypt(bytes)
      return String(bytes: decrypted, encoding: .utf8) as? T
    } catch let err {
      print(err)
      return val
    }
  }
}

/// for dealling with UserDefault
public enum UDKey<T>: String, UD {
  
  // MARK: - Usecases
  case example = "EXAMPLE"
  case token = "token"
  
  /// Group cases into a nested Enum based on their sense
  public enum User: String, UD {
    
    case email = "USER_EMAIL"
    case userId = "USER_ID"
    case userName = "USER_NAME"
    case confirmed = "CONFIRMED"
    case name = "NAME"
    case password = "PASSWORD"
    case verifiedInfo = "VERIFIED_INFO"
    case encryptionKey = "ENCRYPTION_KEY"
    case privateKey = "PRIVATE_KEY"
  }
  
  enum Group: String, UD {
    case app = "group.com.timox"
    case user = "GROUP_USER_ID"
  }
  
  enum Filter: String, UD {
    case location = "FILTER_BY_LOCATION"
    case type = "FILTER_BY_TYPE"
  }
}
