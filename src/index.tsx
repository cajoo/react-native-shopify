import {
  NativeModules,
  NativeEventEmitter,
  Platform,
  EmitterSubscription,
} from 'react-native';

const { RNShopifyBuy } = NativeModules;

const ShopifyBuyEvents = new NativeEventEmitter(NativeModules.RNShopifyBuy);

type Settings = {
  shopDomain: string;
  accessToken: string;
  merchantID: string;
  locale?: string;
  googlePayToken?: string;
};

type Token = String | null;

type Card = {
  firstName: string;
  middleName?: string;
  lastName: string;
  number: string;
  expireMonth: string;
  expireYear: string;
  verificationCode?: string;
};

type EventName = 'didAuthorizePayment' | 'didFinish';

type PaymentStatus = 'success' | 'failed';

export default {
  canMakePayments: RNShopifyBuy.canMakePayments as boolean,

  /**
   * Initialize Shopify mobile-sdk
   * iOS/Android
   * @param settings
   */
  initialize: (settings: Settings) => {
    RNShopifyBuy.initialize(settings);
  },

  /**
   * Generate a credit card token
   * iOS/Android
   * @param card
   */
  creditCardVault: (card: Card): Promise<Token> => {
    return RNShopifyBuy.creditCardVault(card);
  },

  /**
   * Pay with mobile dedicated sdk
   * iOS
   * @param checkoutID
   */
  pay: (checkoutID: String): Promise<void> => {
    return RNShopifyBuy.pay(checkoutID);
  },

  /**
   * Add a new listener on ApplePay events
   * iOS
   * @param eventName
   * @param callback
   */
  addListener: (
    eventName: EventName,
    callback: (status?: PaymentStatus) => void
  ): EmitterSubscription | null => {
    if (Platform.OS === 'android') {
      console.warn('Listeners are only available on iOS');
      return null;
    }

    return ShopifyBuyEvents.addListener(eventName, callback);
  },
};
