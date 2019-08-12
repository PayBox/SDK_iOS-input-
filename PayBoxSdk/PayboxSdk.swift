
import Foundation
public class PayboxSdk: SignHelper, PayboxSdkProtocol, ApiProtocol  {
    
    private var configs: ConfigurationImpl!
    private var apiHelper: ApiHelper!
    private weak var paymentView: PaymentView?
    private var paymentClearing: ((Capture?, Error?) -> Void)? = nil
    private var cardRemove: ((Card?, Error?) -> Void)? = nil
    private var paymentRecurring: ((RecurringPayment?, Error?) -> Void)? = nil
    private var paymentCancel: ((Payment?, Error?) -> Void)? = nil
    private var paymentRevoke: ((Payment?, Error?) -> Void)? = nil
    private var paymentStatus: ((Status?, Error?) -> Void)? = nil
    private var paymentPaid: ((Payment?, Error?) -> Void)? = nil
    private var cardAdded: ((Payment?, Error?) -> Void)? = nil
    private var cardList: ((Array<Card>?, Error?)-> Void)? = nil
    private var cardPayInited: ((Payment?, Error?) -> Void)? = nil
    
    public static func initialize(merchantId: Int, secretKey: String) -> PayboxSdkProtocol {
        return PayboxSdk(merchantId: merchantId, secretKey: secretKey)
    }
    
    private init(merchantId: Int, secretKey: String) {
        super.init(secretKey: secretKey)
        self.apiHelper = ApiHelper(secretKey: secretKey, listener: self)
        self.configs = ConfigurationImpl(merchantId: merchantId)
    }
    public func setPaymentView(paymentView: PaymentView) {
        self.paymentView = paymentView
    }
    
    public func createPayment(amount: Float, description: String, orderId: String?, userId: String?, extraParams: [String : String]?, paymentPaid: @escaping (Payment?, Error?) -> Void) {
        self.paymentPaid = paymentPaid
        var params = configs.getParams(extraParams: extraParams)
        params[Params.AMOUNT] = "\(amount)"
        params[Params.DESCRIPTION] = description
        if !(orderId?.isEmpty ?? true) {
            params[Params.ORDER_ID] = orderId!
        }
        if let userID = userId {
            params[Params.USER_ID] = userID
        }
        apiHelper.initConnection(url: Urls.INIT_PAYMENT_URL, params: params)
    }
    
    public func createRecurringPayment(amount: Float, description: String, recurringProfile: String, orderId: String?, extraParams: [String : String]?, recurringPaid: @escaping (RecurringPayment?, Error?) -> Void) {
        self.paymentRecurring = recurringPaid
        var params = configs.getParams(extraParams: extraParams)
        if !(orderId?.isEmpty ?? true) {
            params[Params.ORDER_ID] = orderId!
        }
        params[Params.AMOUNT] = "\(amount)"
        params[Params.DESCRIPTION] = description
        params[Params.RECURRING_PROFILE] = recurringProfile
        apiHelper.initConnection(url: Urls.RECURRING_URL, params: params)
    }
    
    public func createCardPayment(amount: Float, userId: String, cardId: Int, description: String, orderId: String, extraParams: [String : String]?, payInited: @escaping (Payment?, Error?) -> Void) {
        self.cardPayInited = payInited
        var params = configs.getParams(extraParams: extraParams)
        params[Params.ORDER_ID] = orderId
        params[Params.AMOUNT] = "\(amount)"
        params[Params.USER_ID] = userId
        params[Params.CARD_ID] = "\(cardId)"
        params[Params.DESCRIPTION] = description
        apiHelper.initConnection(url: Urls.CARD_PAY(merchant_id: configs.merchantId)+Urls.CARDINITPAY, params: params)
    }
    
    public func payByCard(paymentId: Int, paymentPaid: @escaping (Payment?, Error?) -> Void) {
        var params = configs.defParams()
        params[Params.PAYMENT_ID] = "\(paymentId)"
        var url = Urls.CARD_PAY(merchant_id: configs.merchantId) + Urls.PAY + "?"
        signedParams(url: Urls.PAY, array: params).forEach({
            url += "\($0.key)=\($0.value)&"
        })
        self.paymentView?.loadPaymentPage(url: url, sucessOrFailure: {
            isSuccess in
            if isSuccess {
                paymentPaid(Payment(
                    status: "success",
                    paymentId: nil,
                    redirectUrl: nil), nil)
            } else {
                paymentPaid(nil, Error(errorCode: 10, description: Params.PAYMENT_FAILURE))
            }
        })
    }
    
    public func getPaymentStatus(paymentId: Int, statusReceived: @escaping (Status?, Error?) -> Void) {
        self.paymentStatus = statusReceived
        var params = configs.getParams()
        params[Params.PAYMENT_ID] = "\(paymentId)"
        apiHelper.initConnection(url: Urls.STATUS_URL, params: params)
    }
    
