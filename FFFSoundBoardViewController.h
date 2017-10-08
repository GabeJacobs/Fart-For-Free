//
//  FFFSoundBoardViewController.h
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/30/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface FFFSoundBoardViewController : UIViewController  <GADBannerViewDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@end
