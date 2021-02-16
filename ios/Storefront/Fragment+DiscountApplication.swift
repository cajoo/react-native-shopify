//
//  Fragment+DiscountApplication.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-16.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.DiscountApplicationQuery {
    
    @discardableResult
    func fragmentForDiscountApplication() -> Storefront.DiscountApplicationQuery { return self
        .onDiscountCodeApplication { $0
            .applicable()
            .code()
        }
        .onManualDiscountApplication { $0
            .title()
        }
        .onScriptDiscountApplication { $0
            .title()
        }
    }
}
