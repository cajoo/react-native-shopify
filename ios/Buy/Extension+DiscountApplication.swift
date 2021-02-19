//
//  Extension+DiscountApplication.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-17.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension DiscountApplication {

    var resolvedViewModel: String {
        switch self {
        case let discount as Storefront.DiscountCodeApplication:
            return discount.code
        case let discount as Storefront.ManualDiscountApplication:
            return discount.title
        case let discount as Storefront.ScriptDiscountApplication:
            return discount.title
        case let discount as Storefront.AutomaticDiscountApplication:
            return discount.title
        default:
            fatalError("Unsupported DiscountApplication type: \(type(of: self))")
        }
    }

}
