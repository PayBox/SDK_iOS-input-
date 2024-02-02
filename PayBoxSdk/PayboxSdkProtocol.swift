
import Foundation


public protocol PayboxSdkProtocol {
    
    /// Передайте сюда paymentView добавленный в ваш viewController
    /// - parameters:
    ///     - paymentView: webView на котором будет открываться платежнвя страница
    func setPaymentView(paymentView: PaymentView)
    
    /// Создание нового платежа
    /// - parameters:
    ///     - amount: сумма платежа
    ///     - description: комментарии, описание платежа
    ///     - orderId: ID заказа платежа
    ///     - userId: ID пользователя в системе мерчанта
    ///     - extraParams: доп. параметры мерчанта
    ///     - applePaymentInited: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.createApplePayment(amount: 100, description: "description", orderId: "01234", userId: "229", extraParams: nil) {
    ///             paymentId, error  in // Вызовется после оплаты
    ///     }
    ///
    func createApplePayment(amount: Float, description: String, orderId: String?, userId: String?, extraParams: [String : String]?, applePaymentInited: @escaping (String?, Error?) -> Void)

    /// Оплата созданного платежа, с помощью Apple Pay
    /// - parameters:
    ///     - paymentId: идентификатор платежа полученный из запроса на инициализацию платежа 'createApplePayment'
    ///     - tokenData: токен полученный от Apple Pay (с помощью PassKit)
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.confirmApplePayment(url: url, tokenData: tokenData) {
    ///             payment, error in // Вызовется после оплаты
    ///     }
    ///
    func confirmApplePayment(paymentId: String, tokenData: Data,  paymentPaid: @escaping (Payment?, Error?) -> Void)
    
    /// Создание нового платежа
    /// - parameters:
    ///     - amount: сумма платежа
    ///     - description: комментарии, описание платежа
    ///     - orderId: ID заказа платежа
    ///     - userId: ID пользователя в системе мерчанта
    ///     - extraParams: доп. параметры мерчанта
    ///     - paymentPaid: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.createPayment(amount: 100, description: "description", orderId: "01234", userId: "229", extraParams: nil) {
    ///             payment, error  in // Вызовется после оплаты
    ///     }
    ///
    func createPayment(amount: Float, description: String, orderId: String?, userId: String?, extraParams: [String:String]?, paymentPaid: @escaping (Payment?, Error?)->Void)
    
    /// Создание рекурентного платежа
    /// - parameters:
    ///     - amount: сумма платежа
    ///     - description: комментарий, описание платежа
    ///     - orderId: ID заказа платежа
    ///     - recurringProfile: рекурентный профиль в системе Paybox
    ///     - extraParams: доп. параметры мерчанта
    ///     - recurringPaid: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.createRecurringPayment(amount: 100, description: "description", recurringProfile: "223123", orderId: "01234", extraParams: nil) {
    ///             recurringPayment, error in // Вызовется после оплаты
    ///     }
    ///
    func createRecurringPayment(amount: Float, description: String, recurringProfile: String, orderId: String?, extraParams:  [String:String]?, recurringPaid: @escaping (RecurringPayment?, Error?)->Void)
    
    /// Проведение безакцептного списания
    /// - parameters:
    ///     - paymentId: ID платежа в системе Paybox
    ///     - paymentPaid: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.createNonAcceptancePayment(paymentId: 2331231) {
    ///             payment, error in // Вызовется после оплаты
    ///     }
    ///
    func createNonAcceptancePayment(paymentId: Int, paymentPaid: @escaping (Payment?, Error?) -> Void)
    
    /// Создание платежа добавленной картой
    /// - parameters:
    ///     - amount: сумма платежа
    ///     - description: комментарии, описание платежа
    ///     - orderId: ID заказа платежа
    ///     - userId: ID пользователя в системе мерчанта
    ///     - cardId: ID сохраненной карты в системе Paybox
    ///     - extraParams: доп. параметры мерчанта
    ///     - payInited: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.createCardPayment(amount: 100, userId: "229", cardId: 123123, description: "description", orderId: "01234", extraParams: nil) {
    ///             payment, error in // Вызовется после создания
    ///     }
    ///
    @available(*, deprecated, message: "Use createCardPayment(amount:userId:cardToken:description:orderId:extraParams:payInited:) instead")
    func createCardPayment(amount: Float, userId: String, cardId: Int, description: String, orderId: String, extraParams: [String:String]?, payInited: @escaping (Payment?, Error?)->Void)
    
    /// Создание платежа токенизированной картой
    /// - parameters:
    ///     - amount: сумма платежа
    ///     - description: комментарии, описание платежа
    ///     - orderId: ID заказа платежа
    ///     - userId: ID пользователя в системе мерчанта
    ///     - cardToken: Токен сохраненной карты в системе Paybox
    ///     - extraParams: доп. параметры мерчанта
    ///     - payInited: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.createCardPayment(amount: 100, userId: "229", cardToken: "abcdefghjk", description: "description", orderId: "01234", extraParams: nil) {
    ///             payment, error in // Вызовется после создания
    ///     }
    ///
    func createCardPayment(amount: Float, userId: String, cardToken: String, description: String, orderId: String, extraParams: [String:String]?, payInited: @escaping (Payment?, Error?)->Void)
    
    /// Оплата созданного платежа, добавленной картой
    /// - parameters:
    ///     - paymentId: ID платежа в системе Paybox
    ///     - paymentPaid: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.payByCard(paymentId: 2331231) {
    ///             payment, error in // Вызовется после оплаты
    ///     }
    ///
    func payByCard(paymentId: Int, paymentPaid: @escaping (Payment?, Error?)->Void)
    
    /// Получить статус платежа
    /// - parameters:
    ///     - paymentId: ID платежа в системе Paybox
    ///     - statusReceived: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.getPaymentStatus(paymentId: 2331231) {
    ///             status, error in // Вызовется после получения ответа
    ///     }
    ///
    func getPaymentStatus(paymentId: Int, statusReceived: @escaping (Status?, Error?)->Void)
    
    /// Провести возврат платежа
    /// - parameters:
    ///     - paymentId: ID платежа в системе Paybox
    ///     - amount: сумма платежа
    ///     - revoked: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.makeRevokePayment(paymentId: 2331231, amount: 100) {
    ///             payment, error in // Вызовется после возврата
    ///     }
    ///
    func makeRevokePayment(paymentId: Int, amount: Float, revoked: @escaping (Payment?, Error?)->Void)
    
    /// Провести клиринг платежа
    /// - parameters:
    ///     - paymentId: ID платежа в системе Paybox
    ///     - amount: сумма платежа
    ///     - cleared: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.makeClearingPayment(paymentId: 2331231, amount: 100) {  // Если указать nil вместо суммы клиринга, то клиринг пройдет на всю сумму платежа
    ///             capture, error in // Вызовется после клиринга
    ///     }
    ///
    func makeClearingPayment(paymentId: Int, amount: Float?, cleared: @escaping (Capture?, Error?)->Void)
    
    /// Провести отмену платежа
    /// - parameters:
    ///     - paymentId: ID платежа в системе Paybox
    ///     - canceled: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.makeCancelPayment(paymentId: 2331231) {
    ///             payment, error in // Вызовется после отмены
    ///     }
    ///
    func makeCancelPayment(paymentId: Int, canceled: @escaping (Payment?, Error?)->Void)
    
    /// Сохранение новой карты в системе Paybox
    /// - parameters:
    ///     - userId: ID пользователя в системе мерчанта
    ///     - postLink: ссылка на сервис мерчанта, будет вызван после сохранения карты
    ///     - cardAdded: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.addNewCard(postLink: "url", userId: 229) {
    ///             payment, error in // Вызовется после сохранения
    ///     }
    ///
    func addNewCard(postLink: String?, userId: String, cardAdded: @escaping (Payment?, Error?)->Void)
    
    /// Удаление сохраненой карты
    /// - parameters:
    ///     - cardId: ID сохраненной карты в системе Paybox
    ///     - userId: ID пользователя в системе мерчанта
    ///     - removed: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.removeAddedCard(cardId: 123123, userId: "229") {
    ///             payment, error in // Вызовется после ответа
    ///     }
    ///
    func removeAddedCard(cardId: Int, userId: String, removed: @escaping (Card?, Error?)->Void)
    
    /// Получить список сохраненых карт
    /// - parameters:
    ///     - userId: ID пользователя в системе мерчанта
    ///     - cardList: callback от Api Paybox
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.getAddedCards(userId: "229") {
    ///             cards, error in // Вызовется после получения ответа
    ///     }
    ///
    func getAddedCards(userId: String, cardList: @escaping (Array<Card>?, Error?)->Void)
    
    /// Настройки Sdk
    ///
    /// - returns: Configuration
    ///
    func config()-> ConfigurationProtocol
}
