//
//  FFUnlockedFartsViewController.m
//  Fart For Free
//
//  Created by Gabe Jacobs on 10/2/17.
//  Copyright © 2017 Gabe Jacobs. All rights reserved.
//

#import "FFFUnlockedFartsViewController.h"

static NSString * const kReplaceWithYourAdID = @"fart.premium.page";

///Used to track whether the in-app purchases failed alert has been shown
static NSString * const kIAPFailAlertShown = @"IAPFailAlertShown";

@interface FFFUnlockedFartsViewController () <UIAlertViewDelegate>

@end

@implementation FFFUnlockedFartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.iapManager = [[DNSInAppPurchaseManager alloc] init];
	self.iapManager.delegate = self;
	[self setupStore];
	
	self.background = [[UIImageView alloc] initWithFrame:self.view.frame];
	[self.background setImage:[UIImage imageNamed:@"Background.png"]];
	[self.view addSubview:self.background];
	
	[GADRewardBasedVideoAd sharedInstance].delegate = self;
	
	self.player = [[AVAudioPlayer alloc] init];
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *error = nil;
	BOOL result = NO;
	if ([audioSession respondsToSelector:@selector(setActive:withOptions:error:)]) {
		result = [audioSession setActive:YES withOptions:0 error:&error]; // iOS6+
	} else {
		[audioSession setActive:YES withFlags:0 error:&error]; // iOS5 and below
	}
	if (!result && error) {
		// deal with the error
	}
	
	error = nil;
	result = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
	
	if (!result && error) {
		// deal with the error
	}
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	
	
	UIImage* fartImage = [UIImage imageNamed:@"Fart.png"];
	if (IDIOM == IPAD) {
		fartImage = [UIImage imageNamed:@"FARTipad"];
	}
	self.fartLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, fartImage.size.width*2.0, fartImage.size.height*2.0)];
	[self.fartLogo setImage:fartImage];
	self.fartLogo.frame = CGRectMake(self.fartLogo.center.x - (self.fartLogo.bounds.origin.x/2) - ((self.fartLogo.image.size.width/1.75)/2) ,self.fartLogo.center.y - (self.fartLogo.bounds.origin.y/2) -((self.fartLogo.image.size.height/1.75)/2),self.fartLogo.image.size.width/1.75, self.fartLogo.image.size.height/1.75);
	self.fartLogo.center = self.view.center;
	[self.view addSubview:self.fartLogo];
	CGSize screen = [[UIScreen mainScreen] bounds].size;

	UIImage* premiumImage = [UIImage imageNamed:@"PREMIUM"];
	if (IDIOM == IPAD) {
		premiumImage = [UIImage imageNamed:@"PREMIUMipad"];
	}
	self.premium = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, premiumImage.size.width, premiumImage.size.height)];
	[self.premium setImage:premiumImage];
	self.premium.center = CGPointMake(self.view.center.x + 90, self.view.center.y + 40);
	if (IDIOM == IPAD) {
		self.premium.center = CGPointMake(self.view.center.x + 120, self.view.center.y + 90);
	}
	if(screen.height != 480) {
		[self.view addSubview:self.premium];
	}

	if(screen.height == 480){
		
		self.fartLogo.frame = CGRectMake(self.fartLogo.frame.origin.x, self.fartLogo.frame.origin.y - 140,self.fartLogo.frame.size.width, self.fartLogo.frame.size.height);
		self.premium.frame = CGRectMake(self.premium.frame.origin.x, self.premium.frame.origin.y - 140 ,self.premium.frame.size.width, self.premium.frame.size.height);

	}
	else{

		if (IDIOM == IPAD) {
			
			self.fartLogo.frame = CGRectMake(self.fartLogo.frame.origin.x, self.fartLogo.frame.origin.y - 395,self.fartLogo.frame.size.width  *1.25, self.fartLogo.frame.size.height * 1.25);
			self.fartLogo.center = CGPointMake(self.view.center.x, self.fartLogo.center.y);
			self.premium.center = CGPointMake(self.fartLogo.center.x + 100, self.fartLogo.center.y + 90);
			
		} else{
			self.fartLogo.frame = CGRectMake(self.fartLogo.frame.origin.x, self.fartLogo.frame.origin.y - 165,self.fartLogo.frame.size.width, self.fartLogo.frame.size.height);
			self.premium.frame = CGRectMake(self.premium.frame.origin.x, self.premium.frame.origin.y - 165 ,self.premium.frame.size.width, self.premium.frame.size.height);
		}
	}

	[self setupButtons];

	
	self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
	self.bannerView.adUnitID = @"ca-app-pub-3677742875636291/8598865284";
	self.bannerView.rootViewController = self;
	[self.view addSubview:self.bannerView];
	self.bannerView.delegate = self;
	self.bannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bannerView.frame.size.height);
	[self.bannerView loadRequest:[GADRequest request]];
	
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // Do any additional setup after loading the view.
}


