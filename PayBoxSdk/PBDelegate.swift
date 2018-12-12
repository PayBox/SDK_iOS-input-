//
//  PBDelegate.swift
//  PayBoxSdk
//
//  Created by Arman Mergenbayev on 28.11.2017.
//  Copyright © 2017 paybox. All rights reserved.
//

import Foundation
public protocol PBDelegate {
    func onCardListed(cards: [Int:Card])
    func onPaymentRevoked(response: Response)
    func onPaymentPaid(response: Response)
    func onPaymentStatus(status: PStatus)
    func onCardAdded(response: Response)
    func onCardRemoved(card: Card)
    func onCardPayInited(response: Response)
    func onCardPaid(response: Response)
    func onRecurringPaid(recurringResponse: Recurring)
    func onPaymentCaptured(capture: Capture)
    func onPaymentCanceled(response: Response)
    func onError(error: ErrorResponse)
}
open class Response {
    public var status: String
    public var paymentId: String?
    public var redirectUri: String?
    
    public init(status:String, paymentId: String?, redirectUri: String?){
        self.status = status
        self.paymentId = paymentId
        self.redirectUri = redirectUri
    }
    
}
open class PStatus: Response {
    public var transactionStatus: String
    public var canReject: Bool
    public var isCaptured: Bool
    public var paymentSystem: String
    public var createDate: Date?
    public var cardPan: String
    
    public init(status: String, paymentId: String, transactionStatus: String, canReject: Bool, isCaptured: Bool, paymentSystem: String, createDate: String, cardPan: String) {
        self.transactionStatus = transactionStatus
        self.canReject = canReject
        self.isCaptured = isCaptured
        self.paymentSystem = paymentSystem
        self.createDate = ParseHelper.parser.parseToDate(date: createDate)
        self.cardPan = cardPan
        super.init(status: status, paymentId: paymentId, redirectUri: " ")
    }
}
open class Recurring : Response {
    public var recurringProfile: String
    public var recurringExpireDate: Date?
    public var currency: String
    public var amount: Float
    
    public init(status: String, paymentId: String, recurringProfile: String,
                recurringExpireDate: String, currency: String, amount: Float) {
        self.recurringProfile = recurringProfile
        self.recurringExpireDate = ParseHelper.parser.parseToDate(date: recurringExpireDate)
        self.currency = currency
        self.amount = amount
        super.init(status: status, paymentId: paymentId, redirectUri: " ")
    }
}
open class Card {
    public var status: String
    public var merchantId: String
    public var cardId: String
    public var recurringProfile: String
    public var cardHash: String
    public var date: Date?
    
    public init(status: String, merchantId: String, cardId: String, recurringProfile: String, cardHash: String, date: String) {
        self.status = status
        self.merchantId = merchantId
        self.cardId = cardId
        self.recurringProfile = recurringProfile
        self.cardHash = cardHash
        self.date = ParseHelper.parser.parseToDate(date: date)
    }
}
open class Capture : Response{
    public var amount: Float
    public var clearingAmount: Float
    public init(status: String, amount: String, clearingAmount: String) {
        self.amount = Float(amount)!
        self.clearingAmount = Float(clearingAmount)!
        super.init(status: status, paymentId: nil, redirectUri: nil)
    }
}
open class ErrorResponse {
    public var errorCode: Int
    public var errorDescription: String
    
    public init(errorCode: Int, errorDescription: String){
        self.errorCode = errorCode
        self.errorDescription = errorDescription
    }
}

