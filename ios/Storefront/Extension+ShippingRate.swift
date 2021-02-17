//
//  Extension+ShippingRate.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-17.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.ShippingRate {

    var payShippingRate: PayShippingRate {
        return PayShippingRate(
            handle: self.handle,
            title: self.title,
            price: self.priceV2.amount,
            deliveryRange: nil
        )
    }

}

extension Array where Element == Storefront.ShippingRate {

    var payShippingRates: [PayShippingRate] {
        return self.map {
            $0.payShippingRate
        }
    }
}
