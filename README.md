# Paybox SDK (iOS, Swift)

PayBox SDK iOS - это библиотека позволяющая упростить взаимодействие с API PayBox.

[Исходный код демонстрационного приложения](https://github.com/PayBox/sample-ios-swift-sdk)

<img src="https://github.com/PayBox/sample-ios-swift-sdk/raw/master/swift_init_pay.gif" width="25%" height="25%"/>

### Описание возможностей:

- Инициализация платежа
- Отмена платежа
- Возврат платежа
- Проведение клиринга
- Проведение рекуррентного платежа с сохраненными картами
- Получение информации/статуса платежа
- Добавление карт/Удаление карт
- Оплата добавленными картами
- Безакцептные платежи
- Оплата с помощью Apple Pay

# **Установка:**

1. Чтобы интегрировать "PayBoxSdk"; в проект Xcode с использованием "Cocoapods", добавьте в `Podfile`:
``` Ruby
        target 'Project name' do
            pod 'PayBoxSdk', :git => 'https://github.com/PayBox/SDK_iOS-input-.git', :submodules => true
        end
```
2. Затем выполните след. команду:
``` Batchfile      
        $ pod install
```


# Для связи с SDK

### 1. Инициализация SDK:

``` Swift
    let sdk = PayboxSdk.initialize(merchantId: merchantID, secretKey: "secretKey")
```

### 2. Добавьте PaymentView в ваш UIViewController:

``` Swift
    let paymentView = PaymentView(frame: CGRect(x: 0, y: 0, width: width, height: height))
```

### 3. Передайте экземпляр paymentView в sdk:

``` Swift
    sdk.setPaymentView(paymentView: paymentView)
```

### 4. Для отслеживания прогресса загрузки платежной страницы используйте WebDelegate:
``` Swift
    paymentView.delegate = self

    func loadStarted() {

    }
    func loadFinished() {

    }
```

---

# **Настройки SDK**

### Тестовый режим:
``` Swift
    sdk.config().testMode(enabled: true) // По умолчанию тестовый режим включен
```

### Выбор региона:
``` Swift
    sdk.config().setRegion(region: .DEFAULT) //Region.DEAFAULT по умолчанию
```
Класс `Region` имеет следующие значения:

| Параметр   | Значение                              |
|------------|---------------------------------------|
| `DEAFAULT` | Казахстан и другие страны присутствия |
| `RU`       | Россия                                |
| `UZ`       | Узбекистан                            |

### Выбор платежной системы:
``` Swift
    sdk.config().setPaymentSystem(paymentSystem: paymentSystem)
```

### Выбор валюты платежа:
``` Swift
    sdk.config().setCurrencyCode(code: "KZT")
```

### Активация автоклиринга:
``` Swift
    sdk.config().autoClearing(enabled: enabled)
```

### Установка кодировки:
``` Swift
    sdk.config().setEncoding(encoding: "UTF-8") // по умолчанию UTF-8
```

### Время жизни рекурентного профиля:
``` Swift
    sdk.config().setRecurringLifetime(lifetime: 36) //по умолчанию 0 месяцев (параметр исключается из списка при значении 0)
```

### Время жизни платежной страницы, в течение которого платеж должен быть завершен:
``` Swift
    sdk.config().setPaymentLifetime(lifetime: 300)  //по умолчанию 300 секунд
```

### Включение режима рекурентного платежа:
``` Swift
    recurringMode(enabled: enabled)  //по умолчанию отключен
```

### Номер телефона клиента, будет отображаться на платежной странице. Если не указать, то будет предложено ввести на платежной странице:
``` Swift
    sdk.config().setUserPhone(userPhone: userPhone)
```

### Email клиента, будет отображаться на платежной странице. Если не указать email, то будет предложено ввести на платежной странице:
``` Swift
    sdk.config().setUserEmail(userEmail: email)
```

### Язык платежной страницы:
``` Swift
    sdk.config().setLanguage(language: .ru)
```

### Для передачи информации от платежного гейта:
``` Swift
    sdk.config().setCheckUrl(url: url)
    sdk.config().setResultUrl(url: url)
    sdk.config().setRefundUrl(url: url)
    sdk.config().setClearingUrl(url: url)
    sdk.config().setRequestMethod(requestMethod: requestMethod)
```

### Для отображения Frame вместо платежной страницы:
``` Swift
    sdk.config().setFrameRequired(isRequired: true) //false по умолчанию
```
        
---

# **Работа с SDK**

### Создание платежа:

``` Swift
    sdk.createPayment(amount: amount, description: "description", orderId: "orderId", userId: userId, extraParams: extra) {
            payment, error in   //Вызовется после оплаты
    }
```
После вызова в paymentView откроется платежная страница


### Рекурентный платеж:
``` Swift
    sdk.createRecurringPayment(amount: amount, description: "description", recurringProfile: "profile", orderId: "orderId", extraParams: extra) {
            recurringPayment, error in // Вызовется после оплаты
    }
```

### Получение статуса платежа:
``` Swift
    sdk.getPaymentStatus(paymentId: paymentId) {
            status, error in // Вызовется после получения ответа
    }
```

### Клиринг платежа:
``` Swift
    sdk.makeClearingPayment(paymentId: paymentId, amount: amount) {  // Если указать nil вместо суммы клиринга, то клиринг пройдет на всю сумму платежа
            capture, error in // Вызовется после клиринга
    }
```

### Отмена платежа:
``` Swift
    sdk.makeCancelPayment(paymentId: paymentId) {
            payment, error in // Вызовется после отмены
    }
```

### Возврат платежа:
``` Swift
    sdk.makeRevokePayment(paymentId: paymentId, amount: amount) {
            payment, error in // Вызовется после возврата
    }
```

### Сохранение карты:
``` Swift
    sdk.addNewCard(postLink: url, userId: userId) {
            payment, error in // Вызовется после сохранения
    }
```
После вызова в paymentView откроется платежная страница

### Получить список сохраненых карт:
``` Swift
    sdk.getAddedCards(userId: userId) {
            cards, error in // Вызовется после получения ответа
    }
```

### Удаление сохраненой карты:
``` Swift
    sdk.removeAddedCard(cardId: cardId, userId: userId) {
            payment, error in // Вызовется после ответа
    }
```

### Создание платежа сохраненой картой:
``` Swift
    sdk.createCardPayment(amount: amount, userId: userId, cardToken: "cardToken", description: "description", orderId: "01234", extraParams: nil) {
            payment, error in // Вызовется после создания
    }
```
> *Внимание: Метод `createCardPayment` с использованием `cardId` является устаревшим.*
### Для оплаты созданного платежа:
``` Swift
    sdk.payByCard(paymentId: paymentId) {
            payment, error in // Вызовется после оплаты
    }
```
После вызова в paymentView откроется платежная страница для 3ds аутентификации

### Для оплаты созданного платежа c безакцепным списанием:
``` Swift
   sdk.createNonAcceptancePayment(paymentId: paymentId){
            payment, error -> //Вызовется после оплаты
   }
```

# Интеграция Apple Pay

В первую очередь необходимо создать идентификатор мерчанта и настроить сертификат обработки платежей в консоли разработчика согласно документации на [официальном сайте PassKit](https://developer.apple.com/documentation/passkit_apple_pay_and_wallet/apple_pay). После чего можно перейти к настройке проекта и самой интеграции:

### 1. Включите поддержку Apple Pay для вашего проекта в Xcode

- В окне навигации вашего проекта выделите файл проекта
- Выберите ваше приложение в меню `TARGET`
- Перейдите во вкладку `Signing & Capabilities`
- В верхнем меню нажмите кнопку `+` для того что бы добавить поддержку библиотеки Apple Pay
- В добавленном разделе библиотеки Apple Pay необходимо нажать кнопку `обновить` для синхронизации идентификаторов мерчанта с сайта Apple Developer.
- Выберите необходимый идентификатор мерчанта для работы с вашим приложением.

### 2. Импортируйте `PassKit` в ваш контроллер:
``` Swift
   import PassKit
```

### 3. Добавьте проверку состояния Apple Pay на устройстве:
``` Swift
    func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
```

### 4. Задайте список поддерживаемых МПС:
``` Swift
    let supportedNetworks: [PKPaymentNetwork] = [
        .masterCard,
        .visa
    ]
```

### 5. Добавьте метод который подготавливает данные для оплаты и отображает контроллер Apple Pay:
``` Swift
    @objc func initApplePay(_: AnyObject) {
        // Товары в корзине
        let item1 = PKPaymentSummaryItem(label: "Item 1", amount: NSDecimalNumber(string: "4.00"), type: .final)
        let item2 = PKPaymentSummaryItem(label: "Item 2", amount: NSDecimalNumber(string: "1.00"), type: .final)

        // Наименование магазина и итоговая цена
        let total = PKPaymentSummaryItem(label: "Your company name", amount: NSDecimalNumber(string: "5.00"), type: .final)

        let paymentSummaryItems = [item1, item2, total]

        // Подготовка запроса оплаты Apple Pay
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = "your_merchant_identifier" // заменить на актуальный MerchantID из консоли разработчика Apple
        paymentRequest.merchantCapabilities = .threeDSecure
        paymentRequest.countryCode = "KZ"
        paymentRequest.currencyCode = "KZT"
        paymentRequest.supportedNetworks = supportedNetworks
        
        // Отображение контроллера Apple Pay
        let paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController.delegate = self
        paymentController.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
            }
        })
    }
```

### 6. Добавьте метод для инициализации и подтверждения платежа с помощью SDK:

``` Swift
func finishApplePayPayment(tokenData: Data, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let amount: Float = 5
        let description = "some description"
        let orderId = "1234"
        let userId = "1234"

        sdk.createApplePayment(amount: amount, description: description, orderId: orderId, userId: userId, extraParams: nil) {
                    paymentId, error in {
                        if let createError = error {
                            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                            
                            // Ошибка инициализации платежа
                        } else if let paymentId = paymentId {
                            self.sdk.confirmApplePayment(paymentId: paymentId, tokenData: tokenData) {
                                confirmPayment, confirmError in {
                                    if let confirmError = confirmError {
                                        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                                        
                                        // Ошибка платежа
                                    } else if let confirmPayment = confirmPayment {
                                        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                                        
                                        // Успешный платеж
                                    }
                                }()
                            }
                        }
                    }()
            }
    }
```

### 7. Добавьте кнопку Apple Pay на ваш экран

Создаем непосредственно саму кнопку:
``` Swift
   lazy var applePayButton: UIButton! = {
        let button = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect.zero
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        return button
    }()
```

Добавляем кнопку во вью:
``` Swift
   self.view.addSubview(applePayButton)
```

Задаем положение кнопки на экране:
``` Swift
   NSLayoutConstraint.activate([
        applePayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        applePayButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 30),
        applePayButton.widthAnchor.constraint(equalToConstant: 250),
        applePayButton.heightAnchor.constraint(equalToConstant: 50)
   ])
```

Добавляем вызов функции `initApplePay` для подготовки платежа и отображении окна Apple Pay при клике на кнопку:
``` Swift
   applePayButton.addTarget(self, action: #selector(self.initApplePay(_:)), for: .touchUpInside)
```

Для корректной работы необходимо убедиться что Apple Pay настроен на устойстве и управляем состоянием кнопки в зависимости от полученного статуса:
``` Swift
    let applePayStatus = applePayStatus()
    applePayButton.isHidden = !applePayStatus.canMakePayments
```

### 8. Наследуйте делегат `PKPaymentAuthorizationControllerDelegate`:
``` Swift
   class ViewController: UIViewController, WebDelegate, PKPaymentAuthorizationControllerDelegate
```

### 9. Имплементируйте методы делегата:
``` Swift
   //Скрываем контроллер Apple Pay самостоятельно
   func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
       controller.dismiss()
   }
    
    
   //Получаем токен от Apple Pay и передаем в функцию `finishApplePayPayment` для взаимодействия с SDK
   func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
       finishApplePayPayment(tokenData: payment.token.paymentData, handler: completion)
   }
```
