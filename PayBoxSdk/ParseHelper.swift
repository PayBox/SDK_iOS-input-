//
//  ParseHelper.swift
//  Pods
//
//  Created by Arman Mergenbayev on 23.11.2017.
//
//

import Foundation


class ParseHelper {
    
    private static var sharedInstance: ParseHelper?
    public static var parser: ParseHelper{
        if sharedInstance==nil {
            sharedInstance = ParseHelper()
        }
        return sharedInstance!
    }
    public func xmlParser(data: Data?)->[String:String]{
        return [:]
    }
    public func parseToDate(date: String)->Date?{
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        guard let pdate = formatter.date(from: date) else {
            return nil
        }
        return pdate
    }
    public func sig(secretKey: String, url: String, param: [(key: String, value: String)])->String{
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
        return sig.md5()
    }
    
    public var randomSalt: String{
        let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        
        var s = ""
        
        for _ in 0..<16
        {
            let r = Int(arc4random_uniform(UInt32(a.characters.count)))
            
            s += String(a[a.index(a.startIndex, offsetBy: r)])
        }
        return s
    }
    public func sort(array: [String:String])-> [(key: String, value: String)]{
        var params = array;
        params.updateValue(randomSalt, forKey: Constants.PB_SALT)
        return params.sorted(by: { $0.key < $1.key })
    }
    public func isXml(xml: String)->Bool{
        if !xml.isEmpty {
            if xml.contains("<?xml") {
                return true
            }
        }
        return false
    }
    public func urlGet(from: [(key: String, value: String)], mainUrl: String)->String{
        var url = mainUrl.appending("?")
        for (key,value) in from {
            url.append("\(key)=\(value)&")
        }
        return url
    }
    public func cardFrom(xml: String)->[Int:Card]{
        var array = [Int:Card]()
        if isXml(xml: xml) {
            let arraySt = xml.components(separatedBy: "<"+Constants.CARD+">")
            if arraySt.count > 1 {
                for index in 1...(arraySt.count-1) {
                    var arrayF: String {
                        return arraySt[(index)].components(separatedBy: "</"+Constants.CARD+">")[0]
                    }
                    func cardItem(name: String)->String{
                        var str = "_"
                        let argSt = arrayF.components(separatedBy: "<"+name+">")
                        if argSt.count > 1 {
                            str = argSt[1].components(separatedBy: "</"+name+">")[0]
                        }
                        return str
                    }
                    array.updateValue(Card(status: cardItem(name: Constants.PB_STATUS), merchantId: cardItem(name: Constants.PB_MERCHANT_ID), cardId: cardItem(name: Constants.PB_CARD_ID), recurringProfile: cardItem(name: Constants.PB_RECURRING_PROFILE_ID), cardHash: cardItem(name: Constants.PB_CARD_HASH),date: cardItem(name: Constants.PB_CARD_CREATED_AT)), forKey: (index-1))
                }
            }
        }
        return array
    }
    public func stringFrom(xml: String, name: String)->String{
        var str = ""
        if isXml(xml: xml) {
            let argSt =  xml.components(separatedBy: "<"+name+">")
            if argSt.count > 1 {
                str = argSt[1].components(separatedBy: "</"+name+">")[0]
            } else {
                return "_"
            }
        }
        return str
    }
}
