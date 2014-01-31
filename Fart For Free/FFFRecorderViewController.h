//
//  FFFRecorderViewController.h
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/31/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>


@interface FFFRecorderViewController : UIViewController <GADBannerViewDelegate, AVAudioPlayerDelegate , UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@end
