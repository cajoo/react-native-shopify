//
//  Fragment+PaymentSettings.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-16.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.ShopQuery {
    
    @discardableResult
    func fragmentForPaymentSettings() -> Storefront.ShopQuery { return self
        .paymentSettings { $0
            .cardVaultUrl()
        }
    }
}
