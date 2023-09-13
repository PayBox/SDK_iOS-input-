

import Foundation
class ConfigurationImpl: ConfigurationProtocol {
    
    
    public var merchantId: Int
    private var userPhone: String? = nil
    private var userEmail: String? = nil
    private var testMode = true
    private var paymentSystem = PaymentSystem.NONE
    private var requestMethod = RequestMethod.POST
    private var language = Language.ru
    private var autoClearing = false
    private var encoding = "UTF-8"
    private var paymentLifetime = 300
    private var recurringLifetime = 0
    private var recurringMode = false
    private var checkUrl: String? = nil
    private var resultUrl: String? = "https://paybox.kz"
    private var refundUrl: String? = nil
    private var captureUrl: String? = nil
    private var currencyCode: String = "KZT"
    private var isFrameRequired = false
    private var region: Region = .DEFAULT
    
    init(merchantId: Int) {
        self.merchantId = merchantId
    }
    
    func setUserPhone(userPhone: String) {
        self.userPhone = userPhone
    }
    
    func setUserEmail(userEmail: String) {
        self.userEmail = userEmail
    }
    
    func testMode(enabled: Bool) {
        self.testMode = enabled
    }
    
    func setPaymentSystem(paymentSystem: PaymentSystem) {
        self.paymentSystem = paymentSystem
    }
    
    func setRequestMethod(requestMethod: RequestMethod) {
        self.requestMethod = requestMethod
    }
    
    func setLanguage(language: Language) {
        self.language = language
    }
    
    func autoClearing(enabled: Bool) {
        self.autoClearing = enabled
    }
    
    func setEncoding(encoding: String) {
        self.encoding = encoding
    }
    
    func setRecurringLifetime(lifetime: Int) {
        self.recurringLifetime = lifetime
    }
    
    func setPaymentLifetime(lifetime: Int) {
        self.paymentLifetime = lifetime
    }
    
    func recurringMode(enabled: Bool) {
        self.recurringMode = enabled
    }
    
    func setCheckUrl(url: String) {
        self.checkUrl = url
    }
    
    func setResultUrl(url: String) {
        self.resultUrl = url
    }
    
    func setRefundUrl(url: String) {
        self.refundUrl = url
    }
    
    func setClearingUrl(url: String) {
        self.captureUrl = url
    }
    
    func setCurrencyCode(code: String) {
        self.currencyCode = code
    }
    
    func setFrameRequired(isRequired: Bool) {
        self.isFrameRequired = isRequired
    }
    
    func setRegion(region: Region) {
        self.region = region
        Urls.region = region
    }
    
    func defParams() -> [String:String] {
        var params = [String:String]()
        params[Params.MERCHANT_ID] = "\(self.merchantId)"
        params[Params.TEST_MODE] = self.testMode.stringValue()
        if (self.paymentSystem != .NONE) {
            params[Params.PAYMENT_SYSTEM] = self.paymentSystem.rawValue
        }
        return params
    }
    
    func getParams(extraParams: [String:String]? = nil) -> [String:String] {
        var params = [String:String]()
        if let extra = extraParams {
            params = extra
        }
        params[Params.MERCHANT_ID] = "\(self.merchantId)"
        params[Params.TEST_MODE] = self.testMode.stringValue()
        params[Params.AUTOCLEARING] = self.autoClearing.stringValue()
        params[Params.REQUEST_METHOD] = self.requestMethod.rawValue
        params[Params.CURRENCY] = self.currencyCode
        params[Params.LIFETIME] = "\(self.paymentLifetime)"
        params[Params.ENCODING] = self.encoding
        if(recurringMode) {
            params[Params.RECURRING_START] = self.recurringMode.stringValue()
            if(self.recurringLifetime > 0) {
                params[Params.RECURRING_LIFETIME] = "\(self.recurringLifetime)"
            }
        }
        if (self.paymentSystem != .NONE) {
            params[Params.PAYMENT_SYSTEM] = self.paymentSystem.rawValue
        }
        params[Params.TIMEOUT_AFTER_PAYMENT] = "0"
        if(self.isFrameRequired) {
            params[Params.PAYMMENT_ROUTE] = "frame"
        }
        params[Params.SUCCESS_METHOD] = "GET"
        params[Params.FAILURE_METHOD] = "GET"
        params[Params.SUCCESS_URL] = Urls.successUrl()
        params[Params.FAILURE_URL] = Urls.failureUrl()
        params[Params.BACK_LINK] = Urls.successUrl()
        params[Params.POST_LINK] = Urls.successUrl()
        params[Params.LANGUAGE] = self.language.rawValue
        if !(userPhone?.isEmpty ?? true) {
            params[Params.USER_PHONE] = userPhone
        }
        if !(userEmail?.isEmpty ?? true) {
            params[Params.USER_EMAIL] = userEmail
            params[Params.USER_CONTACT_EMAIL] = userEmail
        }
        if !(captureUrl?.isEmpty ?? true) {
            params[Params.CAPTURE_URL] = captureUrl
        }
        if !(refundUrl?.isEmpty ?? true) {
            params[Params.REFUND_URL] = refundUrl
        }
        if !(resultUrl?.isEmpty ?? true) {
            params[Params.RESULT_URL] = resultUrl
        }
        if !(checkUrl?.isEmpty ?? true) {
            params[Params.CHECK_URL] = checkUrl
        }
        return params
    }
}
extension Bool {
    func stringValue()-> String {
        return self ? "1": "0"
    }
}
