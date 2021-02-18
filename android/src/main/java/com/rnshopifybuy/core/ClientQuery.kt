package com.rnshopifybuy.core

import com.shopify.buy3.Storefront.*
import com.shopify.graphql.support.ID
import com.rnshopifybuy.fragment.CheckoutFragment

class ClientQuery {
    companion object {
        fun queryForShopName(): QueryRootQuery {
            return query { rootQuery ->
                rootQuery
                        .shop { shopQuery ->
                            shopQuery
                                    .name()
                        }
            }
        }

        fun queryForCardVaultUrl(): QueryRootQuery {
            return query { rootQuery ->
                rootQuery
                        .shop { shopQuery ->
                            shopQuery
                                    .paymentSettings { paymentSettings ->
                                        paymentSettings
                                                .cardVaultUrl()
                                    }
                        }
            }
        }

        fun queryForCheckout(id: ID): QueryRootQuery {
            return query { rootQuery ->
                rootQuery
                        .node(id) { nodeQuery ->
                            nodeQuery
                                    .id()
                                    .onCheckout { checkout ->
                                        CheckoutFragment(checkout).fragment()
                                    }
                        }
            }
        }
    }
}