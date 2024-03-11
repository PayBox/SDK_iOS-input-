
import Foundation

class Urls {
    static let DEFAULT_FREEDOM_URL = "https://api.freedompay.money/"
    static let RU_PAYBOX_URL = "https://api.paybox.ru/"
    static let UZ_FREEDOM_URL = "https://api.freedompay.uz/"
    static let CUSTOMER_DEFAULT_URL = "https://customer.freedompay.money"
    static let CUSTOMER_RU_URL = "https://customer.paybox.ru"
    static let CUSTOMER_UZ_URL = "https://customer.freedompay.uz"
    static let CARDSTORAGE = "/cardstorage/"
    static let CARD = "/card/"
    static let PAY_ROUTE = "/pay/"
    static let LISTCARD_URL = "list"
    static let CARDINITPAY = "init"
    static let ADDCARD_URL = "add"
    static let DIRECT = "direct"
    static let PAY = "pay"
    static let REMOVECARD_URL = "remove"
    
    static var region: Region = .DEFAULT
    
    static func getBaseUrl() -> String {
        switch region {
        case .DEFAULT:
            return DEFAULT_FREEDOM_URL
        case .RU:
            return RU_PAYBOX_URL
        case .UZ:
            return UZ_FREEDOM_URL
        }
    }
    
    static func getCustomerUrl() -> String {
        switch region {
        case .DEFAULT:
            return CUSTOMER_DEFAULT_URL
        case .RU:
            return CUSTOMER_RU_URL
        case .UZ:
            return CUSTOMER_UZ_URL
        }
    }
    
    static func getCustomerDomain() -> String {
        var domain = ""
        switch region {
        case .DEFAULT:
            domain = CUSTOMER_DEFAULT_URL
        case .RU:
            domain = CUSTOMER_RU_URL
        case .UZ:
            domain = CUSTOMER_UZ_URL
        }
        
        domain = domain.replacingOccurrences(of: "https://", with: "")
        
        return domain
    }
    
    static func statusUrl() -> String {
        return getBaseUrl() + "get_status.php"
    }
    
    static func initPaymentUrl() -> String {
        return getBaseUrl() + "init_payment.php"
    }
    
    static func revokeUrl() -> String {
        return getBaseUrl() + "revoke.php"
    }
    
    static func cancelUrl() -> String {
        return getBaseUrl() + "cancel.php"
    }
    
    static func clearingUrl() -> String {
        return getBaseUrl() + "do_capture.php"
    }
    
    static func recurringUrl() -> String {
        return getBaseUrl() + "make_recurring_payment.php"
    }
    
    static func successUrl() -> String {
        return getBaseUrl() + "success"
    }
    
    static func failureUrl() -> String {
        return getBaseUrl() + "failure"
    }
    
    static func nonAcceptanceDirect(merchant_id: Int) -> String {
        return getBaseUrl() + "v1/merchant/\(merchant_id)" + CARD + DIRECT
    }
    
    static func cardPay(merchant_id: Int) -> String {
        return getBaseUrl() + "v1/merchant/\(merchant_id)" + CARD
    }
    
    static func cardMerchant(merchant_id: Int) -> String {
        return getBaseUrl() + "v1/merchant/\(merchant_id)" + CARDSTORAGE
    }
    
    static func confirmApplePayUrl(paymentId: String) -> String {
        return getCustomerUrl() + PAY_ROUTE + paymentId + "/" + PAY
    }
}

