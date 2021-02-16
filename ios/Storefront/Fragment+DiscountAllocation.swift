//
//  Fragment+DiscountAllocation.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-16.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.DiscountAllocationQuery {
    
    @discardableResult
    func fragmentForDiscountAllocation() -> Storefront.DiscountAllocationQuery { return self
        .allocatedAmount { $0
            .amount()
            .currencyCode()
        }
        .discountApplication { $0
            .fragmentForDiscountApplication()
        }
    }
}
