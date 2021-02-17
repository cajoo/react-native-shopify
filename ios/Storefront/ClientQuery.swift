//
//  ClientQuery.swift
//  RNShopifyBuy
//
//  Created by Jérémy Magrin on 2021-02-16.
//  Copyright © 2021 Facebook. All rights reserved.
//

import MobileBuySDK

final class ClientQuery {
    static func queryForShopName() -> Storefront.QueryRootQuery {
        return Storefront.buildQuery { $0
            .shop { $0
                .name()
            }
        }
    }
    
    static func queryForCardVaultUrl() -> Storefront.QueryRootQuery {
        return Storefront.buildQuery { $0
            .shop { $0
                .paymentSettings { $0
                    .cardVaultUrl()
                }
            }
        }
    }
    
    static func queryForCheckout(id: GraphQL.ID) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery { $0
            .node(id: id) { $0
                .id()
                .onCheckout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
}
