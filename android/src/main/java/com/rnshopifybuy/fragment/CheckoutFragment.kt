package com.rnshopifybuy.fragment

import com.shopify.buy3.Storefront

class CheckoutFragment(private val query: Storefront.CheckoutQuery) {
    fun fragment() {
        query
                .ready()
                .requiresShipping()
                .taxesIncluded()
                .email()

                .appliedGiftCards { appliedGiftCards ->
                    appliedGiftCards
                            .balance()
                            .amountUsed()
                            .lastCharacters()
                }

                .shippingAddress { shippingAddress ->
                    shippingAddress
                            .firstName()
                            .lastName()
                            .phone()
                            .address1()
                            .address2()
                            .city()
                            .country()
                            .countryCodeV2()
                            .province()
                            .provinceCode()
                            .zip()
                }

                .shippingLine { shippingLine ->
                    shippingLine
                            .handle()
                            .title()
                            .price()
                }

                .lineItems({ args -> args.first(250) }) { lineItemConnection ->
                    lineItemConnection.edges { lineItemEdge ->
                        lineItemEdge.node { lineItemNode ->
                            lineItemNode
                                    .variant { variant -> variant.price() }
                                    .title()
                                    .quantity()
                        }
                    }
                }

                .webUrl()
                .currencyCode()
                .subtotalPrice()
                .totalTax()
                .totalPrice()
                .paymentDue()
    }
}