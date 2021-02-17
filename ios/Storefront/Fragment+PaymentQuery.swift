//
//  Fragment+PaymentQuery.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-17.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.PaymentQuery {
    
    @discardableResult
    func fragmentForPayment() -> Storefront.PaymentQuery { return self
        .id()
        .ready()
        .test()
        .amountV2 { $0
            .amount()
            .currencyCode()
        }
        .checkout { $0
            .fragmentForCheckout()
        }
        .creditCard { $0
            .firstDigits()
            .lastDigits()
            .maskedNumber()
            .brand()
            .firstName()
            .lastName()
            .expiryMonth()
            .expiryYear()
        }
        .errorMessage()
    }
}
