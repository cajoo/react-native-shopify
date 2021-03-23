import { NativeModules, NativeEventEmitter, Platform } from 'react-native';
const {
  RNShopifyBuy
} = NativeModules;
const ShopifyBuyEvents = new NativeEventEmitter(NativeModules.RNShopifyBuy);
export default {
  canMakePayments: RNShopifyBuy.canMakePayments,

  /**
   * Initialize Shopify mobile-sdk
   * iOS/Android
   * @param settings
   */
  initialize: settings => {
    RNShopifyBuy.initialize(settings);
  },

  /**
   * Generate a credit card token
   * iOS/Android
   * @param card
   */
  creditCardVault: card => {
    return RNShopifyBuy.creditCardVault(card);
  },

  /**
   * Pay with mobile dedicated sdk
   * iOS
   * @param checkoutID
   */
  pay: checkoutID => {
    return RNShopifyBuy.pay(checkoutID);
  },

  /**
   * Add a new listener on ApplePay events
   * iOS
   * @param eventName
   * @param callback
   */
  addListener: (eventName, callback) => {
    if (Platform.OS === 'android') {
      console.warn('Listeners are only available on iOS');
      return null;
    }

    return ShopifyBuyEvents.addListener(eventName, callback);
  }
};
//# sourceMappingURL=index.js.map