

import Foundation
open class SignHelper {
    
    private var secretKey: String!
    
    init(secretKey: String) {
        self.secretKey = secretKey
    }
    internal func signedParams(url: String, array: [String:String])-> [(key: String, value: String)] {
        var params = array;
        var urlPath = url.split(separator: "/")
        params.updateValue(randomSalt, forKey: "pg_salt")
        var sortedParams = params.sorted(by: { $0.key < $1.key })
        sortedParams.append(("pg_sig", sig(secretKey: secretKey, url: String(urlPath[urlPath.count-1]), param: sortedParams)))
        return sortedParams
    }
    
    private func sig(secretKey: String, url: String, param: [(key: String, value: String)])->String{
        var sig = url
        var size = param.count
        for(_,value) in param {
            sig.append(";")
            sig.append(value)
            size-=1
            if size==0 {
                sig.append(";")
                sig.append(secretKey)
            }
        }
        return sig.md5
    }
    
    private var randomSalt: String{
        let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var s = ""
        for _ in 0..<16
        {
            let r = Int(arc4random_uniform(UInt32(a.count)))
            s += String(a[a.index(a.startIndex, offsetBy: r)])
        }
        return s
    }
}
