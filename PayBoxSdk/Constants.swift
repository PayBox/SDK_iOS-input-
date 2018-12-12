//
//  Constants.swift
//  PayBoxSdk
//
//  Created by Arman Mergenbayev on 22.11.2017.
//  Copyright © 2017 paybox. All rights reserved.
//

import Foundation

public struct Constants {
    public static let PB_URL = "http://paybox.money/"
    public static let PB_MAIN_URL = "https://paybox.kz/"
    public static let PB_ENTRY_URL = "init_payment.php"
    public static let PB_STATUS_URL = "get_status.php"
    public static let PB_REVOKE_URL = "revoke.php"
    public static let PB_CANCEL_URL = "cancel.php"
    public static let PB_DO_CAPTURE_URL = "do_capture.php"
    public static let PB_RECURRING_URL = "make_recurring_payment.php"
    private static let PB_CARD_URL_1 = PB_MAIN_URL+"v1/merchant/"
    private static let PB_CARD_URL_2 = "/cardstorage/"
    private static let PB_CARD_URL_3 = "/card/"
    public static let PB_LISTCARD_URL = "list"
    public static let PB_CARDINITPAY = "init"
    public static let PB_CARDPAY = "pay"
    public static let PB_ADDCARD_URL = "add"
    public static let PB_REMOVECARD_URL = "remove"
    public static func PB_CARDPAY_MERCHANT(merchantId: Int)->String{
        return PB_CARD_URL_1+String(merchantId)+PB_CARD_URL_3
    }
    public static func PB_CARD_MERCHANT(merchantId: Int)->String{
        return PB_CARD_URL_1+String(merchantId)+PB_CARD_URL_2
    }
    public static let CARDADDCHECK = "cardstorage/pay?"
    public static let SUCCESS = Constants.PB_MAIN_URL+"success"
    public static let FAILURE = Constants.PB_MAIN_URL+"failure"
    public static let CUSTOMER = "customer="
    public enum CURRENCY: String {
        case KZT = "KZT"
        case USD = "USD"
        case RUB = "RUB"
        case EUR = "EUR"
        case KGS = "KGS"
    }
    public enum LANGUAGE: String {
        case ru = "ru"
        case en = "en"
    }
    public static let PB_REDIRECT_URL = "pg_redirect_url";
    
    public enum PAYMENT_SYSTEM: String {
        case KAZPOSTKZT = "KAZPOSTKZT"
        case CYBERPLATKZT = "CYBERPLATKZT"
        case CONTACTKZT = "CONTACTKZT"
        case SBERONLINEKZT = "SBERONLINEKZT"
        case ONLINEBANK = "ONLINEBANK"
        case CASHBYCODE = "CASHBYCODE"
        case KASPIKZT = "KASPIKZT"
        case KAZPOSTYANDEX = "KAZPOSTYANDEX"
        case SMARTBANKKZT = "SMARTBANKKZT"
        case NURBANKKZT = "NURBANKKZT"
        case BANKRBK24KZT = "BANKRBK24KZT"
        case ALFACLICKKZT = "ALFACLICKKZT"
        case FORTEBANKKZT = "FORTEBANKKZT"
        case EPAYWEBKGS = "EPAYWEBKGS"
        case EPAYKGS = "EPAYKGS"
        case HOMEBANKKZT = "HOMEBANKKZT"
        case EPAYKZT = "EPAYKZT"
        case KASSA24 = "KASSA24"
        case P2PKKB = "P2PKKB"
        case EPAYWEBKZT = "EPAYWEBKZT"
    }
    public enum REQUEST_METHOD: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    public static let INTERNET_ERROR: [Int:String] = [101:"Ошибка соединения"];
    public static let FAILURE_ERROR = "Операция прошла неуспешно"
    public static let CANCEL_WEBVIEW = "Назад"
    //CARD
    public static let PB_CARD_CREATED_AT = "created_at";
    public static let PB_CARD_DELETED_AT = "deleted_at";
    public static let PB_USER_ID = "pg_user_id";
    public static let PB_POST_URL = "pg_post_link";
    public static let PB_BACK_URL = "pg_back_link";
    public static let PB_CARD_ID = "pg_card_id";
    public static let PB_CARD_PAN = "pg_card_pan";
    public static let PB_CARD_HASH = "pg_card_hash";
    public static let PB_RECURRING_PROFILE_ID = "pg_recurring_profile_id";
    public static let CARD = "card";
    
