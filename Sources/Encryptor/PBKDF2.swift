//
//  PBKDF2.swift
//  token
//
//  Created by James Chen on 2016/10/25.
//  Copyright © 2016 imToken PTE. LTD. All rights reserved.
//

import Foundation
import CommonCrypto

extension Encryptor {
    class PBKDF2 {
      private let password: String
      private let salt: String
      private let iterations: Int
      private let keyLength: Int
      private let variant: CCPseudoRandomAlgorithm

      // Param password and salt salt should be in hex format.
      init(password: String, salt: String, iterations: Int, keyLength: Int = 32, variant: CCPseudoRandomAlgorithm = CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256)) {
        self.password = password
        self.salt = salt
        self.iterations = iterations
        self.keyLength = keyLength
        self.variant = variant
      }

      // Encrypt input string and return encrypted string in hex format.
      func encrypt() -> String {
        let password = self.password.data(using: .ascii, allowLossyConversion: true)!
        let passwordString = String(data: password, encoding: .ascii)!
        
        let saltBytes = [UInt8](hex: salt)

        let derivedKeyLen = Int(keyLength)
        var derivedKey = Data(count: derivedKeyLen)
        derivedKey.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> Void in
            CCKeyDerivationPBKDF(
                UInt32(kCCPBKDF2),
                passwordString,
                passwordString.count,
                saltBytes,
                saltBytes.count,
                UInt32(variant),
                UInt32(iterations),
                bytes,
                derivedKeyLen
            )
        }
        return derivedKey.tk_toHexString()
      }
  }
}
