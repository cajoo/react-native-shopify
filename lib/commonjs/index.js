"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _reactNative = require("react-native");

const {
  RNShopifyBuy
} = _reactNative.NativeModules;
const ShopifyBuyEvents = new _reactNative.NativeEventEmitter(_reactNative.NativeModules.RNShopifyBuy);
var _default = {
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
    if (_reactNative.Platform.OS === 'android') {
      console.warn('Listeners are only available on iOS');
      return null;
    }

    return ShopifyBuyEvents.addListener(eventName, callback);
  }
};
exports.default = _default;
//# sourceMappingURL=index.js.map