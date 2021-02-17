//
//  Extension+DiscountAllocation.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-17.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Array where Element == Storefront.DiscountAllocation {
    var aggregateName: String {
        return self.map {
            $0.discountApplication.resolvedViewModel
        }.joined(separator: ", ")
    }
    
    var totalDiscount: Decimal {
        return reduce(0) {
            $0 + $1.allocatedAmount.amount
        }
    }
}
