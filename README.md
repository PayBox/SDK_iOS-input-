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

1. Установите &quot;Cocoapods&quot; - менеджер зависимостей проектов Cocoa, с помощью команды:

        $ gem install cocoapods

1. Чтобы интегрировать &quot;PayBoxSdk&quot; в проект Xcode с использованием &quot;Cocoapods&quot;, создайте в корне проекта файл &quot;Podfile&quot; и вставьте в файл следующую команду:

        source 'https://github.com/CocoaPods/Specs.git' 
        platform :ios, '10.0';
        use_frameworks!
        target 'Project name' do
        pod 'PayBoxSdk', :git => 'https://github.com/PayBox/SDK_iOS-input-.git', :submodules => true
        end
1. Затем выполните след. команду:
        
        $ pod install

**Инициализация SDK:**

        import PayBoxSdk

        let builder = PBHelper.Builder(secretKey: String, merchantId: String)

Выбор платежной системы:

        builder.paymentSystem(system: .EPAYWEBKZT)

Выбор валюты платежа:

        builder.paymentCurrency(currency: .KZT)

Дополнительная информация пользователя, если не указано, то выбор будет предложен на сайте платежного гейта:

        builder.userInfo(email: string, phoneNumber: String)

Активация автоклиринга:

        builder.autoClearing(enabled: true)

Активация режима рекуррентного платежа: во входном параметре указывается время, на протяжении которого продавец рассчитывает использовать профиль рекуррентных платежей. Минимальное допустимое значение 1 (1 месяц). Максимальное допустимое значение: 156 (13 лет):

        builder.enableRecurring(lifetime: 3)

Отключение режима рекуррентного платежа:

        builder.disableRecurring()

Для активации режима тестирования:

        builder.testMode(enabled: true)

Для передачи информации от платежного гейта:

        builder.feedBackUrl(checkUrl: String, resultUrl: String, refundUrl: String, captureUrl: String, method: REQUEST\_METHOD)

Время (в секундах) в течение которого платеж должен быть завершен, в противном случае, при проведении платежа, PayBox откажет платежной системе в проведении (мин. 300 (5 минут), макс. 604800 (7 суток), по умолчанию 300):

        builder.paymentLifeTime(lifetime: 300)

Для связи с SDK,  имплементируйте в UIViewController -&gt; &quot;PBDelegate&quot;:

        builder.pbDelegate(delegate: self)

**Инициализация параметров:**

        builder.build()

**Работа с SDK:**

**Для инициализации платежа** (при инициализации с параметром &quot;builder.enableRecurring(int)&quot;, карты сохраняются в системе PayBox):

        PBHelper.sdk.initPayment(orderId: String, userId: Int, amount: Float, description: String, extraParams: [String: String]?)

В ответ откроется &quot;webView&quot; для заполнения карточных данных, после успешной оплаты вызовется функция:

        override func onPaymentPaid(response: Response)

**Для отмены платежа, по которому не прошел клиринг:**

        PBHelper.sdk.initCancelPayment(paymentId: Int)

После успешной операции вызовется метод:

        override func onPaymentCanceled(response: Response)

**Для проведения возврата платежа, по которому прошел клиринг:**

        PBHelper.sdk.initRevokePayment(paymentId: Int, amount: Float)

После успешной операции вызовется метод:

        override func onPaymentRevoked(response: Response)

**Для проведения рекуррентного платежа добавленной картой:**

PBHelper.sdk.makeRecurring(amount: Float, recurringProfile: String, description: String, extraParams: [String: String]?)

После успешной операции вызовется метод:

        override func onRecurringPaid(recurringResponse: Recurring)

**Для получения статуса платежа:**

        PBHelper.sdk.getPaymentStatus(paymentId: Int)

После успешной операции вызовется метод:

        override func onPaymentStatus(status: PStatus)

**Для проведения клиринга:**

        PBHelper.sdk.initPaymentDoCapture(paymentId: Int)

После успешной операции вызовется метод:

        override func onPaymentCaptured(capture: Capture)

**Для добавления карты:**

        PBHelper.sdk.addCard(userId: Int, postUrl: String) //postUrl - для обратной связи

В ответ откроется &quot;webView&quot; для заполнения карточных данных, после успешной операции вызовется метод:

        override func onCardAdded(response: Response)

**Для удаления карт:**

        PBHelper.sdk.removeCard(userId: Int, cardId: Int)

После успешной операции вызовется метод:

        override func onCardRemoved(card: Card)

**Для отображения списка карт:**

        PBHelper.sdk.getCards(userId: Int)

После успешной операции вызовется метод:

        override func onCardListed(cards: [Int : Card])

**Для создания платежа добавленной картой:**

        PBHelper.sdk.initCardPayment(amount: Float, userId: Int, cardId: Int, orderId: String, description: String, extraParams: [String: String]?)

После успешной операции вызовется метод:

        override func onCardPayInited(response: Response)

**Для проведения платежа добавленной картой:**

        PBHelper.sdk.cardPay(paymentId: Int)

В ответ откроется &quot;webView&quot;, после успешной операции вызовется метод:

        override func onCardPaid(response: Response)

