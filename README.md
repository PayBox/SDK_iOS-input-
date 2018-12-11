**PayBox SDK (Swift)**

PayBox SDK - это библиотека позволяющая упростить взаимодействие с API PayBox. Система SDK работает на iOS 10.3 и выше

**Описание возможностей:**

- Инициализация платежа
- Отмена платежа
- Возврат платежа
- Проведение рекуррентного платежа с сохраненными картами
- Получение информации/статуса платежа
- Добавление карт
- Оплата добавленными картами
- Удаление карт

**Установка:**

1. Установите "Cocoapods" - менеджер зависимостей проектов Cocoa, с помощью команды:
```
        $ gem install cocoapods
```
1. Чтобы интегрировать "PayBoxSdk"; в проект Xcode с использованием "Cocoapods", создайте в корне проекта файл "Podfile" и вставьте в файл следующую команду:
```
        source 'https://github.com/CocoaPods/Specs.git' 
        platform :ios, '12.1';
        use_frameworks!
        target 'Project name' do
        pod 'PayBoxSdk', :git => 'https://github.com/PayBox/SDK_iOS-input-.git', :submodules => true
        end
```
1. Затем выполните след. команду:
```       
        $ pod install
```
**Инициализация SDK:**
```
        import PayBoxSdk

        let builder = PBHelper.Builder(secretKey: String, merchantId: String)
```
Выбор платежной системы:
```
        builder.paymentSystem(system: .EPAYWEBKZT)
```
Выбор валюты платежа:
```
        builder.paymentCurrency(currency: .KZT)
```
Дополнительная информация пользователя, если не указано, то выбор будет предложен на сайте платежного гейта:
```
        builder.userInfo(email: string, phoneNumber: String)
```
Активация автоклиринга:
```
        builder.autoClearing(enabled: true)
```
Для активации режима тестирования:
```
        builder.testMode(enabled: true)
```
Для передачи информации от платежного гейта:
```
        builder.feedBackUrl(checkUrl: String, resultUrl: String, refundUrl: String, captureUrl: String, method: REQUEST\_METHOD)
```
Время (в секундах) в течение которого платеж должен быть завершен, в противном случае, при проведении платежа, PayBox откажет платежной системе в проведении (мин. 300 (5 минут), макс. 604800 (7 суток), по умолчанию 300):
```
        builder.paymentLifeTime(lifetime: 300)
```

**Инициализация параметров:**
```
        builder.build()
```

**Работа с SDK:**

Для связи с SDK,  имплементируйте в UIViewController -> PBDelegate:
В методе viewDidLoad() добавьте:
```
        PBHelper.sdk.pbDelegate(delegate: self)
```
**Для инициализации платежа** (при инициализации с параметром "builder.enableRecurring(int)", карты сохраняются в системе PayBox):

        PBHelper.sdk.initPayment(orderId: String, userId: Int, amount: Float, description: String, extraParams: [String: String]?, currentViewController: UIViewController)

В ответ откроется "webView" для заполнения карточных данных, после успешной оплаты вызовется функция:
```
        override func onPaymentPaid(response: Response)
```

**Для отмены платежа, по которому не прошел клиринг:**
```
        PBHelper.sdk.initCancelPayment(paymentId: Int)
```
После успешной операции вызовется метод:
```
        override func onPaymentCanceled(response: Response)
```
Активация режима рекуррентного платежа: во входном параметре указывается время, на протяжении которого продавец рассчитывает использовать профиль рекуррентных платежей. Минимальное допустимое значение 1 (1 месяц). Максимальное допустимое значение: 156 (13 лет):
```
        PBHelper.sdk.enableRecurring(lifetime: 3)
```
Отключение режима рекуррентного платежа:
```
        PBHelper.sdk.disableRecurring()
```

**Для проведения возврата платежа, по которому прошел клиринг:**
```
        PBHelper.sdk.initRevokePayment(paymentId: Int, amount: Float)
```
После успешной операции вызовется метод:

        override func onPaymentRevoked(response: Response)

**Для проведения рекуррентного платежа добавленной картой:**
```
        PBHelper.sdk.makeRecurring(amount: Float, recurringProfile: String, description: String, extraParams: [String: String]?)
```
После успешной операции вызовется метод:
```
        override func onRecurringPaid(recurringResponse: Recurring)
```

**Для получения статуса платежа:**
```
        PBHelper.sdk.getPaymentStatus(paymentId: Int)
```
После успешной операции вызовется метод:
```
        override func onPaymentStatus(status: PStatus)
```

**Для проведения клиринга:**
```
        PBHelper.sdk.initPaymentDoCapture(paymentId: Int)
```
После успешной операции вызовется метод:
```
        override func onPaymentCaptured(capture: Capture)
```

**Для добавления карты:**
```
        PBHelper.sdk.addCard(userId: Int, postUrl: String, currentViewController: UIViewController) //postUrl - для обратной связи
```
В ответ откроется "webView" для заполнения карточных данных, после успешной операции вызовется метод:
```
        override func onCardAdded(response: Response)
```

**Для удаления карт:**
```
        PBHelper.sdk.removeCard(userId: Int, cardId: Int)
```
После успешной операции вызовется метод:
```
        override func onCardRemoved(card: Card)
```

**Для отображения списка карт:**
```
        PBHelper.sdk.getCards(userId: Int)
```
После успешной операции вызовется метод:
```
        override func onCardListed(cards: [Int : Card])
```

**Для создания платежа добавленной картой:**
```
        PBHelper.sdk.initCardPayment(amount: Float, userId: Int, cardId: Int, orderId: String, description: String, extraParams: [String: String]?)
```
После успешной операции вызовется метод:
```
        override func onCardPayInited(response: Response)
```

**Для проведения платежа добавленной картой:**
```
        PBHelper.sdk.cardPay(paymentId: Int, currentViewController: UIViewController)
```
В ответ откроется "webView", после успешной операции вызовется метод:
```
        override func onCardPaid(response: Response)
```

**Описание некоторых входных параметров**

1. orderId - Идентификатор платежа в системе продавца. Рекомендуется поддерживать уникальность этого поля.
2. amount - Сумма платежа
3. merchantId - Идентификатор продавца в системе PayBox. Выдается при подключении.
4. secretKey - Платежный пароль, используется для защиты данных, передаваемых системой PayBox магазину и магазином системе Paybox
5. userId - Идентификатор клиента в системе магазина продавца.
6. paymentId - Номер платежа сформированный в системе PayBox.
7. description - Описание товара или услуги. Отображается покупателю в процессе платежа.
8. extraParams - Дополнительные параметры продавца. Имена дополнительных параметров продавца должны быть уникальными. 
9. checkUrl - URL для проверки возможности платежа. Вызывается перед платежом, если платежная система предоставляет такую возможность. Если параметр не указан, то берется из настроек магазина. Если параметр установлен равным пустой строке, то проверка возможности платежа не производится.
10. resultUrl - URL для сообщения о результате платежа. Вызывается после платежа в случае успеха или неудачи. Если параметр не указан, то берется из настроек магазина. Если параметр установлен равным пустой строке, то PayBox не сообщает магазину о результате платежа.
11. refundUrl - URL для сообщения об отмене платежа. Вызывается после платежа в случае отмены платежа на стороне PayBoxа или ПС. Если параметр не указан, то берется из настроек магазина.
12. captureUrl - URL для сообщения о проведении клиринга платежа по банковской карте. Если параметр не указан, то берется из настроек магазина.
13. REQUEST_METHOD - GET, POST или XML – метод вызова скриптов магазина checkUrl, resultUrl, refundUrl, captureUrl для передачи информации от платежного гейта.