    //RECURING
    public static let PB_RECURRING_PROFILE = "pg_recurring_profile";
    public static let PB_CREATE_DATE = "pg_create_date";
    public static let PB_TRANSACTION_STATUS = "pg_transaction_status";
    public static let PB_CAN_REJECT = "pg_can_reject";
    public static let PB_CAPTURED = "pg_captured";
    public static let PB_ACCEPTED_PAYSYSTEM = "pg_accepted_payment_systems";
    public static let PB_RECURRING_EXPIRE_DATE = "pg_recurring_profile_expiry_date";
    
    // RESPONSE
    public static let RESPONSE = "response";
    public static let PB_STATUS = "pg_status";
    public static let PB_ERROR_CODE = "pg_error_code";
    public static let PB_ERROR_DESCRIPTION = "pg_error_description";
    public static let STATUS_ERROR = "error";
    
    // CLEARING
    public static let PB_CLEARING_AMOUNT = "pg_clearing_amount";
    
    //  REFUND
    public static let PB_PAYMENT_ID = "pg_payment_id";
    public static let PB_REFUND_AMOUNT = "pg_refund_amount";
    
    //  INIT_PAYMENT
    public static let PB_AUTO_CLEARING = "pg_auto_clearing";
    public static let PB_MERCHANT_ID = "pg_merchant_id"; //NOT NULL
    public static let PB_ORDER_ID = "pg_order_id";
    public static let PB_AMOUNT = "pg_amount"; //NOT NULL
    public static let PB_CURRENCY = "pg_currency";
    public static let PB_CHECK_URL = "pg_check_url";
    public static let PB_RESULT_URL = "pg_result_url";
    public static let PB_REFUND_URL = "pg_refund_url";
    public static let PB_CAPTURE_URL = "pg_capture_url";
    public static let PB_REQUEST_METHOD = "pg_request_method";
    public static let PB_SUCCESS_URL = "pg_success_url";
    public static let PB_FAILURE_URL = "pg_failure_url";
    public static let PB_SUCCESS_METHOD = "pg_success_url_method";
    public static let PB_FAILURE_METHOD = "pg_failure_url_method";
    public static let PB_STATE_URL = "pg_state_url";
    public static let PB_STATE_METHOD = "pg_state_url_method";
    public static let PB_SITE_URL = "pg_site_url";
    public static let PB_PAYMENT_SYSTEM = "pg_payment_system";
    public static let PB_LIFETIME = "pg_lifetime";
    public static let PB_ENCODING = "pg_encoding";
    public static let PB_DESCRIPTION = "pg_description"; //NOT NULL
    public static let PB_USER_PHONE = "pg_user_phone";
    public static let PB_CONTACT_EMAIl = "pg_user_contact_email";
    public static let PB_USER_MONEY_EMAIL = "pg_user_email";
    public static let PB_USER_IP = "pg_user_ip";
    public static let PB_POSTPONE_PAYMENT = "pg_postpone_payment";
    public static let PB_LANGUAGE = "pg_language";
    public static let PB_TESTING_MODE = "pg_testing_mode";
    public static let PB_RECURRING_START = "pg_recurring_start";
    public static let PB_RECURRING_LIFETIME = "pg_recurring_lifetime";
    public static let PB_SALT = "pg_salt"; //NOT NULL
    public static let PB_SIG = "pg_sig"; //NOT NULL
}
