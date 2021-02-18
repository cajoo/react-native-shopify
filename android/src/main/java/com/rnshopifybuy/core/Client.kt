package com.rnshopifybuy.core

import android.content.ContentValues.TAG
import android.util.Log
import androidx.annotation.NonNull
import com.facebook.react.bridge.ReactApplicationContext
import com.shopify.buy3.*
import com.shopify.graphql.support.ID
import java.io.File
import java.util.concurrent.TimeUnit


class Client(reactContext: ReactApplicationContext, shopDomain: String, accessToken: String) {
    private val graphClient: GraphClient = GraphClient.builder(reactContext)
            .shopDomain(shopDomain)
            .accessToken(accessToken)
            .httpCache(File(reactContext.applicationContext.cacheDir, "/http"), (10 * 1024 * 1024).toLong()) // 10mb for http cache
            .defaultHttpCachePolicy(HttpCachePolicy.CACHE_FIRST.expireAfter(5, TimeUnit.MINUTES)) // cached response valid by default for 5 minutes
            .build()

    fun getGraphClient(): GraphClient {
        return graphClient
    }

    fun fetchShopName(completion: (shopName: String?) -> Unit) {
        val call = graphClient.queryGraph(ClientQuery.queryForShopName())

        call.enqueue(object : GraphCall.Callback<Storefront.QueryRoot> {
            override fun onResponse(@NonNull response: GraphResponse<Storefront.QueryRoot>) {
                val name = response.data()!!.shop.name

                completion(name)
            }

            override fun onFailure(@NonNull error: GraphError) {
                Log.e(TAG, "Failed to fetch shopName", error)
                completion(null)
            }
        })
    }

    fun fetchCardVaultUrl(completion: (String?) -> Unit) {
        val call = graphClient.queryGraph(ClientQuery.queryForCardVaultUrl())

        call.enqueue(object : GraphCall.Callback<Storefront.QueryRoot> {
            override fun onResponse(@NonNull response: GraphResponse<Storefront.QueryRoot>) {
                val cardVaultUrl = response.data()!!.shop.paymentSettings.cardVaultUrl

                completion(cardVaultUrl)
            }

            override fun onFailure(@NonNull error: GraphError) {
                Log.e(TAG, "Failed to fetch cardVaultUrl", error)
                completion(null)
            }
        })
    }

    fun fetchCheckoutById(id: String, completion: (Storefront.Checkout?) -> Unit) {
        val call = graphClient.queryGraph(ClientQuery.queryForCheckout(ID(id)))

        call.enqueue(object : GraphCall.Callback<Storefront.QueryRoot> {
            override fun onResponse(@NonNull response: GraphResponse<Storefront.QueryRoot>) {
                val checkout = response.data()!!.node as Storefront.Checkout

                completion(checkout)
            }

            override fun onFailure(@NonNull error: GraphError) {
                Log.e(TAG, "Failed to fetch cardVaultUrl", error)
                completion(null)
            }
        })
    }
}