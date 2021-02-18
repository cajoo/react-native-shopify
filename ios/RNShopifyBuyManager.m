#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RNShopifyBuy, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize:(NSDictionary *)settings)
RCT_EXTERN_METHOD(creditCardVault:(NSDictionary *)cardDictionary resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(pay:(NSString)checkoutID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end
