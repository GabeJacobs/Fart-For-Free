//
//  FFFSoundBoardViewController.m
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/30/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import "FFFSoundBoardViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import <GoogleMobileAds/GoogleMobileAds.h>


@interface FFFSoundBoardViewController ()

@property (nonatomic) SystemSoundID mySound;
@property (nonatomic,strong) UIImageView *fartLogo;
@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) UIImageView *forFree;
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
@property (nonatomic,strong) GADBannerView *bannerView;


@end

@implementation FFFSoundBoardViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor redColor];
    
    [super viewDidLoad];
	
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
    
    
    self.background = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, [[UIScreen mainScreen] bounds].size.width+2, ([[UIScreen mainScreen] bounds].size.height+2))];
    [self.background setImage:[UIImage imageNamed:@"Background.png"]];
    [self.view addSubview:self.background];
	
    UIImage* fartImage = [UIImage imageNamed:@"Fart.png"];
	if (IDIOM == IPAD) {
		fartImage = [UIImage imageNamed:@"FARTipad"];
	}
    self.fartLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, fartImage.size.width*2.0, fartImage.size.height*2.0)];

    [self.fartLogo setImage:fartImage];
    self.fartLogo.center = self.view.center;
    [self.view addSubview:self.fartLogo];
    
    NSTimer *fartTimer = [NSTimer scheduledTimerWithTimeInterval:.9 target:self selector:@selector(fartLogoAnimation) userInfo:nil repeats:NO];
    
    
    self.fartLogo.hidden = YES;
    self.tabBarController.tabBar.alpha = 0.0;

   
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-3677742875636291/8598865284";
    self.bannerView.rootViewController = self;
    self.bannerView.alpha = 0.0;
	self.bannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bannerView.frame.size.height);
    [self.view addSubview:self.bannerView];
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:[GADRequest request]];
   
}


-(void)fartLogoAnimation{
    self.fartLogo.hidden = NO;
    
    SystemSoundID soundID;
    NSURL *audioPath = [[NSBundle mainBundle] URLForResource:@"Whoosh" withExtension:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(audioPath), &soundID);
    AudioServicesPlaySystemSound (soundID);
	// Do any additional setup after loading the view.

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
	UIImage* fartImage = [UIImage imageNamed:@"Fart.png"];
	if (IDIOM == IPAD) {
		
		self.fartLogo.frame = CGRectMake(self.fartLogo.center.x - (self.fartLogo.bounds.origin.x/2) - ((self.fartLogo.image.size.width/1.25)/2) ,self.fartLogo.center.y - (self.fartLogo.bounds.origin.y/2) -((self.fartLogo.image.size.height/1.25)/2),self.fartLogo.image.size.width/1.25, self.fartLogo.image.size.height/1.25);
		
	} else{
		self.fartLogo.frame = CGRectMake(self.fartLogo.center.x - (self.fartLogo.bounds.origin.x/2) - ((self.fartLogo.image.size.width/1.75)/2) ,self.fartLogo.center.y - (self.fartLogo.bounds.origin.y/2) -((self.fartLogo.image.size.height/1.75)/2),self.fartLogo.image.size.width/1.75, self.fartLogo.image.size.height/1.75);
	}
	

    [UIView commitAnimations];
   NSTimer *moveLogoTime = [NSTimer scheduledTimerWithTimeInterval:.7 target:self selector:@selector(moveInAnimation) userInfo:nil repeats:NO];

    
}
-(void)forFreeAnimation{
    
//    SystemSoundID soundID;
//    NSURL *audioPath = [[NSBundle mainBundle] URLForResource:@"OpeningFart" withExtension:@"mp3"];
//    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(audioPath), &soundID);
//    AudioServicesPlaySystemSound (soundID);
//	// Do any additional setup after loading the view.
//
//    
//    UIImage* freeImage = [UIImage imageNamed:@"ForFreedom.png"];
//    self.forFree = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, freeImage.size.width, freeImage.size.height)];
//    [self.forFree setImage:freeImage];
//    self.forFree.center = CGPointMake(self.view.center.x + 53, self.view.center.y + 40);
////    [self.view addSubview:self.forFree];
//	
//      NSTimer *moveLogoTime = [NSTimer scheduledTimerWithTimeInterval:.7 target:self selector:@selector(moveInAnimation) userInfo:nil repeats:NO];
    
}

