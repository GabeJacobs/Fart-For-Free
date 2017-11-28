//
//  FFUnlockedFartsViewController.h
//  Fart For Free
//
//  Created by Gabe Jacobs on 10/2/17.
//  Copyright © 2017 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "DNSInAppPurchaseManager.h"
#import "MBProgressHUD.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface FFFUnlockedFartsViewController : UIViewController <GADRewardBasedVideoAdDelegate, GADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic,strong) GADBannerView *bannerView;
@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) UIImageView *fartLogo;
@property (nonatomic,strong) UIImageView *premium;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) UIButton *button5;
@property (nonatomic,strong) UIButton *button6;
@property (nonatomic,strong) UIButton *button7;
@property (nonatomic,strong) UIButton *button8;
@property (nonatomic,strong) UIButton *button9;
@property (nonatomic,strong) UIButton *button10;
@property (nonatomic,strong) UIButton *button11;
@property (nonatomic,strong) UIButton *button12;
@property (nonatomic,strong) UIButton *button13;
@property (nonatomic,strong) UIButton *button14;
@property (nonatomic,strong) UIButton *button15;
@property (nonatomic,strong) UIButton *button16;
@property (nonatomic,strong) UIButton *button17;
@property (nonatomic,strong) UIButton *button18;
@property (nonatomic,strong) UIButton *button19;
@property (nonatomic,strong) UIButton *button20;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic) BOOL isUnlocked;
@property (nonatomic, strong) SKProduct *validProduct;
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, strong) DNSInAppPurchaseManager *iapManager;
@property (nonatomic, strong) NSArray *validProducts;
@property (nonatomic, strong) MBProgressHUD *hud;



@end
