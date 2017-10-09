//
//  FFFTimerViewController.m
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/30/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import "FFFTimerViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface FFFTimerViewController ()

@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) GADBannerView *bannerView;
@property (nonatomic,strong) UIButton *upArrowButton;
@property (nonatomic,strong) UIButton *downArrowButton;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIImageView *ticker;
@property (nonatomic,strong) UIButton *start;
@property (nonatomic,strong) UIButton *stop;

@property (nonatomic,strong) UILabel *intensityLabel;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic) int seconds;
@property (nonatomic) int intensity;


@end

@implementation FFFTimerViewController

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
    [super viewDidLoad];

	self.player = [[AVAudioPlayer alloc] init];

	
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    self.seconds = 10;
    self.intensity = 3;
    
    self.background = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, [[UIScreen mainScreen] bounds].size.width+2, ([[UIScreen mainScreen] bounds].size.height+2))];
    [self.background setImage:[UIImage imageNamed:@"Background.png"]];
    [self.view addSubview:self.background];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-3677742875636291/8598865284";
    self.bannerView.rootViewController = self;
    [self.bannerView setDelegate:self];
    self.bannerView.alpha = 0.0;
	self.bannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bannerView.frame.size.height);
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
	
    
    /*
    self.intensity = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Intensity.png"]];
    self.intensity.frame = CGRectMake(0, 0, self.intensity.image.size.width, self.intensity.image.size.height);
    self.intensity.center = CGPointMake(self.view.center.x, self.view.center.y-50);
    [self.view addSubview:self.intensity];
     */

    
    self.start = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.start setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
    self.start.frame = CGRectMake(0, 0, self.start.imageView.image.size.width, self.start.imageView.image.size.height);
    self.start.center = CGPointMake(self.view.center.x + 10, 354);
    [self.start addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
	if (IDIOM == IPAD) {
		[self.start setImage:[UIImage imageNamed:@"Startipad.png"] forState:UIControlStateNormal];
		self.start.frame = CGRectMake(0, 0, self.start.imageView.image.size.width, self.start.imageView.image.size.height);
		self.start.center = CGPointMake(self.view.center.x + 10, self.view.center.y + 230);
	}
    [self.view addSubview:self.start];
    
    self.stop = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stop setImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
    self.stop.frame = CGRectMake(0, 0, self.start.imageView.image.size.width, self.start.imageView.image.size.height);
    self.stop.center = CGPointMake(self.view.center.x+3, 356);
    [self.stop addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
	if (IDIOM == IPAD) {
		[self.stop setImage:[UIImage imageNamed:@"Stopipad"] forState:UIControlStateNormal];
		self.stop.frame = CGRectMake(0, 0, self.stop.imageView.image.size.width, self.stop.imageView.image.size.height);
		self.stop.center = CGPointMake(self.view.center.x + 10, self.view.center.y + 230);
	}
    self.stop.hidden = YES;
    [self.view addSubview:self.stop];
    
    self.intensityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 175, 40)];
    self.intensityLabel.text = [NSString stringWithFormat:@"Intensity: %d", self.intensity];
    self.intensityLabel.center = CGPointMake(self.view.center.x, 262);
    self.intensityLabel.backgroundColor = [UIColor clearColor];
    self.intensityLabel.textColor = [UIColor whiteColor];
    self.intensityLabel.font = [UIFont fontWithName:@"Helvetica" size:35.0f];
	if (IDIOM == IPAD) {
		self.intensityLabel.font = [UIFont fontWithName:@"Helvetica" size:70.0f];
		[self.intensityLabel sizeToFit];
		self.intensityLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
		
	}
    [self.view addSubview:self.intensityLabel];
	
	self.slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 205, 280, 20)];
	self.slider.minimumValue = 1;
	self.slider.maximumValue = 5;
	[self.slider setMaximumValueImage:[UIImage imageNamed:@"FireIcon.png"]];
	[self.slider setMinimumValueImage:[UIImage imageNamed:@"SmallCloud"]];
	[self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.slider setValue:3.0];
	[self.slider setMinimumTrackTintColor:[UIColor whiteColor]];
	[self.slider setMaximumTrackTintColor:[UIColor whiteColor]];
	if (IDIOM == IPAD) {
		self.slider.frame = CGRectMake(20, self.intensityLabel.frame.origin.y - 90, self.view.frame.size.width - 40, 20);
		
	}
	[self.view addSubview:self.slider];
	

	
	self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 200, 130)];
	self.timeLabel.backgroundColor = [UIColor clearColor];
	self.timeLabel.text = [NSString stringWithFormat:@"%d s", self.seconds];
	self.timeLabel.textAlignment = NSTextAlignmentCenter;
	self.timeLabel.font = [UIFont fontWithName:@"Helvetica" size:90.0f];
	self.timeLabel.textColor = [UIColor whiteColor];
	if (IDIOM == IPAD) {
		self.timeLabel.font = [UIFont fontWithName:@"Helvetica" size:120.0f];
		self.timeLabel.frame = CGRectMake(0, self.slider.frame.origin.y - 210, 300, 300);
		[self.timeLabel sizeToFit];
		self.timeLabel.center = CGPointMake(self.view.center.x - 60, self.timeLabel.center.y);
		
	}
	[self.view addSubview:self.timeLabel];
	
	self.upArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.upArrowButton setImage:[UIImage imageNamed:@"UpArrow.png"] forState:UIControlStateNormal];
	self.upArrowButton.frame = CGRectMake(245, 70, self.upArrowButton.imageView.image.size.width, self.upArrowButton.imageView.image.size.height);
	[self.upArrowButton addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
	if (IDIOM == IPAD) {
		self.upArrowButton.frame = CGRectMake(self.timeLabel.frame.origin.x + self.timeLabel.frame.size.width + 50, self.timeLabel.frame.origin.y, self.upArrowButton.imageView.image.size.width, self.upArrowButton.imageView.image.size.height);
		
	}
	[self.view addSubview:self.upArrowButton];
	
	self.downArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.downArrowButton setImage:[UIImage imageNamed:@"DownArrow.png"] forState:UIControlStateNormal];
	self.downArrowButton.frame = CGRectMake(245, 145, self.downArrowButton.imageView.image.size.width, self.downArrowButton.imageView.image.size.height);
	[self.downArrowButton addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchUpInside];
	if (IDIOM == IPAD) {
		self.downArrowButton.frame = CGRectMake(self.timeLabel.frame.origin.x + self.timeLabel.frame.size.width + 50, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height - 30, self.downArrowButton.imageView.image.size.width, self.downArrowButton.imageView.image.size.height);
		
	}
	[self.view addSubview:self.downArrowButton];
    
    /*
    self.dontSleep = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 40)];
    self.dontSleep.text = [NSString stringWithFormat:@"Don't lock iPhone!"];
    self.dontSleep.center = CGPointMake(self.view.center.x+1, 420);
    self.dontSleep.backgroundColor = [UIColor clearColor];
    self.dontSleep.textColor = [UIColor lightTextColor];
    self.dontSleep.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    [self.view addSubview:self.dontSleep];
    */
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSString *alreadyRun = @"already-run";
//    if (![prefs boolForKey:alreadyRun]){
//
//        [prefs setBool:YES forKey:alreadyRun];
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Don't lock!"
//                              message:@"Don't lock your iPhone after you hit start. Simply rest your phone face down behind someone, or under a pillow."
//                              delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//    }
//    

}

