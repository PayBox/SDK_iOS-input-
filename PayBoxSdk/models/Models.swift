

import Foundation
public struct Error {
    public let errorCode: Int
    public let description: String
}

public struct Payment {
    public var status: String?
    public let paymentId: Int?
    public let redirectUrl: String?
}
public struct RecurringPayment {
    public let status: String?
    public let paymentId: Int?
    public let currency: String?
    public let amount: Float?
    public let recurringProfile: String?
    public let recurringExpireDate: String?
}

public struct Capture {
    public let status: String?
    public let amount: Float?
    public let clearingAmount: Float?
}

public struct Card {
    public let status: String?
    public let merchantId: String?
    public let cardId: String?
    public let recurringProfile: String?
    public let cardhash: String?
    public let date: String?
}

public struct RequestData {
    let params: [(key: String, value: String)]
    let method: RequestMethod
    let url: String
}

public struct ResponseData {
    let code: Int
    let response: String
    let url: String
    let error: Bool
}

public struct Status {
    public let status: String?
    public let paymentId: Int?
    public let transactionStatus: String?
    public let canReject: String?
    public let isCaptured: String?
    public let cardPan: String?
    public let createDate: String?
}

public enum Language: String {
    case ru
    case en
    case kz
    case de
}

public enum PaymentSystem: String {
    case KAZPOSTKZT
    case CYBERPLATKZT
    case CONTACTKZT
    case SBERONLINEKZT
    case ONLINEBANK
    case CASHBYCODE
    case KASPIKZT
    case KAZPOSTYANDEX
    case SMARTBANKKZT
    case NURBANKKZT
    case BANKRBK24KZT
    case ALFACLICKKZT
    case FORTEBANKKZT
    case EPAYWEBKGS
    case EPAYKGS
    case HOMEBANKKZT
    case EPAYKZT
    case KASSA24
    case P2PKKB
    case EPAYWEBKZT
}

public enum RequestMethod: String {
    case GET
    case POST
}
