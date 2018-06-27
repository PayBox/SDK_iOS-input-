//
//  PBSdkHelper.swift
//  PayBoxSdk
//
//  Created by Arman Mergenbayev on 22.11.2017.
//  Copyright © 2017 paybox. All rights reserved.
//

import Foundation

open class PBHelper : PBConnection {
    
    private static var configuration: PBConfiguration!
    public enum OPERATION {
        case PAYMENT
        case REVOKE
        case CANCEL
        case CAPTURE
        case RECURRING
        case GETSTATUS
        case CARDLIST
        case CARDADD
        case CARDREMOVE
        case CARDINITPAY
        case CARDPAY
    }
    private let parser = ParseHelper.parser
    private static var viewController : UIViewController?
    private var responseXml: String?
    private static var sharedInstance : PBHelper?
    private static var callBackDelegate : PBDelegate?
    public static var sdk: PBHelper{
        if sharedInstance==nil {
            fatalError("Please init Builder")
        }
        return sharedInstance!
    }
    
    
    func onErrorResponse(response: [Int : String]) {
        PBHelper.callBackDelegate?.onError(error: ErrorResponse(errorCode: (response.first?.key)!, errorDescription: (response.first?.value)!))
    }
    
    func onSuccessConnection(command: PBHelper.OPERATION, response: String) {
        switch (command) {
        case .CARDADD:
            if isOkFrom(xml: response) {
                responseXml = response
                let url = parser.stringFrom(xml: response, name: Constants.PB_REDIRECT_URL)
                showWebView(url: url, operation: .CARDADD)
            }
            break
        case .CARDINITPAY:
            if isOkFrom(xml: response) {
                responseXml = response
                PBHelper.callBackDelegate?.onCardPayInited(response: getResponse(response: response))
            }
            break
        case .GETSTATUS:
            if isOkFrom(xml: response) {
                PBHelper.callBackDelegate?.onPaymentStatus(status: PStatus(status: parser.stringFrom(xml: response, name: Constants.PB_STATUS), paymentId: parser.stringFrom(xml: response, name: Constants.PB_PAYMENT_ID), transactionStatus: parser.stringFrom(xml: response, name: Constants.PB_TRANSACTION_STATUS), canReject: Int(parser.stringFrom(xml: response, name: Constants.PB_CAN_REJECT)) == 1 ? true : false, isCaptured: Int(parser.stringFrom(xml: response, name: Constants.PB_CAPTURED)) == 1 ? true : false, paymentSystem: parser.stringFrom(xml: response, name: Constants.PB_PAYMENT_SYSTEM), createDate: parser.stringFrom(xml: response, name: Constants.PB_CREATE_DATE), cardPan: parser.stringFrom(xml: response, name: Constants.PB_CARD_PAN)))
                
            }
            break
        case .PAYMENT:
            if isOkFrom(xml: response) {
                responseXml = response
                let url = parser.stringFrom(xml: response, name: Constants.PB_REDIRECT_URL)
                showWebView(url: url, operation: .PAYMENT)
            }
            break
        case .CARDLIST:
            PBHelper.callBackDelegate?.onCardListed(cards: parser.cardFrom(xml: response))
            break
        case .CARDREMOVE:
            PBHelper.callBackDelegate?.onCardRemoved(card: Card(status: parser.stringFrom(xml: response, name: Constants.PB_STATUS), merchantId: parser.stringFrom(xml: response, name: Constants.PB_MERCHANT_ID), cardId: parser.stringFrom(xml: response, name: Constants.PB_CARD_ID), recurringProfile: parser.stringFrom(xml: response, name: Constants.PB_RECURRING_PROFILE), cardHash: parser.stringFrom(xml: response, name: Constants.PB_CARD_HASH),
                                                                   date: parser.stringFrom(xml: response, name: Constants.PB_CARD_DELETED_AT)))
            break
        case .RECURRING:
            if isOkFrom(xml: response) {
                PBHelper.callBackDelegate?.onRecurringPaid(recurringResponse: Recurring(status: parser.stringFrom(xml: response, name: Constants.PB_STATUS), paymentId: parser.stringFrom(xml: response, name: Constants.PB_PAYMENT_ID), recurringProfile: parser.stringFrom(xml: response, name: Constants.PB_RECURRING_PROFILE), recurringExpireDate: parser.stringFrom(xml: response, name: Constants.PB_RECURRING_EXPIRE_DATE), currency: parser.stringFrom(xml: response, name: Constants.PB_CURRENCY), amount: Int(parser.stringFrom(xml: response, name: Constants.PB_AMOUNT))!))
            }
            break
        case .REVOKE:
            if isOkFrom(xml: response) {
                PBHelper.callBackDelegate?.onPaymentRevoked(response: getResponse(response: response))
            }
            break
        case .CANCEL:
            if isOkFrom(xml: response) {
                PBHelper.callBackDelegate?.onPaymentCanceled(response: getResponse(response: response))
            }
            break
        case .CAPTURE:
            if isOkFrom(xml: response) {
                PBHelper.callBackDelegate?.onPaymentCaptured(capture: Capture(status: parser.stringFrom(xml: response, name: Constants.PB_STATUS), amount: parser.stringFrom(xml: response, name: Constants.PB_AMOUNT), clearingAmount: parser.stringFrom(xml: response, name: Constants.PB_CLEARING_AMOUNT)))
            }
            break
        default:
            break
        }
    }
    private func getResponse(response: String)->Response {
        return Response(status: parser.stringFrom(xml: response, name: Constants.PB_STATUS), paymentId: parser.stringFrom(xml: response, name: Constants.PB_PAYMENT_ID), redirectUri: parser.stringFrom(xml: response, name: Constants.PB_REDIRECT_URL))
    }
    private func isOkFrom(xml: String)->Bool{
        if parser.isXml(xml: xml) {
            let response = xml.components(separatedBy: "<response>")
            if !response.isEmpty {
                let status = response[1].components(separatedBy: "<"+Constants.PB_STATUS+">")
                if status.count > 1 {
                    if status[1].components(separatedBy: "</"+Constants.PB_STATUS+">")[0] != "error" ? true : false {
                        return true
                    } else {
                        PBHelper.callBackDelegate?.onError(error: ErrorResponse(errorCode: Int(parser.stringFrom(xml: xml, name: Constants.PB_ERROR_CODE))!, errorDescription: parser.stringFrom(xml: xml, name: Constants.PB_ERROR_DESCRIPTION)))
                        return false
                    }
                }
            }
        } else {
            onErrorResponse(response: [0:Constants.FAILURE_ERROR])
        }
        return false
    }
    private func showWebView(url: String, operation: PBHelper.OPERATION){
        let webView: WebController = WebController(url: url, helper: self, operation: operation)
        guard let view = PBHelper.viewController else {
            return
        }
        view.present(webView, animated: true, completion: nil)
    }
    public var defParameters: [String:String] {
        var params: [String:String] = [:]
        params.updateValue(String(PBHelper.configuration.MERCHANT_ID), forKey: Constants.PB_MERCHANT_ID)
        params.updateValue(String(PBHelper.configuration.isTEST.hashValue), forKey: Constants.PB_TESTING_MODE)
        return params
    }
    public func cardPay(paymentId: Int){
        var param = defParameters
        param.updateValue(String(paymentId), forKey: Constants.PB_PAYMENT_ID)
        var params: [(key: String, value: String)] = parser.sort(array: param)
        let sig = parser.sig(secretKey: PBHelper.configuration.secret, url: Constants.PB_CARDPAY, param: params)
        params.append((key: Constants.PB_SIG, value: sig))
        showWebView(url: parser.urlGet(from: params, mainUrl: Constants.PB_CARDPAY_MERCHANT(merchantId: PBHelper.configuration.MERCHANT_ID).appending(Constants.PB_CARDPAY)), operation: .CARDPAY)
    }
    public func initCardPayment(amount: Int, userId: String, cardId: Int, orderId: String, description: String){
        var params : [String:String] = defParameters
        params.updateValue(userId, forKey: Constants.PB_USER_ID)
        params.updateValue(String(cardId), forKey: Constants.PB_CARD_ID)
        params.updateValue(String(orderId), forKey: Constants.PB_ORDER_ID)
        params.updateValue(String(amount), forKey: Constants.PB_AMOUNT)
        params.updateValue(description, forKey: Constants.PB_DESCRIPTION)
        initial(operation: .CARDINITPAY, params: params)
    }
    public func removeCard(userId: String, cardId: Int){
        var params : [String:String] = defParameters
        params.updateValue(userId, forKey: Constants.PB_USER_ID)
        params.updateValue(String(cardId), forKey: Constants.PB_CARD_ID)
        initial(operation: .CARDREMOVE, params: params)
    }
    public func getCards(userId: String) {
        var params: [String:String] = defParameters
        params.updateValue(userId, forKey: Constants.PB_USER_ID)
        initial(operation: .CARDLIST, params: params)
    }
    public func addCard(userId: String, postUrl: String) {
        var params: [String:String] = defParameters
        params.updateValue(userId, forKey: Constants.PB_USER_ID)
        params.updateValue(postUrl, forKey: Constants.PB_POST_URL)
        params.updateValue(Constants.SUCCESS, forKey: Constants.PB_BACK_URL)
        initial(operation: .CARDADD, params: params)
    }
    public func makeRecurring(amount: Int, recurringProfile: String, description: String){
        var params: [String:String] = PBHelper.configuration.toArray
        params.updateValue(String(amount), forKey: Constants.PB_AMOUNT)
        params.updateValue(recurringProfile, forKey: Constants.PB_RECURRING_PROFILE)
        params.updateValue(description, forKey: Constants.PB_DESCRIPTION)
        initial(operation: .RECURRING, params: params)
    }
    public func initCancelPayment(paymentId: Int){
        var params: [String:String] = defParameters
        params.updateValue(String(paymentId), forKey: Constants.PB_PAYMENT_ID)
        initial(operation: .CANCEL, params: params)
    }
    public func getPaymentStatus(paymentId: Int){
        var params: [String:String] = defParameters
        params.updateValue(String(paymentId), forKey: Constants.PB_PAYMENT_ID)
        initial(operation: .GETSTATUS, params: params)
    }
    public func initRevokePayment(paymentId: Int, amount: Int){
        var params: [String:String] = defParameters
        params.updateValue(String(paymentId), forKey: Constants.PB_PAYMENT_ID)
        params.updateValue(String(amount), forKey: Constants.PB_REFUND_AMOUNT)
        initial(operation: .REVOKE, params: params)
    }
    public func initPaymentDoCapture(paymentId: Int){
        var params: [String:String] = defParameters
        params.updateValue(String(paymentId), forKey: Constants.PB_PAYMENT_ID)
        initial(operation: .CAPTURE, params: params)
    }
    public func initPayment(orderId: String?, userId: String, amount: Int, description: String){
        var params = PBHelper.configuration.toArray
        params.updateValue(userId, forKey: Constants.PB_USER_ID)
        params.updateValue(String(amount), forKey: Constants.PB_AMOUNT)
        params.updateValue(description, forKey: Constants.PB_DESCRIPTION)
        if orderId != nil {
            params.updateValue(orderId!, forKey: Constants.PB_ORDER_ID)
        }
        initial(operation: .PAYMENT, params: params)
    }
    public func webSubmited(operation: OPERATION, isSuccess: Bool){
        if isSuccess {
            switch operation {
            case .PAYMENT:
                if responseXml != nil {
                    PBHelper.callBackDelegate?.onPaymentPaid(response: getResponse(response: responseXml!))
                }
                break
            case .CARDADD:
                if responseXml != nil {
                    PBHelper.callBackDelegate?.onCardAdded(response: Response(status: parser.stringFrom(xml: responseXml!, name: Constants.PB_STATUS), paymentId: parser.stringFrom(xml: responseXml!, name: Constants.PB_PAYMENT_ID), redirectUri: parser.stringFrom(xml: responseXml!, name: Constants.PB_REDIRECT_URL)))
                }
                break
            case .CARDPAY:
                if responseXml != nil {
                    PBHelper.callBackDelegate?.onCardPaid(response: Response(status: parser.stringFrom(xml: responseXml!, name: Constants.PB_STATUS), paymentId: parser.stringFrom(xml: responseXml!, name: Constants.PB_PAYMENT_ID), redirectUri: parser.stringFrom(xml: responseXml!, name: Constants.PB_REDIRECT_URL)))
                }
                break
            default:
                break
            }
        } else {
            PBHelper.callBackDelegate?.onError(error: ErrorResponse(errorCode: 3, errorDescription: Constants.FAILURE_ERROR))
        }
    }
    private func initial(operation: OPERATION, params: [String:String]){
        PBService(command: operation, connection: self, config: params, secretKey: PBHelper.configuration.secret)
    }
    
