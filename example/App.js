import React, { useState, useCallback } from 'react';
import { StyleSheet, Text, View, TouchableOpacity, NativeEventEmitter, NativeModules } from 'react-native';
import RNShopifyBuy from 'react-native-shopify-buy';
import ShopifyBuy from 'react-native-shopify-buy';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  title: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  data: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  error: {
    color: 'red',
  },
  button: {
    height: 50,
    paddingHorizontal: 20,
    backgroundColor: 'black',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 5,
  },
  buttonText: {
    fontSize: 16,
    color: 'white',
  }
});

// instantiate the event emitter
const Events = new NativeEventEmitter(NativeModules.RNShopifyBuy)

// Shopify shop domain
const _shopDomain = 'eggz-fr.myshopify.com';
// Shopify Storefront token
const _storefrontToken = '4249d2e3a3c6bd87227005de5561856a';
// App locale
const _locale = 'fr-FR';
// MerchantID from iTunes connect developer portal
const _merchantID = 'merchant.com.rnshopify.buy';
// CheckoutID of a current shopify checkout to test
const _checkoutID = 'Z2lkOi8vc2hvcGlmeS9DaGVja291dC80NGIyYmFkYTljZTNmMWM4ZmEzNjFiYmMwN2IwMzMwOD9rZXk9OTcyM2M2YmQxMDYwMGMwYWI3MmY5MWM3YWZkOWU0MmE=';
// Sample credit card
const _exampleCreditCard = {
  firstName: 'Bob',
  lastName: 'Norman',
  number: '4242424242424242',
  expireMonth: '12',
  expireYear: '2021',
  verificationCode: '123'
};

// Initialize ShopifyBuy SDK
ShopifyBuy.initialize({
  shopDomain: _shopDomain,
  accessToken: _storefrontToken,
  locale: _locale,
  merchantID: _merchantID,
});

Events.addListener(
  "didFinish",
  (...args) => console.log("didFinish", args)
)

const App = () => {
  // State
  const [token, setToken] = useState(null);
  const [error, setError] = useState(null);

  // Callbacks
  const handleCardVault = useCallback(() => {
    RNShopifyBuy.creditCardVault(_exampleCreditCard)
      .then((_token) => setToken(_token))
      .catch((_error) => setError(_error));
  }, []);

  const handlePayment = useCallback(() => {
    RNShopifyBuy.pay(_checkoutID)
      .then(() => console.log('SUCCESS'))
      .catch(() => console.log('ERROR'))
  });

  return (
    <View style={styles.container}>
      <Text style={styles.title}>☆ RNShopifyBuy example ☆</Text>
      <Text style={styles.data}>{JSON.stringify(_exampleCreditCard)}</Text>
      <TouchableOpacity style={styles.button} onPress={handleCardVault}>
        <Text style={styles.buttonText}>Generate credit card token</Text>
      </TouchableOpacity>
      <Text style={styles.data}>{token}</Text>
      <TouchableOpacity style={styles.button} onPress={handlePayment}>
        <Text style={styles.buttonText}>Make a payment</Text>
      </TouchableOpacity>
      <Text style={[styles.data, styles.error]}>{error}</Text>
    </View>
  );
};

export default App;