-(void)moveInAnimation{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.7];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480){
        
        self.fartLogo.frame = CGRectMake(self.fartLogo.frame.origin.x, self.fartLogo.frame.origin.y - 138 ,self.fartLogo.frame.size.width, self.fartLogo.frame.size.height);
        self.forFree.frame = CGRectMake(self.forFree.frame.origin.x, self.forFree.frame.origin.y - 138 ,self.forFree.frame.size.width, self.forFree.frame.size.height);
        
    }
    else{
        self.fartLogo.frame = CGRectMake(self.fartLogo.frame.origin.x, self.fartLogo.frame.origin.y - 165,self.fartLogo.frame.size.width, self.fartLogo.frame.size.height);
        self.forFree.frame = CGRectMake(self.forFree.frame.origin.x, self.forFree.frame.origin.y - 165 ,self.forFree.frame.size.width, self.forFree.frame.size.height);
		
		if (IDIOM == IPAD) {
			self.fartLogo.frame = CGRectMake(self.fartLogo.frame.origin.x, self.fartLogo.frame.origin.y - 160,self.fartLogo.frame.size.width, self.fartLogo.frame.size.height);
			
		}
    }

    
    [UIView commitAnimations];
    NSTimer *buttonsTimer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showButtonsRow1) userInfo:nil repeats:NO];
  
  
    
}

-(void)showButtonsRow1{
	
	CGSize result = [[UIScreen mainScreen] bounds].size;
	BOOL isFour = NO;
	if(result.height == 480){
		isFour = YES;
	}

    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button1 setImage:[UIImage imageNamed:@"Slice 1.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button1 setImage:[UIImage imageNamed:@"Slice 1ipad.png"] forState:UIControlStateNormal];
	}
	self.button1.frame = CGRectMake(19, isFour ? 150 : 205, self.button1.imageView.image.size.width, self.button1.imageView.image.size.height);
    [self.button1 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button1.tag = 1;
    self.button1.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button1.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button1.frame.size.height + 60);
		self.button1.center = CGPointMake(self.button1.center.x, self.view.center.y - 150);
		self.button1.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button1];

	
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button2 setImage:[UIImage imageNamed:@"Slice 2.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button2 setImage:[UIImage imageNamed:@"Slice 2ipad.png"] forState:UIControlStateNormal];
	}
    self.button2.frame = CGRectMake(94, isFour ? 150 : 205, self.button2.imageView.image.size.width, self.button2.imageView.image.size.height);
    [self.button2 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button2.tag = 2;
    self.button2.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button2.frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/4, self.button2.frame.size.height + 60);
		self.button2.center = CGPointMake(self.button2.center.x, self.view.center.y - 150);
		self.button2.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button2];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button3 setImage:[UIImage imageNamed:@"Slice 3.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button3 setImage:[UIImage imageNamed:@"Slice 3ipad.png"] forState:UIControlStateNormal];
	}
	self.button3.frame = CGRectMake(169, isFour ? 150 : 205, self.button3.imageView.image.size.width, self.button3.imageView.image.size.height);
    [self.button3 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button3.tag = 3;
    self.button3.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button3.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button3.frame.size.height + 60);
		self.button3.center = CGPointMake(self.button3.center.x, self.view.center.y - 150);
		self.button3.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button3];
    
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button4 setImage:[UIImage imageNamed:@"Slice 4.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button4 setImage:[UIImage imageNamed:@"Slice 4ipad.png"] forState:UIControlStateNormal];
	}
	self.button4.frame = CGRectMake(244, isFour ? 150 : 205, self.button4.imageView.image.size.width, self.button4.imageView.image.size.height);
    [self.button4 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button4.tag = 4;
    self.button4.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button4.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button4.frame.size.height + 60);
		self.button4.center = CGPointMake(self.button4.center.x, self.view.center.y - 150);
		self.button4.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button4];

    NSTimer *buttonsTimer2 = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(showButtonsRow2) userInfo:nil repeats:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.7];
    self.button1.alpha = 1.0;
    self.button2.alpha = 1.0;
    self.button3.alpha = 1.0;
    self.button4.alpha = 1.0;

    [UIView commitAnimations];
    
}

