package com.rnshopifybuy

import androidx.annotation.NonNull
import com.facebook.react.bridge.*
import com.rnshopifybuy.core.Client
import com.shopify.buy3.*
import com.shopify.buy3.CreditCard
import com.shopify.buy3.Storefront.*
import com.shopify.graphql.support.ID
import java.io.IOException
import java.util.*


class RNShopifyBuyModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    private var client: Client? = null
    private var googlePayToken: String? = null

    override fun getName(): String {
        return "RNShopifyBuy"
    }

    @ReactMethod
    fun initialize(settings: ReadableMap) {
        val shopDomain: String? = settings.getString("shopDomain")
        val accessToken: String? = settings.getString("accessToken")
        val googlePayToken: String? = settings.getString("googlePayToken")

        if (shopDomain != null && accessToken !== null) {
            client = Client(reactContext, shopDomain, accessToken)
        } else {
            throw IllegalArgumentException("All following parameters need to be provided to initialize client: shopDomain, accessToken")
        }
        this.googlePayToken = googlePayToken
    }

    @ReactMethod
    fun creditCardVault(card: ReadableMap, promise: Promise) {
        client?.fetchCardVaultUrl {
            it?.let { shopName ->
                val cardClient: CardClient = CardClient()

                try {
                    val creditCard = CreditCard.builder()
                            .firstName(card.getString("firstName"))
                            .lastName(card.getString("lastName"))
                            .number(card.getString("number"))
                            .expireMonth(card.getString("expireMonth"))
                            .expireYear(card.getString("expireYear"))
                            .verificationCode(card.getString("verificationCode"))
                            .build()

                    cardClient.vault(creditCard, shopName).enqueue(object : CreditCardVaultCall.Callback {
                        override fun onResponse(@NonNull token: String) {
                            // proceed to complete checkout with token
                            promise.resolve(token)
                        }

                        override fun onFailure(error: IOException) {
                            // handle error
                            promise.reject("E_TOKEN", "Can't vault credit card", error)
                        }
                    })
                } catch (error: IOException) {
                    promise.reject("E_CREDIT_CARD", "Can't create credit card", error)
                }
            } ?: run {
                promise.reject("E_VAULT_URL", "Can't get cardVaultUrl")
            }
        } ?: run {
            promise.reject("E_NOT_INITIALIZED", "Client has not been initialized, please call initialize function first")
        }
    }

    @ReactMethod
    fun pay(checkoutID: String, promise: Promise) {
        promise.reject("E_NOT_IMPLEMENTED", "Google Pay is not implemented")
//        client?.fetchCheckoutById(checkoutID) {
//            it?.let { checkout ->
//                val shippingAddress = Storefront.MailingAddressInput()
//
//                shippingAddress.address1 = checkout.shippingAddress.address1
//                shippingAddress.address2 = checkout.shippingAddress.address2
//                shippingAddress.city = checkout.shippingAddress.city
//                shippingAddress.country = checkout.shippingAddress.country
//                shippingAddress.firstName = checkout.shippingAddress.firstName
//                shippingAddress.lastName = checkout.shippingAddress.lastName
//                shippingAddress.phone = checkout.shippingAddress.phone
//                shippingAddress.province = checkout.shippingAddress.province
//                shippingAddress.zip = checkout.shippingAddress.zip
//
//                val paymentInput = Storefront.TokenizedPaymentInput(checkout.totalPrice, googlePayToken, shippingAddress, "android_pay", googlePayToken).setIdentifier(googlePayToken)
//
//                val query = mutation { mutationQuery: MutationQuery ->
//                    mutationQuery
//                            .checkoutCompleteWithTokenizedPayment(ID(checkoutID), paymentInput
//                            ) { payloadQuery: CheckoutCompleteWithTokenizedPaymentPayloadQuery ->
//                                payloadQuery
//                                        .payment { paymentQuery: PaymentQuery ->
//                                            paymentQuery
//                                                    .ready()
//                                                    .errorMessage()
//                                        }
//                                        .checkout { checkoutQuery: CheckoutQuery ->
//                                            checkoutQuery
//                                                    .ready()
//                                        }
//                                        .userErrors { userErrorQuery: UserErrorQuery ->
//                                            userErrorQuery
//                                                    .field()
//                                                    .message()
//                                        }
//                            }
//                }
//
//                client?.getGraphClient()!!.mutateGraph(query).enqueue(object : GraphCall.Callback<Mutation> {
//                    override fun onResponse(response: GraphResponse<Mutation>) {
//                        if (!response.data()!!.checkoutCompleteWithTokenizedPayment.userErrors.isEmpty()) {
//                            // handle user friendly errors
//                        } else {
//                            val checkoutReady = response.data()!!.checkoutCompleteWithTokenizedPayment.checkout.ready
//                            val paymentReady = response.data()!!.checkoutCompleteWithTokenizedPayment.payment.ready
//                        }
//                    }
//
//                    override fun onFailure(error: GraphError) {
//                        // handle errors
//                    }
//                })
//            }
//        }
    }

}