class Params {
    static let RECURRING_PROFILE_ID = "pg_recurring_profile_id"
    static let CARD_CREATED_AT = "created_at"
    static let RESPONSE = "response"
    static let DATA = "data"
    static let PAYMENT_FAILURE = "Не удалось оплатить"
    static let UNKNOWN_ERROR = "Неизвестная ошибка"
    static let CONNECTION_ERROR = "Ошибка подключения"
    static let FORMAT_ERROR = "Неправильный формат ответа"
    static let PAYMENT_ERROR = "Ошибка при проведении платежа"
    static let RECURRING_PROFILE_EXPIRY = "pg_recurring_profile_expiry_date"
    static let CLEARING_AMOUNT = "pg_clearing_amount"
    static let REFUND_AMOUNT = "pg_refund_amount"
    static let ERROR_CODE = "pg_error_code"
    static let ERROR_DESCRIPTION = "pg_error_description"
    static let CAPTURED = "pg_captured"
    static let CARD_PAN = "pg_card_pan"
    static let CREATED_AT = "pg_create_date"
    static let TRANSACTION_STATUS = "pg_transaction_status"
    static let CAN_REJECT = "pg_can_reject"
    static let REDIRECT_URL = "pg_redirect_url"
    static let MERCHANT_ID = "pg_merchant_id"
    static let SIG = "pg_sig"
    static let SALT = "pg_salt"
    static let STATUS = "pg_status"
    static let CARD_ID = "pg_card_id"
    static let CARD_TOKEN = "pg_card_token"
    static let CARD_HASH = "pg_card_hash"
    static let TEST_MODE = "pg_testing_mode"
    static let RECURRING_START = "pg_recurring_start"
    static let AUTOCLEARING = "pg_auto_clearing"
    static let REQUEST_METHOD = "pg_request_method"
    static let CURRENCY = "pg_currency"
    static let LIFETIME = "pg_lifetime"
    static let ENCODING = "pg_encoding"
    static let RECURRING_LIFETIME = "pg_recurring_lifetime"
    static let PAYMENT_SYSTEM = "pg_payment_system"
    static let SUCCESS_METHOD = "pg_success_url_method"
    static let FAILURE_METHOD = "pg_failure_url_method"
    static let SUCCESS_URL = "pg_success_url"
    static let FAILURE_URL = "pg_failure_url"
    static let BACK_LINK = "pg_back_link"
    static let POST_LINK = "pg_post_link"
    static let LANGUAGE = "pg_language"
    static let USER_PHONE = "pg_user_phone"
    static let USER_CONTACT_EMAIL = "pg_user_contact_email"
    static let USER_EMAIL = "pg_user_email"
    static let CAPTURE_URL = "pg_capture_url"
    static let REFUND_URL = "pg_refund_url"
    static let RESULT_URL = "pg_result_url"
    static let CHECK_URL = "pg_check_url"
    static let USER_ID = "pg_user_id"
    static let ORDER_ID = "pg_order_id"
    static let DESCRIPTION = "pg_description"
    static let RECURRING_PROFILE = "pg_recurring_profile"
    static let AMOUNT = "pg_amount"
    static let PAYMENT_ID = "pg_payment_id"
    static let CUSTOMER = "customer"
    static let TIMEOUT_AFTER_PAYMENT = "pg_timeout_after_payment"
    static let PAYMMENT_ROUTE = "pg_payment_route"
    static let APPLE_PAY = "apple_pay"
    static let TYPE = "type"
    static let DOMAIN = "domain"
    static let SDK_DOMAIN = "mobileapp.freedompay.money"
    static let TOKEN = "token"
    static let TAG_DATA = "data"
    static let TAG_HEADER = "header"
    static let TAG_STATUS = "status"
    static let STATUS_OK = "ok"
    static let TAG_BACK_URL = "back_url"
    static let TAG_URL = "url"
    static let TAG_PARAMS = "params"
    static let TAG_CODE = "code"
    static let TAG_MESSAGE = "message"
    static let TAG_PAYMENT_DATA = "paymentData"
    static let TAG_PAYMENT_SIGNATURE = "paymentSignature"
    static let TAG_PAYMENT_ENCRYPTION = "paymentTransactionEncryption"
    static let TAG_PAYMENT_PUBLIC_KEY = "paymentEphemeralPublicKey"
    static let TAG_SIGNATURE = "signature"
    static let TAG_VERSION = "version"
    static let TAG_PUBLICK_KEY = "ephemeralPublicKey"
    static let TAG_PAYMENT_PUBLIC_KEY_HASH = "paymentPublicKeyHash"
    static let TAG_PAYMENT_TRANSACTION_ID = "paymentTransactionId"
    static let TAG_PUBLIC_KEY_HASH = "publicKeyHash"
    static let TAG_TRANSACTION_ID = "transactionId"
}
