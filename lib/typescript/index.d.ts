import { EmitterSubscription } from 'react-native';
declare type Settings = {
    shopDomain: string;
    accessToken: string;
    merchantID: string;
    locale?: string;
    googlePayToken?: string;
};
declare type Token = String | null;
declare type Card = {
    firstName: string;
    middleName?: string;
    lastName: string;
    number: string;
    expireMonth: string;
    expireYear: string;
    verificationCode?: string;
};
declare type EventName = 'didAuthorizePayment' | 'didFinish';
declare type PaymentStatus = 'success' | 'failed';
declare const _default: {
    canMakePayments: boolean;
    /**
     * Initialize Shopify mobile-sdk
     * iOS/Android
     * @param settings
     */
    initialize: (settings: Settings) => void;
    /**
     * Generate a credit card token
     * iOS/Android
     * @param card
     */
    creditCardVault: (card: Card) => Promise<Token>;
    /**
     * Pay with mobile dedicated sdk
     * iOS
     * @param checkoutID
     */
    pay: (checkoutID: String) => Promise<void>;
    /**
     * Add a new listener on ApplePay events
     * iOS
     * @param eventName
     * @param callback
     */
    addListener: (eventName: EventName, callback: (status?: "success" | "failed" | undefined) => void) => EmitterSubscription | null;
};
export default _default;
