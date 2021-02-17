//
//  Client.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-16.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

final class Client {
    private var client: Graph.Client

    init(shopDomain: String, accessToken: String, locale: Locale) {
        self.client = Graph.Client(shopDomain: shopDomain, apiKey: accessToken, locale: locale)
    }
    
    @discardableResult
    func fetchShopName(completion: @escaping (String?) -> Void) -> Task {
        
        let query = ClientQuery.queryForShopName()
        let task  = self.client.queryGraphWith(query) { query, error in
            if let query = query {
                completion(query.shop.name)
            } else {
                print("Failed to fetch shop name: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchCardVaultUrl(completion: @escaping (URL?) -> Void) -> Task {
        
        let query = ClientQuery.queryForCardVaultUrl()
        let task  = self.client.queryGraphWith(query) { query, error in
            if let query = query {
                completion(query.shop.paymentSettings.cardVaultUrl)
            } else {
                print("Failed to fetch cardVaultUrl: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchCheckoutById(id: String, completion: @escaping (Storefront.Checkout?) -> Void) -> Task {
        
        let query = ClientQuery.queryForCheckout(id: GraphQL.ID(rawValue: id))
        let task  = self.client.queryGraphWith(query) { query, error in
            if let query = query {
                print(query)
                completion(query.node as? Storefront.Checkout)
            } else {
                print("Failed to fetch checkout: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
}
