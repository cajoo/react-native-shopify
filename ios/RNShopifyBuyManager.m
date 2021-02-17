#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNShopifyBuy, NSObject)

RCT_EXTERN_METHOD(initialize:(NSString)shopDomain accessTokenParameter:(NSString)accessToken localeParameter:(NSString)locale)
RCT_EXTERN_METHOD(creditCardVault:(NSDictionary *)cardDictionary resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(applePay:(NSString)merchantID checkoutIDParameter:(NSString)checkoutID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end
