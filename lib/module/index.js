import { NativeModules } from 'react-native';
const {
  RNShopifyBuy
} = NativeModules;
export default {
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
//# sourceMappingURL=index.js.map