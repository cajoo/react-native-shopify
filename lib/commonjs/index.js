"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _reactNative = require("react-native");

const {
  RNShopifyBuy
} = _reactNative.NativeModules;
var _default = {
  initialize: settings => {
    RNShopifyBuy.initialize(settings);
  },
  creditCardVault: card => {
    return RNShopifyBuy.creditCardVault(card);
  },
  pay: checkoutID => {
    return RNShopifyBuy.pay(checkoutID);
  }
};
exports.default = _default;
//# sourceMappingURL=index.js.map