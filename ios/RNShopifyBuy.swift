/**
 * Swift bridge for react-native-shopify-buy module
 */

import MobileBuySDK

@objc(RNShopifyBuy)
class RNShopifyBuy: NSObject {

    private var client: Graph.Client? = nil
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
        self.client = Graph.Client(shopDomain: shopDomain, apiKey: accessToken, locale: Locale.init(identifier: locale))
    }
    
    /**
     * Check if client has been initialized
     */
    func useClient(reject: RCTPromiseRejectBlock, callback: (_ client: Graph.Client) -> Void) -> Void {
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

            // Create query for payment settings
            let query = Storefront.buildQuery { $0
                .shop { $0
                    .fragmentForPaymentSettings()
                }
            }
            
            // Create task
            let task = client.queryGraphWith(query) { response, error in
                if let response = response {
                    let subtask = cardClient.vault(creditCard, to: response.shop.paymentSettings.cardVaultUrl) { token, error in
                        if let token = token {
                            resolve(token)
                        } else {
                            reject("E_TOKEN", "Can't vault credit card", error)
                        }
                    }
                    
                    subtask.resume()
                } else {
                    reject("E_VAULT_URL", "Can't get cardVaultUrl", error)
                }
            }
            
            // Run task
            task.resume()
        }
    }
    
}
