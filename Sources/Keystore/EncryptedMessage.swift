//
//  EncryptedMessage.swfit
//  token
//
//  Created by Kai Chen on 20/11/2017.
//  Copyright © 2017 ConsenLabs. All rights reserved.
//

import Foundation

// Store anything like { encStr: "secertMessage", nonce: "randomBytes" }
public struct EncryptedMessage {
  public let encStr: String
  public let nonce: String

  public init(encStr: String, nonce: String) {
    self.encStr = encStr
    self.nonce = nonce
  }

  public init?(json: JSONObject) {
    guard let encStr = json["encStr"] as? String, let nonce = json["nonce"] as? String else {
      return nil
    }
    self.init(encStr: encStr, nonce: nonce)
  }

  public static func create(crypto: Crypto, password: String, message: String, nonce: String? = nil) -> EncryptedMessage {
    return create(crypto: crypto, derivedKey: crypto.derivedKey(with: password), message: message, nonce: nonce)
  }

  public static func create(crypto: Crypto, derivedKey: String, message: String, nonce: String? = nil) -> EncryptedMessage {
    let nonceWithFallback = nonce ?? RandomIV().value
    let encryptor = crypto.encryptor(from: derivedKey.tk_substring(to: 32), nonce: nonceWithFallback)
    return EncryptedMessage(encStr: encryptor.encrypt(hex: message), nonce: nonceWithFallback)
  }

  // use kdf with password to decrypt secert message
  public func decrypt(crypto: Crypto, password: String) -> String {
    let dk = crypto.derivedKey(with: password)
    let encryptor = crypto.encryptor(from: dk.tk_substring(to: 32), nonce: nonce)
    return encryptor.decrypt(hex: encStr)
  }

  public func toJSON() -> JSONObject {
    return [
      "encStr": encStr,
      "nonce": nonce
    ]
  }
}
