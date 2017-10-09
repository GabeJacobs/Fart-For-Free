//
//  FFFRecorderViewController.m
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/31/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import "FFFRecorderViewController.h"


@interface FFFRecorderViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) GADBannerView *bannerView;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *stopButton;
@property (nonatomic,strong) UIButton *recordButton;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *mailButton;
@property (nonatomic,strong) UIButton *messageButton;

@property (nonatomic) int recordEncoding;
@property (nonatomic) int numberOfSaves;
@property (nonatomic) BOOL somethingRecorded;
@property (nonatomic) BOOL purchased;

@property (strong, nonatomic) NSMutableArray *savesArray;
@property (strong, nonatomic) UITableView *fartsTable;
@property (strong, nonatomic) NSMutableDictionary *namesToFiles;
@property (strong, nonatomic) NSURL *currectSelectedFilePath;
@property (strong, nonatomic) NSString *currectSelectedFartName;
@property (strong, nonatomic) UIPickerView *picker;



@end

@implementation FFFRecorderViewController

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
    
    
	
	self.background = [[UIImageView alloc] initWithFrame:self.view.frame];
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
	
	self.picker = [UIPickerView new];
	self.picker.frame = CGRectMake(0, self.bannerView.frame.size.height, self.view.frame.size.width, self.picker.frame.size.height + 60);
	self.picker.delegate = self;
	self.picker.dataSource = self;
	self.picker.showsSelectionIndicator = YES;
	[self.picker selectRow:4 inComponent:0 animated:NO];
	if (IDIOM == IPAD) {
		self.picker.frame = CGRectMake(0, 200, self.view.frame.size.width, self.picker.frame.size.height + 60);

	}
	[self.view addSubview:self.picker];

	self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.messageButton setImage:[UIImage imageNamed:@"SendMessage"] forState:UIControlStateNormal];
	self.messageButton.frame = CGRectMake(30, self.picker.frame.size.height + self.picker.frame.origin.y + 10, self.view.frame.size.width - 60, 110);
	CGSize screen = [[UIScreen mainScreen] bounds].size;
	if(screen.height <=480) {
		self.messageButton.frame = CGRectMake(30, self.picker.frame.size.height + self.picker.frame.origin.y - 20, self.view.frame.size.width - 60, 110);
	}
	[self.messageButton addTarget:self action:@selector(composeMessage) forControlEvents:UIControlEventTouchUpInside];
	if (IDIOM == IPAD) {
		self.messageButton.frame = CGRectMake(30, self.picker.frame.size.height + self.picker.frame.origin.y +20, self.view.frame.size.width - 60, 300);

	}
	[self.view addSubview:self.messageButton];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString * title = nil;
	switch(row) {
		case 0:
			title = @"Fart 1: Lima Beans";
			break;
		case 1:
			title = @"Fart 2: The Library";
			break;
		case 2:
			title = @"Fart 3: Belly Flop";
			break;
		case 3:
			title = @"Fart 4: The Not So Silent";
			break;
		case 4:
			title = @"Fart 5: Echo Chamber";
			break;
		case 5:
			title = @"Fart 6: Execution";
			break;
		case 6:
			title = @"Fart 7: Taco Taco";
			break;
		case 7:
			title = @"Fart 8: 1st Down";
			break;
		case 8:
			title = @"Fart 9: The Exhale";
			break;
		case 9:
			title = @"Fart 10: Raindrops";
			break;
		case 10:
			title = @"Fart 11: 1st Grade";
			break;
		case 11:
			title = @"Fart 12: Retro";
			break;
		case 12:
			title = @"Fart 13: Just Made It";
			break;
		case 13:
			title = @"Fart 14: Passive Aggressive";
			break;
		case 14:
			title = @"Fart 15: Jab, Jab, Uppercut";
			break;
		case 15:
			title = @"Fart 16: Lasagna";
			break;
		case 16:
			title = @"Fart 17: Grandpa";
			break;
		case 17:
			title = @"Fart 18: Whiskers";
			break;
		case 18:
			title = @"Fart 19: The Call";
			break;
		case 19:
			title = @"Fart 20: Hello, World";
			break;
	}
	return title;
}

-(void)composeMessage{
    
	
        if ([MFMessageComposeViewController canSendText]) {
            
            MFMessageComposeViewController *composeViewController = [[MFMessageComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setMessageComposeDelegate:self];
			[composeViewController setBody:@"I just farted. Fart back: https://itunes.apple.com/us/app/fart-for-free/id300897713?mt=8"];
			NSURL *path = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"Fart%d", self.selectedRow + 1] withExtension:@"mp3"];
			NSData *data = [NSData dataWithContentsOfURL:path];
			
			NSString *title;
			
			switch(self.selectedRow) {
				case 0:
					title = @"Lima Beans";
					break;
				case 1:
					title = @"The Library";
					break;
				case 2:
					title = @"Belly Flop";
					break;
				case 3:
					title = @"The Not So Silent";
					break;
				case 4:
					title = @"Echo Chamber";
					break;
				case 5:
					title = @"Execution";
					break;
				case 6:
					title = @"Taco Taco";
					break;
				case 7:
					title = @"1st Down";
					break;
				case 8:
					title = @"The Exhale";
					break;
				case 9:
					title = @"Raindrops";
					break;
				case 10:
					title = @"1st Grade";
					break;
				case 11:
					title = @"Retro";
					break;
				case 12:
					title = @"Just Made It";
					break;
				case 13:
					title = @"Passive Aggressive";
					break;
				case 14:
					title = @"Jab, Jab, Uppercut";
					break;
				case 15:
					title = @"Lasagna";
					break;
				case 16:
					title = @"Grandpa";
					break;
				case 17:
					title = @"Whiskers";
					break;
				case 18:
					title = @"The Call";
					break;
				case 19:
					title = @"Hello, World";
					break;
			}
			[composeViewController addAttachmentData:data typeIdentifier:@"audio/mp3" filename:[NSString stringWithFormat:@"%@.mp3",title]];

            [self presentViewController:composeViewController animated:YES completion:nil];
            
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Looks like you can't send messages :(" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.selectedRow = row;
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


@end
