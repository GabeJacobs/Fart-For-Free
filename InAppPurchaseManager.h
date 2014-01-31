//
//  InAppPurchaseManager.h
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/31/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

@end