- (void)setupButtons {

	
	CGSize result = [[UIScreen mainScreen] bounds].size;
	BOOL isFour = NO;
	if(result.height == 480){
		isFour = YES;
	}
	
	self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button1 setImage:[UIImage imageNamed:@"Group.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button1 setImage:[UIImage imageNamed:@"Groupipad.png"] forState:UIControlStateNormal];
	}
	self.button1.frame = CGRectMake(19, isFour ? 150 : 205, self.button1.imageView.image.size.width, self.button1.imageView.image.size.height);
	[self.button1 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button1.tag = 1;
	if (IDIOM == IPAD) {
		self.button1.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button1.frame.size.height + 60);
		self.button1.center = CGPointMake(self.button1.center.x, self.view.center.y - 150);
		self.button1.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button1];
	
	self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button2 setImage:[UIImage imageNamed:@"Group 2.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button2 setImage:[UIImage imageNamed:@"Group 2ipad.png"] forState:UIControlStateNormal];
	}
	self.button2.frame = CGRectMake(94, isFour ? 150 : 205, self.button2.imageView.image.size.width, self.button2.imageView.image.size.height);
	[self.button2 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button2.tag = 2;
	if (IDIOM == IPAD) {
		self.button2.frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/4, self.button2.frame.size.height + 60);
		self.button2.center = CGPointMake(self.button2.center.x, self.view.center.y - 150);
		self.button2.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button2];
	
	self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button3 setImage:[UIImage imageNamed:@"Group 3.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button3 setImage:[UIImage imageNamed:@"Group 3ipad.png"] forState:UIControlStateNormal];
	}
	self.button3.frame = CGRectMake(169, isFour ? 150 : 205, self.button3.imageView.image.size.width, self.button3.imageView.image.size.height);
	[self.button3 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button3.tag = 3;
	if (IDIOM == IPAD) {
		self.button3.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button3.frame.size.height + 60);
		self.button3.center = CGPointMake(self.button3.center.x, self.view.center.y - 150);
		self.button3.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button3];
	
	self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button4 setImage:[UIImage imageNamed:@"Group 4.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button4 setImage:[UIImage imageNamed:@"Group 4ipad.png"] forState:UIControlStateNormal];
	}
	self.button4.frame = CGRectMake(244, isFour ? 150 : 205, self.button4.imageView.image.size.width, self.button4.imageView.image.size.height);
	[self.button4 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button4.tag = 4;
	if (IDIOM == IPAD) {
		self.button4.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button4.frame.size.height + 60);
		self.button4.center = CGPointMake(self.button4.center.x, self.view.center.y - 150);
		self.button4.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button4];
	
	
	self.button5 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button5 setImage:[UIImage imageNamed:@"Group 5.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button5 setImage:[UIImage imageNamed:@"Group 5ipad.png"] forState:UIControlStateNormal];
	}
	self.button5.frame = CGRectMake(19, isFour ? 205 : 265, self.button5.imageView.image.size.width, self.button5.imageView.image.size.height);
	[self.button5 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button5.tag = 5;
	if (IDIOM == IPAD) {
		self.button5.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button5.frame.size.height + 60);
		self.button5.center = CGPointMake(self.button5.center.x, self.view.center.y - 30);
		self.button5.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button5];
	
	self.button6 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button6 setImage:[UIImage imageNamed:@"Group 6.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button6 setImage:[UIImage imageNamed:@"Group 6ipad.png"] forState:UIControlStateNormal];
	}
	self.button6.frame = CGRectMake(94, isFour ? 205 : 265, self.button6.imageView.image.size.width, self.button6.imageView.image.size.height);
	[self.button6 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button6.tag = 6;
	if (IDIOM == IPAD) {
		self.button6.frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/4, self.button6.frame.size.height + 60);
		self.button6.center = CGPointMake(self.button6.center.x, self.view.center.y - 30);
		self.button6.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button6];
	
	self.button7 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button7 setImage:[UIImage imageNamed:@"Group 7.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button7 setImage:[UIImage imageNamed:@"Group 7ipad.png"] forState:UIControlStateNormal];
	}
	self.button7.frame = CGRectMake(169, isFour ? 205 : 265, self.button7.imageView.image.size.width, self.button7.imageView.image.size.height);
	[self.button7 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button7.tag = 7;
	if (IDIOM == IPAD) {
		self.button7.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button7.frame.size.height + 60);
		self.button7.center = CGPointMake(self.button7.center.x, self.view.center.y - 30);
		self.button7.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button7];
	
	self.button8 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button8 setImage:[UIImage imageNamed:@"Group 8.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button8 setImage:[UIImage imageNamed:@"Group 8ipad.png"] forState:UIControlStateNormal];
	}
	self.button8.frame = CGRectMake(244, isFour ? 205 : 265, self.button8.imageView.image.size.width, self.button8.imageView.image.size.height);
	[self.button8 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button8.tag = 8;
	if (IDIOM == IPAD) {
		self.button8.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button8.frame.size.height + 60);
		self.button8.center = CGPointMake(self.button8.center.x, self.view.center.y - 30);
		self.button8.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button8];
	
	self.button9 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button9 setImage:[UIImage imageNamed:@"Group 9.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button9 setImage:[UIImage imageNamed:@"Group 9ipad.png"] forState:UIControlStateNormal];
	}
	self.button9.frame = CGRectMake(19, isFour ? 260 : 325, self.button9.imageView.image.size.width, self.button9.imageView.image.size.height);
	[self.button9 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button9.tag = 9;
	if (IDIOM == IPAD) {
		self.button9.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button9.frame.size.height + 60);
		self.button9.center = CGPointMake(self.button9.center.x, self.view.center.y + 90);
		self.button9.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button9];
	
	self.button10 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button10 setImage:[UIImage imageNamed:@"Group 10.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button10 setImage:[UIImage imageNamed:@"Group 10ipad.png"] forState:UIControlStateNormal];
	}
	self.button10.frame = CGRectMake(94, isFour ? 260 : 325, self.button10.imageView.image.size.width, self.button10.imageView.image.size.height);
	[self.button10 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button10.tag = 10;
	if (IDIOM == IPAD) {
		self.button10.frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/4, self.button10.frame.size.height + 60);
		self.button10.center = CGPointMake(self.button10.center.x, self.view.center.y + 90);
		self.button10.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button10];
	
	self.button11 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button11 setImage:[UIImage imageNamed:@"Group 11.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button11 setImage:[UIImage imageNamed:@"Group 11ipad.png"] forState:UIControlStateNormal];
	}
	self.button11.frame = CGRectMake(169, isFour ? 260 : 325, self.button11.imageView.image.size.width, self.button11.imageView.image.size.height);
	[self.button11 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button11.tag = 11;
	if (IDIOM == IPAD) {
		self.button11.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button11.frame.size.height + 60);
		self.button11.center = CGPointMake(self.button11.center.x, self.view.center.y + 90);
		self.button11.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button11];
	
	self.button12 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button12 setImage:[UIImage imageNamed:@"Group 12.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button12 setImage:[UIImage imageNamed:@"Group 12ipad.png"] forState:UIControlStateNormal];
	}
	self.button12.frame = CGRectMake(244, isFour ? 260 : 325, self.button12.imageView.image.size.width, self.button12.imageView.image.size.height);
	[self.button12 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button12.tag = 12;
	if (IDIOM == IPAD) {
		self.button12.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button12.frame.size.height + 60);
		self.button12.center = CGPointMake(self.button12.center.x, self.view.center.y + 90);
		self.button12.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button12];
	
	self.button13 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button13 setImage:[UIImage imageNamed:@"Group 13.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button13 setImage:[UIImage imageNamed:@"Group 13ipad.png"] forState:UIControlStateNormal];
	}
	self.button13.frame = CGRectMake(19, isFour ? 315 : 385, self.button13.imageView.image.size.width, self.button13.imageView.image.size.height);
	[self.button13 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button13.tag = 13;
	if (IDIOM == IPAD) {
		self.button13.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button13.frame.size.height + 60);
		self.button13.center = CGPointMake(self.button13.center.x, self.view.center.y + 210);
		self.button13.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button13];
	
	self.button14 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button14 setImage:[UIImage imageNamed:@"Group 14.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button14 setImage:[UIImage imageNamed:@"Group 14ipad.png"] forState:UIControlStateNormal];
	}
	self.button14.frame = CGRectMake(94, isFour ? 315 : 385, self.button14.imageView.image.size.width, self.button14.imageView.image.size.height);
	[self.button14 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button14.tag = 14;
	if (IDIOM == IPAD) {
		self.button14.frame = CGRectMake((self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button14.frame.size.height + 60);
		self.button14.center = CGPointMake(self.button14.center.x, self.view.center.y + 210);
		self.button14.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button14];
	
	self.button15 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button15 setImage:[UIImage imageNamed:@"Group 15.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button15 setImage:[UIImage imageNamed:@"Group 15ipad.png"] forState:UIControlStateNormal];
	}
	self.button15.frame = CGRectMake(169, isFour ? 315 : 385, self.button15.imageView.image.size.width, self.button15.imageView.image.size.height);
	[self.button15 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button15.tag = 15;
	if (IDIOM == IPAD) {
		self.button15.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button15.frame.size.height + 60);
		self.button15.center = CGPointMake(self.button15.center.x, self.view.center.y + 210);
		self.button15.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button15];
	
	self.button16 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button16 setImage:[UIImage imageNamed:@"Group 16.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button16 setImage:[UIImage imageNamed:@"Group 16ipad.png"] forState:UIControlStateNormal];
	}
	self.button16.frame = CGRectMake(244, isFour ? 315 : 385, self.button16.imageView.image.size.width, self.button16.imageView.image.size.height);
	[self.button16 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button16.tag = 16;
	if (IDIOM == IPAD) {
		self.button16.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button16.frame.size.height + 60);
		self.button16.center = CGPointMake(self.button16.center.x, self.view.center.y + 210);
		self.button16.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button16];

	self.button17 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button17 setImage:[UIImage imageNamed:@"Group 17.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button17 setImage:[UIImage imageNamed:@"Group 17ipad.png"] forState:UIControlStateNormal];
	}
	self.button17.frame = CGRectMake(19, isFour ? 370 : 445, self.button17.imageView.image.size.width, self.button17.imageView.image.size.height);
	[self.button17 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button17.tag = 17;
	if (IDIOM == IPAD) {
		self.button17.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button17.frame.size.height + 60);
		self.button17.center = CGPointMake(self.button17.center.x, self.view.center.y + 330);
		self.button17.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button17];
	
	self.button18 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button18 setImage:[UIImage imageNamed:@"Group 18.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button18 setImage:[UIImage imageNamed:@"Group 18ipad.png"] forState:UIControlStateNormal];
	}
	self.button18.frame = CGRectMake(94, isFour ? 370 : 445, self.button18.imageView.image.size.width, self.button18.imageView.image.size.height);
	[self.button18 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button18.tag = 18;
	if (IDIOM == IPAD) {
		self.button18.frame = CGRectMake((self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button18.frame.size.height + 60);
		self.button18.center = CGPointMake(self.button18.center.x, self.view.center.y + 330);
		self.button18.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button18];
	
	self.button19 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button19 setImage:[UIImage imageNamed:@"Group 19.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button19 setImage:[UIImage imageNamed:@"Group 19ipad.png"] forState:UIControlStateNormal];
	}
	self.button19.frame = CGRectMake(169, isFour ? 370 : 445, self.button19.imageView.image.size.width, self.button19.imageView.image.size.height);
	[self.button19 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button19.tag = 19;
	if (IDIOM == IPAD) {
		self.button19.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button19.frame.size.height + 60);
		self.button19.center = CGPointMake(self.button19.center.x, self.view.center.y + 330);
		self.button19.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button19];
	
	self.button20 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button20 setImage:[UIImage imageNamed:@"Group 20.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button20 setImage:[UIImage imageNamed:@"Group 20ipad.png"] forState:UIControlStateNormal];
	}
	self.button20.frame = CGRectMake(244, isFour ? 370 : 445, self.button20.imageView.image.size.width, self.button20.imageView.image.size.height);
	[self.button20 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
	self.button20.tag = 20;
	if (IDIOM == IPAD) {
		self.button20.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button20.frame.size.height + 60);
		self.button20.center = CGPointMake(self.button20.center.x, self.view.center.y + 330);
		self.button20.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button20];

}

- (void)checkUnlock {
	NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"UNLOCK_DATE"];
	if(date){
		self.isUnlocked = YES;
	} else{
		NSLog(@"Never got unlocked");
		self.isUnlocked = NO;
	}
	
}
-(void)playFart:(UIButton*)sender{
	[self checkUnlock];
	if(!self.isUnlocked){
	
		if (self.availableProducts) {
			SKProduct *selectedProduct = self.availableProducts[0];
			typeof(self) __weak weakSelf = self;
			
			//Delegate guarantees callback on main thread, fire on BG so as not to block UI.
			NSOperationQueue *background = [[NSOperationQueue alloc] init];
			[background addOperationWithBlock:^{
				[weakSelf.iapManager purchaseProduct:selectedProduct];
			}];
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchases unavailable"
															message:@"We apologize. Purchases are unavailable at the moment."
														   delegate:self
												  cancelButtonTitle:nil
												  otherButtonTitles:@"Okay!", nil];
			[alert show];
			
		}
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlock Premium"
//														message:@"Watch an ad to unlock premium farts for 10 minutes!"
//													   delegate:self
//											  cancelButtonTitle:nil
//											  otherButtonTitles:@"No thanks", @"Okay!", nil];
//		[alert show];
	
	} else {
		UIButton *buttonClicked = (UIButton *)sender;
		NSURL *audioPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"Dart%ld", (long)buttonClicked.tag] withExtension:@"mp3"];
		self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioPath error:nil];
		[self.player play];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
	NSDate *date = [NSDate date];
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:@"UNLOCK_DATE"]; //
	self.isUnlocked = YES;
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
	NSLog(@"Reward based video ad is received.");
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
	NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
	NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
	NSLog(@"Reward based video ad is closed.");
	if(self.isUnlocked) {
	
	}
	[[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
										   withAdUnitID:@"ca-app-pub-3677742875636291/8790125677"];
	[GADRewardBasedVideoAd sharedInstance].delegate = self;
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
	NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
	didFailToLoadWithError:(NSError *)error {
	NSLog(@"Reward based video ad failed to load.");
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	// the user clicked OK
	if (buttonIndex == 1) {
		if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
			[[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
		}
	} else{
		
	}
}


#pragma mark - In-App Purchase setup
-(void)setupStore
{
	

	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([self.iapManager canMakePurchases]) {
		//Reset whether the IAP fail alert has been shown
		[defaults setBool:NO forKey:kIAPFailAlertShown];
		[defaults synchronize];
		
		//Run on background thread - delegate forces callbacks on main thread.
		NSOperationQueue *background = [[NSOperationQueue alloc] init];
		__block DNSInAppPurchaseManager *blockManager = self.iapManager;
		[background addOperationWithBlock:^{
			//Gets your store items.
			[blockManager loadStoreWithIdentifiers:[NSSet setWithObject:kReplaceWithYourAdID]];
		}];
	} else {
		if (![defaults boolForKey:kIAPFailAlertShown]) {
			//[MBProgressHUD hideHUDForView:self.view animated:YES];
			//Warn the user
			UIAlertView *disabled = [self.iapManager cantMakePurchasesAlert];
			[disabled show];
			
			//Note that this alert has been shown.
			[defaults setBool:YES forKey:kIAPFailAlertShown];
			[defaults synchronize];
		}
		
//		[self.testProductButton setTitle:NSLocalizedString(@"IAP Disabled On This Device", @"Error button title for IAP disabled") forState:UIControlStateNormal];
	}
}

#pragma mark - Convenience
-(void)showErrorAlertView:(NSString *)message
{
	[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
								message:message
							   delegate:nil
					  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
					  otherButtonTitles:nil] show];
}


-(void)purchaseSucceeded
{
	NSDate *date = [NSDate date];
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:@"UNLOCK_DATE"]; //
	
	self.isUnlocked = YES;
}