-(void)showButtonsRow2{
	
	CGSize result = [[UIScreen mainScreen] bounds].size;
	BOOL isFour = NO;
	if(result.height == 480){
		isFour = YES;
	}

	
    self.button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button5 setImage:[UIImage imageNamed:@"Slice 5.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button5 setImage:[UIImage imageNamed:@"Slice 5ipad.png"] forState:UIControlStateNormal];
	}
	self.button5.frame = CGRectMake(19, isFour ? 205 : 265, self.button5.imageView.image.size.width, self.button5.imageView.image.size.height);
    [self.button5 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button5.tag = 5;
    self.button5.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button5.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button5.frame.size.height + 60);
		self.button5.center = CGPointMake(self.button5.center.x, self.view.center.y - 30);
		self.button5.imageView.contentMode = UIViewContentModeCenter;
	}
     [self.view addSubview:self.button5];
    
    self.button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button6 setImage:[UIImage imageNamed:@"Slice 6.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button6 setImage:[UIImage imageNamed:@"Slice 6ipad.png"] forState:UIControlStateNormal];
	}
	self.button6.frame = CGRectMake(94, isFour ? 205 : 265, self.button6.imageView.image.size.width, self.button6.imageView.image.size.height);
    [self.button6 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button6.tag = 6;
    self.button6.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button6.frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/4, self.button6.frame.size.height + 60);
		self.button6.center = CGPointMake(self.button6.center.x, self.view.center.y - 30);
		self.button6.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button6];
    
    self.button7 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button7 setImage:[UIImage imageNamed:@"Slice 7.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button7 setImage:[UIImage imageNamed:@"Slice 7ipad.png"] forState:UIControlStateNormal];
	}
	self.button7.frame = CGRectMake(169, isFour ? 205 : 265, self.button7.imageView.image.size.width, self.button7.imageView.image.size.height);
    [self.button7 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button7.tag = 7;
    self.button7.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button7.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button7.frame.size.height + 60);
		self.button7.center = CGPointMake(self.button7.center.x, self.view.center.y - 30);
		self.button7.imageView.contentMode = UIViewContentModeCenter;
	}
     [self.view addSubview:self.button7];
    
    self.button8 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button8 setImage:[UIImage imageNamed:@"Slice 8.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button8 setImage:[UIImage imageNamed:@"Slice 8ipad.png"] forState:UIControlStateNormal];
	}
	self.button8.frame = CGRectMake(244, isFour ? 205 : 265, self.button8.imageView.image.size.width, self.button8.imageView.image.size.height);
    [self.button8 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button8.tag = 8;
    self.button8.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button8.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button8.frame.size.height + 60);
		self.button8.center = CGPointMake(self.button8.center.x, self.view.center.y - 30);
		self.button8.imageView.contentMode = UIViewContentModeCenter;
	}
   [self.view addSubview:self.button8];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.7];
    self.button5.alpha = 1.0;
    self.button6.alpha = 1.0;
    self.button7.alpha = 1.0;
    self.button8.alpha = 1.0;
    
    [UIView commitAnimations];
    
      NSTimer *buttonsTimer3 = [NSTimer scheduledTimerWithTimeInterval:.18 target:self selector:@selector(showButtonsRow3) userInfo:nil repeats:NO];
}

-(void)showButtonsRow3{
    
	CGSize result = [[UIScreen mainScreen] bounds].size;
	BOOL isFour = NO;
	if(result.height == 480){
		isFour = YES;
	}

    
    
    self.button9 = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.button9 setImage:[UIImage imageNamed:@"Slice 9.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button9 setImage:[UIImage imageNamed:@"Slice 9ipad.png"] forState:UIControlStateNormal];
	}
	self.button9.frame = CGRectMake(19, isFour ? 260 : 325, self.button9.imageView.image.size.width, self.button9.imageView.image.size.height);
    [self.button9 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button9.tag = 9;
    self.button9.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button9.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button9.frame.size.height + 60);
		self.button9.center = CGPointMake(self.button9.center.x, self.view.center.y + 90);
		self.button9.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button9];
    
    self.button10 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button10 setImage:[UIImage imageNamed:@"Slice 10.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button10 setImage:[UIImage imageNamed:@"Slice 10ipad.png"] forState:UIControlStateNormal];
	}
    self.button10.frame = CGRectMake(94, isFour ? 260 : 325, self.button10.imageView.image.size.width, self.button10.imageView.image.size.height);
    [self.button10 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button10.tag = 10;
    self.button10.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button10.frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/4, self.button10.frame.size.height + 60);
		self.button10.center = CGPointMake(self.button10.center.x, self.view.center.y + 90);
		self.button10.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button10];
    
    self.button11 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button11 setImage:[UIImage imageNamed:@"Slice 11.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button11 setImage:[UIImage imageNamed:@"Slice 11ipad.png"] forState:UIControlStateNormal];
	}
    self.button11.frame = CGRectMake(169, isFour ? 260 : 325, self.button11.imageView.image.size.width, self.button11.imageView.image.size.height);
    [self.button11 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button11.tag = 11;
    self.button11.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button11.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button11.frame.size.height + 60);
		self.button11.center = CGPointMake(self.button11.center.x, self.view.center.y + 90);
		self.button11.imageView.contentMode = UIViewContentModeCenter;
	}
	[self.view addSubview:self.button11];
    
    self.button12 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button12 setImage:[UIImage imageNamed:@"Slice 12.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button12 setImage:[UIImage imageNamed:@"Slice 12ipad.png"] forState:UIControlStateNormal];
	}
    self.button12.frame = CGRectMake(244, isFour ? 260 : 325, self.button12.imageView.image.size.width, self.button12.imageView.image.size.height);
    [self.button12 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button12.tag = 12;
    self.button12.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button12.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button12.frame.size.height + 60);
		self.button12.center = CGPointMake(self.button12.center.x, self.view.center.y + 90);
		self.button12.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button12];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.7];
    self.button9.alpha = 1.0;
    self.button10.alpha = 1.0;
    self.button11.alpha = 1.0;
    self.button12.alpha = 1.0;
    
    [UIView commitAnimations];
    
    NSTimer *buttonsTimer4 = [NSTimer scheduledTimerWithTimeInterval:.16 target:self selector:@selector(showButtonsRow4) userInfo:nil repeats:NO];
    
}

