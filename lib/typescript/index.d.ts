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
declare const _default: {
    initialize: (settings: Settings) => void;
    creditCardVault: (card: Card) => Promise<Token>;
    pay: (checkoutID: String) => Promise<void>;
};
export default _default;
