//
//  Extensions.swift
//  Pods
//
//  Created by Arman Mergenbayev on 23.11.2017.
//
//

import Foundation
import CommonCrypto

extension String {
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        
        return String(format: hash as String)
    }
    
    
}

extension Date {
    var toMillis: Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
