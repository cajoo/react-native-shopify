/**
 * Swift bridge for react-native-shopify-buy module
 */

import MobileBuySDK

@objc(RNShopifyBuy)
class RNShopifyBuy: RCTEventEmitter, PaySessionDelegate {

    private var client: Client? = nil
    private var paySession: PaySession? = nil
    private var merchantID: String? = nil
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    /**
     * Initialize shopify graph client
     */
    @objc(initialize:)
    func initialize(_ settings: Dictionary<String, Any>) {
        // Create graph client
        if let shopDomain = settings["shopDomain"] as? String, let accessToken = settings["accessToken"] as? String, let locale = settings["locale"] as? String {
            self.client = Client(shopDomain: shopDomain, accessToken: accessToken, locale: Locale.init(identifier: locale))
        } else {
            fatalError("All following parameters need to be provided to initialize client: shopDomain, accessToken, locale")
        }
        self.merchantID = settings["merchantID"] as? String
    }
    
    /**
     * Check if client has been initialized
     */
    func useClient(reject: RCTPromiseRejectBlock?, callback: (_ client: Client) -> Void) -> Void {
        if let client = self.client {
            callback(client)
        } else {
            if let reject = reject {
                reject("E_NOT_INITIALIZED", "Client has not been initialized, please call initialize function first", nil)
            } else {
                fatalError("Client has not been initialized, please call ShopifyBuy.initialize function first")
            }
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
                expiryMonth: cardDictionary["expireMonth"] as! String,
                expiryYear: cardDictionary["expireYear"] as! String,
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
    
    @objc(pay:resolver:rejecter:)
    func pay(
        _ checkoutID: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) -> Void {
        self.useClient(reject: reject) { client in
            
            // Fetch Shopify shopName
            client.fetchShopName { shopName in
                if let shopName = shopName, let merchantID = self.merchantID {
                    
                    // Fetch checkout with the given ID
                    client.fetchCheckoutById(id: checkoutID) { checkout in
                        if let checkout = checkout {
                            let countryCode = checkout.shippingAddress?.countryCodeV2?.rawValue ?? "FR"
                            // Create PayCurrency Object from checkout props
                            let payCurrency = PayCurrency(currencyCode: checkout.currencyCode.rawValue, countryCode: countryCode)
                            // Create PaySession to launch ApplePay payment
                            let paySession = PaySession(shopName: shopName, checkout: checkout.payCheckout, currency: payCurrency, merchantID: merchantID)
                            
                            paySession.delegate = self
                            
                            self.paySession = paySession
                            
                            // Launch ApplePay screen
                            paySession.authorize()
                            
                            resolve(nil)
                        } else {
                            reject("E_CHECKOUT", "Can't find checkout with this id", nil)
                        }
                    }
                } else {
                    reject("E_NOT_INITIALIZE", "Can't get shopName or merchantID", nil)
                }
            }
        }
    }
    
    /**
     * PaySession delegates
     */
    func paySession(_ paySession: PaySession, didRequestShippingRatesFor address: PayPostalAddress, checkout: PayCheckout, provide: @escaping (PayCheckout?, [PayShippingRate]) -> Void) {
        print("didRequestShippingRatesFor...")
        self.useClient(reject: nil) { client in
            // Update shipping address
            client.updateCheckout(checkout.id, updatingPartialShippingAddress: address) { checkout in
                
                guard let checkout = checkout else {
                    print("Update for checkout failed.")
                    provide(nil, [])
                    return
                }
                
                // Fetch new shipping rates
                print("Getting shipping rates...")
                client.fetchShippingRatesForCheckout(checkout.id.rawValue) { result in
                    if let result = result {
                        print("Fetched shipping rates.")
                        provide(result.checkout.payCheckout, result.rates.payShippingRates)
                    } else {
                        provide(nil, [])
                    }
                }
            }
        }
    }
    
    func paySession(_ paySession: PaySession, didUpdateShippingAddress address: PayPostalAddress, checkout: PayCheckout, provide: @escaping (PayCheckout?) -> Void) {
        print("didUpdateShippingAddress...")
        self.useClient(reject: nil) { client in
            // Update shipping address
            client.updateCheckout(checkout.id, updatingPartialShippingAddress: address) { checkout in
                
                if let checkout = checkout {
                    provide(checkout.payCheckout)
                } else {
                    print("Update for checkout failed.")
                    provide(nil)
                }
            }
        }
    }
    
    func paySession(_ paySession: PaySession, didSelectShippingRate shippingRate: PayShippingRate, checkout: PayCheckout, provide: @escaping (PayCheckout?) -> Void) {
        print("didSelectShippingRate...")
        self.useClient(reject: nil) { client in
            // Update shipping rate
            client.updateCheckout(checkout.id, updatingShippingRate: shippingRate) { updatedCheckout in
                provide(updatedCheckout?.payCheckout)
            }
        }
    }
    
    func paySession(_ paySession: PaySession, didAuthorizePayment authorization: PayAuthorization, checkout: PayCheckout, completeTransaction: @escaping (PaySession.TransactionStatus) -> Void) {
        print("didAuthorizePayment...")

        guard let email = authorization.shippingAddress.email else {
            print("Unable to update checkout email. Aborting transaction.")
            self.sendEvent(withName: "didAuthorizePayment", body: "failed")
            completeTransaction(.failure)
            return
        }
        
        print("Updating checkout shipping address...")
        self.useClient(reject: nil) { client in
            // Update complete shipping address
            client.updateCheckout(checkout.id, updatingCompleteShippingAddress: authorization.shippingAddress) { updatedCheckout in
                guard let _ = updatedCheckout else {
                    self.sendEvent(withName: "didAuthorizePayment", body: "failed")
                    completeTransaction(.failure)
                    return
                }
                
                // Update checkout email
                print("Updating checkout email...")
                client.updateCheckout(checkout.id, updatingEmail: email) { updatedCheckout in
                    guard let _ = updatedCheckout else {
                        self.sendEvent(withName: "didAuthorizePayment", body: "failed")
                        completeTransaction(.failure)
                        return
                    }
                    print("Checkout email updated: \(email)")
                    
                    // Complete checkout
                    print("Completing checkout...")
                    client.completeCheckout(checkout, billingAddress: authorization.billingAddress, applePayToken: authorization.token, idempotencyToken: paySession.identifier) { payment in
                        if let payment = payment, checkout.paymentDue == payment.amountV2.amount {
                            print("Checkout completed successfully.")
                            self.sendEvent(withName: "didAuthorizePayment", body: "success")
                            completeTransaction(.success)
                        } else {
                            print("Checkout failed to complete.")
                            self.sendEvent(withName: "didAuthorizePayment", body: "failed")
                            completeTransaction(.failure)
                        }
                    }
                }
            }
        }
    }
    
    func paySessionDidFinish(_ paySession: PaySession) {
        print("didFinish...")
        self.sendEvent(withName: "didFinish", body: [])
    }
    
    /**
     * Events
     */
    override func supportedEvents() -> [String]! {
      return [
        "didAuthorizePayment",
        "didFinish",
      ]
    }

}
