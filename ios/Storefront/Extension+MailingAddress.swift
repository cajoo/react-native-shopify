//
//  Extension+MailingAddress.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-17.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

extension Storefront.MailingAddress {
    
    var payAddress: PayAddress {
        return PayAddress(
            addressLine1: self.address1,
            addressLine2: self.address2,
            city: self.city,
            country: self.country,
            province: self.province,
            zip: self.zip,
            firstName: self.firstName,
            lastName: self.lastName,
            phone: self.phone,
            email: nil
        )
    }

}
