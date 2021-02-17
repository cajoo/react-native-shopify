//
//  Extension+CheckoutLineItemEdge.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-17.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.CheckoutLineItemEdge {

    var payLineItem: PayLineItem {
        return PayLineItem(
            price: self.node.variant!.priceV2.amount,
            quantity: Int(self.node.quantity)
        )
    }

}