    public class Builder {
        public init(){
            
        }
        public init(secretKey: String, merchantId: Int) {
            PBHelper.configuration = PBConfiguration(_secretKey: secretKey, _merchantId: merchantId)
        }
        
        
        open func set(secretKey: String, merchantId: Int)->Builder{
            PBHelper.configuration = PBConfiguration(_secretKey: secretKey, _merchantId: merchantId)
            return self
        }
        open func pbDelegate(delegate: UIViewController)->Builder{
            PBHelper.callBackDelegate = delegate as? PBDelegate
            PBHelper.viewController = delegate
            return self
        }
        open func paymentLifeTime(lifetime: Int)->Builder{
            PBHelper.configuration.PAYMENT_LIFETIME = lifetime
            return self
        }
        open func autoClearing(enabled: Bool)->Builder{
            PBHelper.configuration.AUTO_CLEARING = enabled
            return self
        }
        open func language(language: Constants.LANGUAGE)->Builder{
            PBHelper.configuration.LANGUAGE = language.rawValue
            return self
        }
        open func paymentCurrency(currency: Constants.CURRENCY)->Builder{
            PBHelper.configuration.CURRENCY = currency.rawValue
            return self
        }
        open func paymentSystem(system: Constants.PAYMENT_SYSTEM)->Builder{
            PBHelper.configuration.PAYMENT_SYSTEM = system.rawValue
            return self
        }
        open func testMode(enabled: Bool)->Builder{
            PBHelper.configuration.isTEST = enabled
            return self
        }
        open func userInfo(email: String, phoneNumber: String)->Builder{
            PBHelper.configuration.USER_EMAIL = email
            PBHelper.configuration.USER_PHONE = phoneNumber
            return self
        }
        open func feedBackUrl(checkUrl: String, resultUrl: String, refundUrl: String, captureUrl: String, method: Constants.REQUEST_METHOD)->Builder{
            PBHelper.configuration.CHECK_URL = checkUrl
            PBHelper.configuration.RESULT_URL = resultUrl
            PBHelper.configuration.REFUND_URL = refundUrl
            PBHelper.configuration.CAPTURE_URL = captureUrl
            PBHelper.configuration.REQUEST_METHOD = method.rawValue
            return self
        }
        open func enableRecurring(lifetime: Int)->Builder{
            PBHelper.configuration.RECURRING_LIFETIME = lifetime
            PBHelper.configuration.isRECURRING = true
            return self
        }
        open func disableRecurring()->Builder{
            PBHelper.configuration.isRECURRING = false
            return self
        }
        
        open func build()->PBHelper{
            if PBHelper.configuration != nil {
                if PBHelper.sharedInstance == nil {
                    PBHelper.sharedInstance = PBHelper()
                }
            }
            return PBHelper.sharedInstance!
        }
    }
}
