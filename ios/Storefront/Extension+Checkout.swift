//
//  Extension+Checkout.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-17.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.Checkout {
    
    var payCheckout: PayCheckout {
        let payItems = self.lineItems.edges.map { item in item.payLineItem }
        let payGiftCards = self.appliedGiftCards.map { item in item.payGiftCard }
        let lineItemAllocations = self.lineItems.edges.flatMap { item in item.node.discountAllocations }
        

        return PayCheckout(
            id: self.id.rawValue,
            lineItems: payItems,
            giftCards: payGiftCards,
            discount: lineItemAllocations.totalDiscount > 0
                ? PayDiscount(
                    code: lineItemAllocations.aggregateName,
                    amount: lineItemAllocations.totalDiscount)
                : nil,
            shippingDiscount: self.shippingDiscountAllocations.totalDiscount > 0
                ? PayDiscount(
                    code: self.shippingDiscountAllocations.aggregateName,
                    amount: self.shippingDiscountAllocations.totalDiscount)
                : nil,
            shippingAddress: self.shippingAddress?.payAddress,
            shippingRate: self.shippingLine?.payShippingRate,
            currencyCode: self.currencyCode.rawValue,
            subtotalPrice: self.subtotalPriceV2.amount,
            needsShipping: self.requiresShipping,
            totalTax: self.totalTaxV2.amount,
            paymentDue: self.paymentDueV2.amount
        )
    }

}
