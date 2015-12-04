//
//  OSIOSIAPKit.h
//  IOSIAP
//
//  Created by w99wen on 15/12/2.
//  Copyright © 2015年 com.longtugame. All rights reserved.
//

#import <Foundation/Foundation.h>
@import StoreKit;

typedef  NS_ENUM(NSInteger, OSIOSIAPResult){
    OSIOSIAPSuccess,
    OSIOSIAPFail,
};

@protocol OSIOSIAPProtocal <NSObject>

-(void)onProductRequestResult:(OSIOSIAPResult)result info:(NSDictionary *)info;

//{
//    purchasedID = "doudizhu_test001";
//    receipt = "...";
//    result = Success;
//}

-(void)onPaymentResult:(OSIOSIAPResult)result info:(NSDictionary *)info;

@end

@interface OSIOSIAPKit : NSObject
@property (nonatomic, retain) id<OSIOSIAPProtocal> delegate;

+ (OSIOSIAPKit *)sharedInstance;
//{"productIds":["doudizhu_test001","doudizhu_test002"]}
+ (void)fetchProductInformationForIds:(NSString *)productIdsJsonString;
+ (void)buy:(NSString *)productId;
+ (id<SKPaymentTransactionObserver>)getDelegateInstance;
@end
