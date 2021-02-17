/**
 * Swift bridge for react-native-shopify-buy module
 */

import MobileBuySDK

@objc(RNShopifyBuy)
class RNShopifyBuy: NSObject, PaySessionDelegate {

    private var client: Client? = nil
    private var paySession: PaySession? = nil
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    /**
     * Initialize shopify graph client
     */
    @objc(initialize:accessTokenParameter:localeParameter:)
    func initialize(_ shopDomain: String, accessToken: String, locale: String) {
        // Create graph client
        self.client = Client(shopDomain: shopDomain, accessToken: accessToken, locale: Locale.init(identifier: locale))
    }
    
    /**
     * Check if client has been initialized
     */
    func useClient(reject: RCTPromiseRejectBlock, callback: (_ client: Client) -> Void) -> Void {
        if let client = self.client {
            callback(client)
        } else {
            reject("E_NOT_INITIALIZED", "Client has not been initialized, please call initialize function first", nil)
        }
    }
    
    /**
     * Create a credit card token
     */
    @objc(creditCardVault:resolver:rejecter:)
    func creditCardVault(
        _ cardDictionary: Dictionary<String, Any>,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) -> Void {
        self.useClient(reject: reject) { client in
            // Create credit card client
            let cardClient = Card.Client()

            // Create credit card
            let creditCard = Card.CreditCard(
                firstName: cardDictionary["firstName"] as! String,
                middleName: cardDictionary["middleName"] as? String,
                lastName: cardDictionary["lastName"] as! String,
                number: cardDictionary["number"] as! String,
                expiryMonth: cardDictionary["expiryMonth"] as! String,
                expiryYear: cardDictionary["expiryYear"] as! String,
                verificationCode: cardDictionary["verificationCode"] as? String
            );
            
            client.fetchCardVaultUrl { cardVaultUrl in
                if let cardVaultUrl = cardVaultUrl {
                    let task = cardClient.vault(creditCard, to: cardVaultUrl) { token, error in
                        if let token = token {
                            resolve(token)
                        } else {
                            reject("E_TOKEN", "Can't vault credit card", error)
                        }
                    }
                    
                    task.resume()
                } else {
                    reject("E_VAULT_URL", "Can't get cardVaultUrl", nil)
                }
            }
        }
    }
    
    @objc(applePay:checkoutIDParameter:resolver:rejecter:)
    func applePay(
        _ merchantID: String,
        checkoutID: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) -> Void {
        print("pay...")
        
        self.useClient(reject: reject) { client in
            
            client.fetchShopName { shopName in
                if let shopName = shopName {
                    print(shopName)
                    client.fetchCheckoutById(id: checkoutID) { checkout in
                        if let checkout = checkout {
                            let countryCode = checkout.shippingAddress?.countryCodeV2?.rawValue ?? "FR"
                            let payCurrency = PayCurrency(currencyCode: checkout.currencyCode.rawValue, countryCode: countryCode)
                            let paySession = PaySession(shopName: shopName, checkout: checkout.payCheckout, currency: payCurrency, merchantID: merchantID)
                            
                            print(checkout.payCheckout)

                            paySession.delegate = self

                            self.paySession = paySession

                            paySession.authorize()
                            
                            resolve(nil)
                        } else {
                            reject("E_CHECKOUT", "Can't find checkout with this id", nil)
                        }
                    }
                } else {
                    reject("E_SHOP_NAME", "Can't get shopName", nil)
                }
            }
        }
    }
    
    func paySession(_ paySession: PaySession, didRequestShippingRatesFor address: PayPostalAddress, checkout: PayCheckout, provide: @escaping (PayCheckout?, [PayShippingRate]) -> Void) {
        print("didSelectShippingRate...")
    }
    
    func paySession(_ paySession: PaySession, didUpdateShippingAddress address: PayPostalAddress, checkout: PayCheckout, provide: @escaping (PayCheckout?) -> Void) {
        print("didAuthorizePayment...")
    }
    
    func paySession(_ paySession: PaySession, didSelectShippingRate shippingRate: PayShippingRate, checkout: PayCheckout, provide: @escaping (PayCheckout?) -> Void) {
        print("didRequestShippingRates...")
    }
    
    func paySession(_ paySession: PaySession, didAuthorizePayment authorization: PayAuthorization, checkout: PayCheckout, completeTransaction: @escaping (PaySession.TransactionStatus) -> Void) {
        print("didUpdateShippingAddress...")
    }
    
    func paySessionDidFinish(_ paySession: PaySession) {
        print("didFinish...")
    }

}
