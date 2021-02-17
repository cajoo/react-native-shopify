//
//  Extension+AppliedGiftCard.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-17.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.AppliedGiftCard {
    
    var payGiftCard: PayGiftCard {
        return PayGiftCard(
            id: self.id.rawValue,
            balance: self.balanceV2.amount,
            amount: self.amountUsedV2.amount,
            lastCharacters: self.lastCharacters
        )
    }

}
