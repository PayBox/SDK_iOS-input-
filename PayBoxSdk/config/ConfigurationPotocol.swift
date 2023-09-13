

import Foundation

/// Настройки Sdk
///
public protocol ConfigurationProtocol {
    
    /// Установка номера телефона клиента, будет отображаться на платежной странице. Если не указать, то будет предложено ввести на платежной странице
    /// - parameters:
    ///     - userPhone: номер телефона клиента
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setUserPhone(userPhone: "+77771231234")
    ///
    func setUserPhone(userPhone: String)
    
    /// Установка email клиента, будет отображаться на платежной странице. Если не указать email, то будет предложено ввести на платежной странице
    /// - parameters:
    ///     - userEmail: email клиента
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setUserEmail(userEmail: "email")
    ///
    func setUserEmail(userEmail: String)
    
    /// Установка тестового режима
    /// - parameters:
    ///     - enabled: true или false
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().testMode(enabled: true) // По умолчанию тестовый режим включен
    ///
    func testMode(enabled: Bool)
    
    /// Установка платежной системы
    /// - parameters:
    ///     - paymentSystem: платежная система
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setPaymentSystem(paymentSystem: .EPAYWEBKZT)
    ///
    func setPaymentSystem(paymentSystem: PaymentSystem)
    
    /// Установка метода вызова сервиса мерчанта, для обращения от системы Paybox к системе мерчанта по ссылкам checkUrl, resultUrl, refundUrl, clearingUrl
    /// - parameters:
    ///     - requestMethod: метод запроса
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setRequestMethod(requestMethod: .POST)
    ///
    func setRequestMethod(requestMethod: RequestMethod)
    
    /// Установка языка платежной страницы
    /// - parameters:
    ///     - language: язык
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setLanguage(language: .ru)
    ///
    func setLanguage(language: Language)
    
    /// Установка автоклиринга платежей
    /// - parameters:
    ///     - enabled: true или false
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().autoClearing(enabled: true)
    ///
    func autoClearing(enabled: Bool)
    
    /// Установка кодировки
    /// - parameters:
    ///     - encoding: кодировка, по умолчанию UTF-8
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setEncoding(encoding: "UTF-8")
    ///
    func setEncoding(encoding: String)
    
    /// Установка времени жизни рекурентного профиля
    /// - parameters:
    ///     - lifetime: время жизни (в месяцах), по умолчанию 36 месяцев
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setRecurringLifetime(lifetime: 36)
    ///
    func setRecurringLifetime(lifetime: Int)
    
    /// Установка времени жизни платежной страницы, в течение которого платеж должен быть завершен
    /// - parameters:
    ///     - lifetime: время жизни (в секундах), по умолчанию 300 секунд
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setPaymentLifetime(lifetime: 300)
    ///
    func setPaymentLifetime(lifetime: Int)
    
    /// Установка включения режима рекурентного платежа
    /// - parameters:
    ///     - enabled: true или false, по умолчанию false
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().recurringMode(enabled: false)
    ///
    func recurringMode(enabled: Bool)
    
    /// Установка ссылки на сервис мерчанта, для проверки возможности платежа. Вызывается перед платежом, если платежная система предоставляет такую возможность
    /// - parameters:
    ///     - url: ссылка
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setCheckUrl(url: "url")
    ///
    func setCheckUrl(url: String)
    
    /// Установка ссылки на сервис мерчанта, для сообщения о результате платежа. Вызывается после платежа в случае успеха или неудачи
    /// - parameters:
    ///     - url: ссылка
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setResultUrl(url: "url")
    ///
    func setResultUrl(url: String)
    
    /// Установка ссылки на сервис мерчанта, для сообщения о результате платежа. для сообщения об отмене платежа. Вызывается после платежа в случае отмены платежа на стороне PayBoxа или ПС
    /// - parameters:
    ///     - url: ссылка
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setRefundUrl(url: "url")
    ///
    func setRefundUrl(url: String)
    
    /// Установка ссылки на сервис мерчанта, для сообщения о проведении клиринга платежа по банковской карте
    /// - parameters:
    ///     - url: ссылка
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setClearingUrl(url: "url")
    ///
    func setClearingUrl(url: String)
    
    /// Установка кода валюты, в которой указана сумма
    /// - parameters:
    ///     - code: код вылюты, пример: KZT, USD, EUR
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setCurrencyCode(code: "KZT")
    ///
    func setCurrencyCode(code: String)
    
    /// Установка требования по отображению фрейма
    /// - parameters:
    ///     - isRequired: требуется ли заменить платежную страницу на frame
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setFrameRequired(isRequired: true)
    ///
    func setFrameRequired(isRequired: Bool)
    
    /// Установка региона
    /// - parameters:
    ///     - region: выбор региона работы
    ///
    /// Пример кода:
    /// ----
    ///
    ///     sdk.config().setRegion(region: .DEFAULT)
    ///
    func setRegion(region: Region)
}
