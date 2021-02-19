# react-native-shopify-buy

Shopify mobile-sdk bridge for react-native

## Installation

```sh
yarn add react-native-shopify-buy
```

## Usage

```js
import ShopifyBuy from "react-native-shopify-buy";

// ...

ShopifyBuy.initialize({
  // Cross-Platform
  shopDomain: 'SHOPIFY_SHOP_DOMAIN',
  accessToken: 'SHOPIFY_STOREFRONT_TOKEN',
  // iOS Only
  locale: 'DEVICE-LOCALE',
  merchantID: 'APPLE PAY MERCHANT ID',
});

const App = () => {
  // ...
  const handleCardVault = useCallback(() => {
    ShopifyBuy.creditCardVault({
        firstName: 'Bob',
        lastName: 'Norman',
        number: '4242424242424242',
        expireMonth: '12',
        expireYear: '2021',
        verificationCode: '123',
      })
      .then((_token: string) => console.log('TOKEN: ', token));
  }, []);

  const handlePayment = useCallback(() => {

    ShopifyBuy.pay('SHOPIFY_CHECKOUT_ID')
      .then(() => console.log('OPENED WITH SUCCESS'));
  }, []);

  useEffect(() => {
    // Emit when a payment is attempted
    const listenerDidAuthorizePayment = ShopifyBuy.addListener(
      'didAuthorizePayment',
      (status: PaymentStatus) => console.log('PAYMENT STATUS: ', status)
    );
    // Emit when payment modal disappear
    const listenerDidFinish = ShopifyBuy.addListener('didFinish', () =>
      console.log('didFinish')
    );

    return () => {
      listenerDidAuthorizePayment?.remove();
      listenerDidFinish?.remove();
    };
  }, []);
  // ...
};
```

## License

MIT
