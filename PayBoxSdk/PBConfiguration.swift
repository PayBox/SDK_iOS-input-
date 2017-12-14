//
//  PBConfiguration.swift
//  Pods
//
//  Created by Arman Mergenbayev on 22.11.2017.
//
//

import Foundation

struct PBConfiguration{
    
    public var CHECK_URL: String?
    public var RESULT_URL: String?
    public var REFUND_URL: String?
    public var CAPTURE_URL: String?
    public var MERCHANT_ID: Int!
    public var isRECURRING: Bool = false
    public var RECURRING_LIFETIME: Int = 1
    public var PAYMENT_LIFETIME: Int = 300
    public var ENCODING = "UTF-8"
    public var LANGUAGE: String! = Constants.LANGUAGE.ru.rawValue
    public var isTEST: Bool! = false
    public var USER_PHONE: String?
    public var USER_EMAIL: String?
    public var PAYMENT_SYSTEM: String! = Constants.PAYMENT_SYSTEM.EPAYWEBKZT.rawValue
    public var REQUEST_METHOD: String! = Constants.REQUEST_METHOD.GET.rawValue
    public var CURRENCY: String! = Constants.CURRENCY.KZT.rawValue;
    private var SECRET_KEY: String!;
    public var AUTO_CLEARING: Bool! = false
    public let SUCCESS = Constants.SUCCESS;
    public let FAILURE = Constants.FAILURE;
    
    
    init(_secretKey: String, _merchantId: Int) {
        self.SECRET_KEY = _secretKey
        self.MERCHANT_ID = _merchantId
    }
    public var secret: String{
        return SECRET_KEY
    }
    
    public var toArray:[String:String] {
        var array: [String:String] = [:]
        array.updateValue(String(MERCHANT_ID), forKey: Constants.PB_MERCHANT_ID)
        array.updateValue(LANGUAGE, forKey: Constants.PB_LANGUAGE)
        array.updateValue(String(PAYMENT_LIFETIME), forKey: Constants.PB_LIFETIME)
        array.updateValue(ENCODING, forKey: Constants.PB_ENCODING)
        if let check_url = CHECK_URL {
            array.updateValue(check_url, forKey: Constants.PB_CHECK_URL)
        }
        if let result_url = RESULT_URL {
            array.updateValue(result_url, forKey: Constants.PB_RESULT_URL)
        }
        if let refund_url = REFUND_URL {
            array.updateValue(refund_url, forKey: Constants.PB_REFUND_URL)
        }
        if let capture_url = CAPTURE_URL {
            array.updateValue(capture_url, forKey: Constants.PB_CAPTURE_URL)
        }
        array.updateValue(PAYMENT_SYSTEM, forKey: Constants.PB_PAYMENT_SYSTEM)
        array.updateValue(CURRENCY, forKey: Constants.PB_CURRENCY)
        array.updateValue(String(isTEST.hashValue), forKey: Constants.PB_TESTING_MODE)
        array.updateValue(REQUEST_METHOD, forKey: Constants.PB_REQUEST_METHOD)
        array.updateValue(String(RECURRING_LIFETIME), forKey: Constants.PB_RECURRING_LIFETIME)
        array.updateValue(String(isRECURRING.hashValue), forKey: Constants.PB_RECURRING_START)
        array.updateValue(SUCCESS, forKey: Constants.PB_SUCCESS_URL)
        array.updateValue(FAILURE, forKey: Constants.PB_FAILURE_URL)
        array.updateValue("GET", forKey: Constants.PB_FAILURE_METHOD)
        array.updateValue("GET", forKey: Constants.PB_SUCCESS_METHOD)
        array.updateValue(String(AUTO_CLEARING.hashValue), forKey: Constants.PB_AUTO_CLEARING)
        if let user_email = USER_EMAIL {
            array.updateValue(user_email, forKey: Constants.PB_CONTACT_EMAIl)
        }
        if let user_phone = USER_PHONE {
            array.updateValue(user_phone, forKey: Constants.PB_USER_PHONE)
        }
        return array
    }
}