-(void)showButtonsRow4{
	
	CGSize result = [[UIScreen mainScreen] bounds].size;
	BOOL isFour = NO;
	if(result.height == 480){
		isFour = YES;
	}

	
    self.button13 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button13 setImage:[UIImage imageNamed:@"Slice 13.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button13 setImage:[UIImage imageNamed:@"Slice 13ipad.png"] forState:UIControlStateNormal];
	}
    self.button13.frame = CGRectMake(19, isFour ? 315 : 385, self.button13.imageView.image.size.width, self.button13.imageView.image.size.height);
    [self.button13 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button13.tag = 13;
    self.button13.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button13.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button13.frame.size.height + 60);
		self.button13.center = CGPointMake(self.button13.center.x, self.view.center.y + 210);
		self.button13.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button13];
    
    self.button14 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button14 setImage:[UIImage imageNamed:@"Slice 14.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button14 setImage:[UIImage imageNamed:@"Slice 14ipad.png"] forState:UIControlStateNormal];
	}
    self.button14.frame = CGRectMake(94, isFour ? 315 : 385, self.button14.imageView.image.size.width, self.button14.imageView.image.size.height);
    [self.button14 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button14.tag = 14;
    self.button14.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button14.frame = CGRectMake((self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button14.frame.size.height + 60);
		self.button14.center = CGPointMake(self.button14.center.x, self.view.center.y + 210);
		self.button14.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button14];
    
    self.button15 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button15 setImage:[UIImage imageNamed:@"Slice 15.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button15 setImage:[UIImage imageNamed:@"Slice 15ipad.png"] forState:UIControlStateNormal];
	}
    self.button15.frame = CGRectMake(169, isFour ? 315 : 385, self.button15.imageView.image.size.width, self.button15.imageView.image.size.height);
    [self.button15 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button15.tag = 15;
    self.button15.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button15.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button15.frame.size.height + 60);
		self.button15.center = CGPointMake(self.button15.center.x, self.view.center.y + 210);
		self.button15.imageView.contentMode = UIViewContentModeCenter;
	}
   [self.view addSubview:self.button15];
    
    self.button16 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button16 setImage:[UIImage imageNamed:@"Slice 16.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button16 setImage:[UIImage imageNamed:@"Slice 16ipad.png"] forState:UIControlStateNormal];
	}
    self.button16.frame = CGRectMake(244, isFour ? 315 : 385, self.button16.imageView.image.size.width, self.button16.imageView.image.size.height);
    [self.button16 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button16.tag = 16;
    self.button16.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button16.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button16.frame.size.height + 60);
		self.button16.center = CGPointMake(self.button16.center.x, self.view.center.y + 210);
		self.button16.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button16];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.7];
    self.button13.alpha = 1.0;
    self.button14.alpha = 1.0;
    self.button15.alpha = 1.0;
    self.button16.alpha = 1.0;
    
    [UIView commitAnimations];
    
    if(result.height == 480){
    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.7];
        self.bannerView.alpha = 1.0;
        self.tabBarController.tabBar.alpha = 1.0;
        [UIView commitAnimations];

    }
  NSTimer *buttonsTimer5 = [NSTimer scheduledTimerWithTimeInterval:.14 target:self selector:@selector(showButtonsRow5) userInfo:nil repeats:NO];


}

