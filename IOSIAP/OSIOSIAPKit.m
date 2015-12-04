//
//  OSIOSIAPKit.m
//  IOSIAP
//
//  Created by w99wen on 15/12/2.
//  Copyright © 2015年 com.longtugame. All rights reserved.
//

#import "OSIOSIAPKit.h"
#import "StoreManager.h"
#import "StoreObserver.h"

@interface OSIOSIAPKit()

@end

@implementation OSIOSIAPKit
static NSString *productIdsJsonString_;
static BOOL isFetchDone;
+ (OSIOSIAPKit *)sharedInstance{
    static dispatch_once_t onceToken;
    static OSIOSIAPKit * OSIOSIAPKitSharedInstance;
    
    dispatch_once(&onceToken, ^{
        OSIOSIAPKitSharedInstance = [[OSIOSIAPKit alloc] init];
        
    });
    return OSIOSIAPKitSharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleProductRequestNotification:)
                                                     name:IAPProductRequestNotification
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handlePurchasesNotification:)
                                                     name:IAPPurchaseNotification
                                                   object:nil];
        isFetchDone = NO;
    }
    return self;
}
+ (void)fetchProductInformationForIds:(NSString *)productIdsJsonString{
    isFetchDone = NO;
    productIdsJsonString_ = productIdsJsonString;
    NSError *err;
    NSDictionary *productIdsDic = [NSJSONSerialization JSONObjectWithData:[productIdsJsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&err];
    [[StoreManager sharedInstance] fetchProductInformationForIds:productIdsDic[@"productIds"]];
}
+ (void)buy:(NSString *)productId{
    if (isFetchDone) {
        if ([[StoreManager sharedInstance] getProductByIdentifier:productId]) {
            [[StoreObserver sharedInstance] buy:[[StoreManager sharedInstance] getProductByIdentifier:productId]];
            NSLog(@"IAP : payment is processing");
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:IAPPurchaseNotification object:@{@"result":@"Fail"}];
        }
    }else{
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [OSIOSIAPKit buy:productId];
//            });
//        });
        [[OSIOSIAPKit sharedInstance].delegate onPaymentResult:OSIOSIAPFail info:@{@"result":@"Fail"}];
    }
}
+ (id<SKPaymentTransactionObserver>)getDelegateInstance{
    return [StoreObserver sharedInstance];
}
-(void)handleProductRequestNotification:(NSNotification *)notification{
    if (![((NSString *)notification.object) isEqualToString:@"Success"]) {
        [self.delegate onProductRequestResult:OSIOSIAPFail info:@{}];
    }else{
        isFetchDone = YES;
        [self.delegate onProductRequestResult:OSIOSIAPSuccess info:@{}];
    }
}
-(void)handlePurchasesNotification:(NSNotification *)notification{
    NSLog(@"handlePurchasesNotification:notification = %@",[notification description]);
    NSDictionary *infoDic = notification.object;
    if ([infoDic[@"result"] isEqualToString:@"Success"]) {
        [self.delegate onPaymentResult:OSIOSIAPSuccess info:infoDic[@"result"]];
    }else{
        [self.delegate onPaymentResult:OSIOSIAPFail info:infoDic[@"result"]];
    }
}
@end