    public func makeRevokePayment(paymentId: Int, amount: Float, revoked: @escaping (Payment?, Error?) -> Void) {
        self.paymentRevoke = revoked
        var params = configs.getParams()
        params[Params.PAYMENT_ID] = "\(paymentId)"
        params[Params.REFUND_AMOUNT] = "\(amount)"
        apiHelper.initConnection(url: Urls.REVOKE_URL, params: params)
    }
    
    public func makeClearingPayment(paymentId: Int, amount: Float?, cleared: @escaping (Capture?, Error?) -> Void) {
        self.paymentClearing = cleared
        var params = configs.getParams()
        params[Params.PAYMENT_ID] = "\(paymentId)"
        if let amount = amount {
            params[Params.CLEARING_AMOUNT] = "\(amount)"
        }
        apiHelper.initConnection(url: Urls.CLEARING_URL, params: params)
    }
    
    public func makeCancelPayment(paymentId: Int, canceled: @escaping (Payment?, Error?) -> Void) {
        self.paymentCancel = canceled
        var params = configs.getParams()
        params[Params.PAYMENT_ID] = "\(paymentId)"
        apiHelper.initConnection(url: Urls.CANCEL_URL, params: params)
    }
    
    public func addNewCard(postLink: String?, userId: String, cardAdded: @escaping (Payment?, Error?) -> Void) {
        self.cardAdded = cardAdded
        var params = configs.getParams()
        params[Params.USER_ID] = userId
        if !(postLink ?? "").isEmpty {
            params[Params.POST_LINK] = postLink!
        }
        apiHelper.initConnection(url: Urls.CARD_MERCHANT(merchant_id: configs.merchantId) + Urls.ADDCARD_URL, params: params)
    }
    
    public func removeAddedCard(cardId: Int, userId: String, removed: @escaping (Card?, Error?) -> Void) {
        self.cardRemove = removed
        var params = configs.getParams()
        params[Params.CARD_ID] = "\(cardId)"
        params[Params.USER_ID] = userId
        apiHelper.initConnection(url: Urls.CARD_MERCHANT(merchant_id: configs.merchantId) + Urls.REMOVECARD_URL, params: params)
    }
    
    public func getAddedCards(userId: String, cardList: @escaping (Array<Card>?, Error?) -> Void) {
        self.cardList = cardList
        var params = configs.getParams()
        params[Params.USER_ID] = userId
        apiHelper.initConnection(url: Urls.CARD_MERCHANT(merchant_id: configs.merchantId) + Urls.LISTCARD_URL, params: params)
    }
    
    public func config() -> ConfigurationProtocol {
        return configs
    }
    
    func onPaymentInited(payment: Payment?, error: Error?) {
        if !(payment?.redirectUrl ?? "").isEmpty {
            self.paymentView?.loadPaymentPage(url: payment!.redirectUrl!, sucessOrFailure: {
                isSuccess in
                if isSuccess {
                    self.paymentPaid?(payment, nil)
                } else {
                    self.paymentPaid?(nil, Error(errorCode: 10, description: Params.PAYMENT_FAILURE))
                }
            })
        }
    }
    
    func onPaymentRevoked(payment: Payment?, error: Error?) {
        self.paymentRevoke?(payment, error)
    }
    
    func onPaymentCanceled(payment: Payment?, error: Error?) {
        self.paymentCancel?(payment, error)
    }
    
    func onCapture(capture: Capture?, error: Error?) {
        self.paymentClearing?(capture, error)
    }
    
    func onPaymentStatus(status: Status?, error: Error?) {
        self.paymentStatus?(status, error)
    }
    
    func onPaymentRecurring(recurringPayment: RecurringPayment?, error: Error?) {
        self.paymentRecurring?(recurringPayment, error)
    }
    
    func onCardAdding(payment: Payment?, error: Error?) {
        if !(payment?.redirectUrl ?? "").isEmpty {
            self.paymentView?.loadPaymentPage(url: payment!.redirectUrl!, sucessOrFailure: {
                isSuccess in
                if isSuccess {
                    self.cardAdded?(payment, nil)
                } else {
                    self.cardAdded?(nil, Error(errorCode: 10, description: Params.PAYMENT_FAILURE))
                }
            })
        }
    }
    
    func onCardListing(cards: Array<Card>?, error: Error?) {
        self.cardList?(cards, error)
    }
    
    func onCardRemoved(card: Card?, error: Error?) {
        self.cardRemove?(card, error)
    }
    
    func onCardPayInited(payment: Payment?, error: Error?) {
        self.cardPayInited?(payment, error)
    }
    
}