-(void)showButtonsRow5{
	CGSize result = [[UIScreen mainScreen] bounds].size;
	BOOL isFour = NO;
	if(result.height == 480){
		isFour = YES;
	}
	
	
    
    self.button17 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button17 setImage:[UIImage imageNamed:@"Slice 17.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button17 setImage:[UIImage imageNamed:@"Slice 17ipad.png"] forState:UIControlStateNormal];
	}
    self.button17.frame = CGRectMake(19, isFour ? 370 : 445, self.button17.imageView.image.size.width, self.button17.imageView.image.size.height);
    [self.button17 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button17.tag = 17;
    self.button17.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button17.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.button17.frame.size.height + 60);
		self.button17.center = CGPointMake(self.button17.center.x, self.view.center.y + 330);
		self.button17.imageView.contentMode = UIViewContentModeCenter;
	}
     [self.view addSubview:self.button17];
    
    self.button18 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button18 setImage:[UIImage imageNamed:@"Slice 18.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button18 setImage:[UIImage imageNamed:@"Slice 18ipad.png"] forState:UIControlStateNormal];
	}
    self.button18.frame = CGRectMake(94, isFour ? 370 : 445, self.button18.imageView.image.size.width, self.button18.imageView.image.size.height);
    [self.button18 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button18.tag = 18;
    self.button18.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button18.frame = CGRectMake((self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button18.frame.size.height + 60);
		self.button18.center = CGPointMake(self.button18.center.x, self.view.center.y + 330);
		self.button18.imageView.contentMode = UIViewContentModeCenter;
	}
     [self.view addSubview:self.button18];
    
    self.button19 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button19 setImage:[UIImage imageNamed:@"Slice 19.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button19 setImage:[UIImage imageNamed:@"Slice 19ipad.png"] forState:UIControlStateNormal];
	}
    self.button19.frame = CGRectMake(169, isFour ? 370 : 445, self.button19.imageView.image.size.width, self.button19.imageView.image.size.height);
    [self.button19 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button19.tag = 19;
    self.button19.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button19.frame = CGRectMake(2*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button19.frame.size.height + 60);
		self.button19.center = CGPointMake(self.button19.center.x, self.view.center.y + 330);
		self.button19.imageView.contentMode = UIViewContentModeCenter;
	}
    [self.view addSubview:self.button19];
    
    self.button20 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button20 setImage:[UIImage imageNamed:@"Slice 20.png"] forState:UIControlStateNormal];
	if (IDIOM == IPAD) {
		[self.button20 setImage:[UIImage imageNamed:@"Slice 20ipad.png"] forState:UIControlStateNormal];
	}
    self.button20.frame = CGRectMake(244, isFour ? 370 : 445, self.button20.imageView.image.size.width, self.button20.imageView.image.size.height);
    [self.button20 addTarget:self action:@selector(playFart:) forControlEvents:UIControlEventTouchUpInside];
    self.button20.tag = 20;
    self.button20.alpha = 0.0;
	if (IDIOM == IPAD) {
		self.button20.frame = CGRectMake(3*(self.view.frame.size.width/4), 0, self.view.frame.size.width/4, self.button20.frame.size.height + 60);
		self.button20.center = CGPointMake(self.button20.center.x, self.view.center.y + 330);
		self.button20.imageView.contentMode = UIViewContentModeCenter;
	}
     [self.view addSubview:self.button20];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.7];
    self.button17.alpha = 1.0;
    self.button18.alpha = 1.0;
    self.button19.alpha = 1.0;
    self.button20.alpha = 1.0;
    self.bannerView.alpha = 1.0;
    self.tabBarController.tabBar.alpha = 1.0;
    [UIView commitAnimations];


    
}

-(void)playFart:(UIButton*)sender{
    UIButton *buttonClicked = (UIButton *)sender;
    NSURL *audioPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"Fart%ld", (long)buttonClicked.tag] withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioPath error:nil];
	[self.player play];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"Bannerfade" context:nil];
    [UIView setAnimationDuration:.7];
    bannerView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error {
    [UIView beginAnimations:@"Bannerfade" context:nil];
    [UIView setAnimationDuration:.7];
    bannerView.alpha = 0.0;
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