#pragma mark - In App Purchase Manager Delegate
-(void)productRetrievalFailed:(NSString *)errorMessage
{
	[MBProgressHUD hideHUDForView:self.view animated:YES];

	[self showErrorAlertView:errorMessage];
}

-(void)productsRetrieved:(NSArray *)products
{
	[MBProgressHUD hideHUDForView:self.view animated:YES];

	if (products) {
		//Store your available products.
		self.availableProducts = products;
		
		//Since we know there's only one product:
		SKProduct *firstProduct = [products firstObject];

	} else {
		[self showErrorAlertView:@"No products retrieved from ITC!"];
	}
}

-(void)purchaseFailed:(NSString *)errorMessage
{
	[self showErrorAlertView:errorMessage];
	self.isUnlocked = NO;
	
}

-(void)purchaseCancelled {
	
}

-(void)purchaseSucceeded:(NSString *)productIdentifier
{
	if ([productIdentifier isEqualToString:kReplaceWithYourAdID]) {
		[self purchaseSucceeded];
	} //check other purchases with else-if statements here.
}

-(void)restorationSucceeded{
	NSDate *date = [NSDate date];
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:@"UNLOCK_DATE"]; //
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enjoy!"
													message:@"Enjoy premium!"
												   delegate:self
										  cancelButtonTitle:nil
										  otherButtonTitles:@"Thanks!", nil];
	[alert show];
}

-(void)restorationFailedWithError:(NSString *)errorMessage
{
	[self showErrorAlertView:errorMessage];

}

@end
