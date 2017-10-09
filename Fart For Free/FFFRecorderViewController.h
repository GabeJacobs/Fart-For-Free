//
//  FFFRecorderViewController.h
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/31/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface FFFRecorderViewController : UIViewController <GADBannerViewDelegate, AVAudioPlayerDelegate , UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic) int selectedRow;

@end
