//
//  FFFTimerViewController.h
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/30/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface FFFTimerViewController : UIViewController

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@end
