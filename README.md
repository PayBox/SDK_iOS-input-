**Paybox SDK (iOS, Swift)**

PayBox SDK iOS - это библиотека позволяющая упростить взаимодействие с API PayBox.

[Исходный код демонстрационного приложения](https://github.com/PayBox/sample-ios-swift-sdk)

<img src="https://github.com/PayBox/sample-ios-swift-sdk/raw/master/swift_init_pay.gif" width="25%" height="25%"/>

**Описание возможностей:**

- Инициализация платежа
- Отмена платежа
- Возврат платежа
- Проведение клиринга
- Проведение рекуррентного платежа с сохраненными картами
- Получение информации/статуса платежа
- Добавление карт/Удаление карт
- Оплата добавленными картами

# **Установка:**

1. Чтобы интегрировать "PayBoxSdk"; в проект Xcode с использованием "Cocoapods", добавьте в "Podfile":
```
        target 'Project name' do
            pod 'PayBoxSdk', :git => 'https://github.com/PayBox/SDK_iOS-input-.git', :submodules => true
        end
```
2. Затем выполните след. команду:
```       
        $ pod install
```


# Для связи с SDK
*Инициализация SDK:*

```
    let sdk = PayboxSdk.initialize(merchantId: merchantID, secretKey: "secretKey")
```

Добавьте PaymentView в ваш UIViewController:

```
    let paymentView = PaymentView(frame: CGRect(x: 0, y: 0, width: width, height: height))
```

Передайте экземпляр paymentView в sdk:

```
    sdk.setPaymentView(paymentView: paymentView)
```

Для отслеживания прогресса загрузки платежной страницы используйте WebDelegate:
```
    paymentView.delegate = self

    func loadStarted() {

    }
    func loadFinished() {

    }
```
# **Настройки SDK**

*Тестовый режим:*
```
    sdk.config().testMode(enabled: true) // По умолчанию тестовый режим включен
```

*Выбор платежной системы:*
```
    sdk.config().setPaymentSystem(paymentSystem: paymentSystem)
```

*Выбор валюты платежа:*
```
    sdk.config().setCurrencyCode(code: "KZT")
```

*Активация автоклиринга:*
```
    sdk.config().autoClearing(enabled: enabled)
```

*Установка кодировки:*
```
    sdk.config().setEncoding(encoding: "UTF-8") // по умолчанию UTF-8
```

*Время жизни рекурентного профиля:*
```
    sdk.config().setRecurringLifetime(lifetime: 36) //по умолчанию 0 месяцев (параметр исключается из списка при значении 0)
```

*Время жизни платежной страницы, в течение которого платеж должен быть завершен:*
```
    sdk.config().setPaymentLifetime(lifetime: 300)  //по умолчанию 300 секунд
```

*Включение режима рекурентного платежа:*
```
    recurringMode(enabled: enabled)  //по умолчанию отключен
```

*Номер телефона клиента, будет отображаться на платежной странице. Если не указать, то будет предложено ввести на платежной странице:*
```
    sdk.config().setUserPhone(userPhone: userPhone)
```

*Email клиента, будет отображаться на платежной странице. Если не указать email, то будет предложено ввести на платежной странице:*
```
    sdk.config().setUserEmail(userEmail: email)
```

*Язык платежной страницы:*
```
    sdk.config().setLanguage(language: .ru)
```

*Для передачи информации от платежного гейта:*
```
    sdk.config().setCheckUrl(url: url)
    sdk.config().setResultUrl(url: url)
    sdk.config().setRefundUrl(url: url)
    sdk.config().setClearingUrl(url: url)
    sdk.config().setRequestMethod(requestMethod: requestMethod)
```

*Для отображения Frame вместо платежной страницы:*
```
    sdk.config().setFrameRequired(isRequired: true) //false по умолчанию
```
        

# **Работа с SDK**

## *Создание платежа:*

```
    sdk.createPayment(amount: amount, description: "description", orderId: "orderId", userId: userId, extraParams: extra) {
            payment, error in   //Вызовется после оплаты
    }
```
После вызова в paymentView откроется платежная страница


## *Рекурентный платеж:*
```
    sdk.createRecurringPayment(amount: amount, description: "description", recurringProfile: "profile", orderId: "orderId", extraParams: extra) {
            recurringPayment, error in // Вызовется после оплаты
    }
```

## *Получение статуса платежа:*
```
    sdk.getPaymentStatus(paymentId: paymentId) {
            status, error in // Вызовется после получения ответа
    }
```

## *Клиринг платежа:*
```
    sdk.makeClearingPayment(paymentId: paymentId, amount: amount) {  // Если указать nil вместо суммы клиринга, то клиринг пройдет на всю сумму платежа
            capture, error in // Вызовется после клиринга
    }
```

## *Отмена платежа:*
```
    sdk.makeCancelPayment(paymentId: paymentId) {
            payment, error in // Вызовется после отмены
    }
```

## *Возврат платежа:*
```
    sdk.makeRevokePayment(paymentId: paymentId, amount: amount) {
            payment, error in // Вызовется после возврата
    }
```

## *Сохранение карты:*
```
    sdk.addNewCard(postLink: url, userId: userId) {
            payment, error in // Вызовется после сохранения
    }
```
После вызова в paymentView откроется платежная страница

## *Получить список сохраненых карт:*
```
    sdk.getAddedCards(userId: userId) {
            cards, error in // Вызовется после получения ответа
    }
```

## *Удаление сохраненой карты:*
```
    sdk.removeAddedCard(cardId: cardId, userId: userId) {
            payment, error in // Вызовется после ответа
    }
```

## *Создание платежа сохраненой картой:*
```
    sdk.createCardPayment(amount: amount, userId: userId, cardToken: "cardToken", description: "description", orderId: "01234", extraParams: nil) {
            payment, error in // Вызовется после создания
    }
```
> *Внимание: Метод `createCardPayment` с использованием `cardId` является устаревшим.*
## *Для оплаты созданного платежа:*
```
    sdk.payByCard(paymentId: paymentId) {
            payment, error in // Вызовется после оплаты
    }
```
После вызова в paymentView откроется платежная страница для 3ds аутентификации

## *Для оплаты созданного платежа c безакцепным списанием:*
```
   sdk.createNonAcceptancePayment(paymentId: paymentId){
            payment, error -> //Вызовется после оплаты
   }
```