-(void)startTimer{
    
    if(self.seconds != 0){

		self.backgroundTaskIdentifier =
		[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
			
			[[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
		}];
		
        self.start.hidden = YES;
        self.stop.hidden = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
        
    }
    


}
-(void)stopTimer{
    
    self.start.hidden = NO;
    self.stop.hidden = YES;
    
    [self.timer invalidate];

}

-(void)updateCounter{
    if(self.seconds > 1){
        self.seconds--;
        self.timeLabel.text = [NSString stringWithFormat:@"%d s", self.seconds];
    }
    else if(self.seconds == 1){
        self.seconds--;
        self.timeLabel.text = [NSString stringWithFormat:@"%d s", self.seconds];
		
//		NSURL *audioPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"Fart%ld", (long)buttonClicked.tag] withExtension:@"mp3"];
		
        NSURL *audioPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"Intensity%d", self.intensity] withExtension:@"mp3"];
//        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(audioPath), &soundId);
//        AudioServicesPlaySystemSound (soundId);

		
		self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioPath error:nil];
		[self.player play];
        [self stopTimer];
    }
   

}


-(void)touchUp{
    if(self.seconds < 60){
        self.seconds++;
        self.timeLabel.text = [NSString stringWithFormat:@"%d s", self.seconds];
    }
}

-(void)touchDown{
    if(self.seconds > 1){
        self.seconds--;
        self.timeLabel.text = [NSString stringWithFormat:@"%d s", self.seconds];
    }
}

- (void)sliderValueChanged:(UISlider *)sender {
    
    if(sender.value >= 1.0 && sender.value < 1.5){
        self.intensity = 1;
    }
    else if(sender.value >= 1.5 && sender.value < 2.5){
        self.intensity = 2;
    }
    else if(sender.value >= 2.5 && sender.value < 3.5){
        self.intensity = 3;
    }
    else if(sender.value >= 3.5 && sender.value < 4.5){
        self.intensity = 4;
    }
    else if(sender.value >= 4.5 && sender.value < 5.0){
        self.intensity = 5;
    }
    self.intensityLabel.text = [NSString stringWithFormat:@"Intensity: %d", self.intensity];


}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"Bannerfade" context:nil];
    bannerView.alpha = 1.0;
    [UIView setAnimationDuration:.7];
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
