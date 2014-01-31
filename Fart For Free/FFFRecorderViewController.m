//
//  FFFRecorderViewController.m
//  Fart For Free
//
//  Created by Gabe Jacobs on 1/31/14.
//  Copyright (c) 2014 Gabe Jacobs. All rights reserved.
//

#import "FFFRecorderViewController.h"
#import "IAPStoreManager.h"


@interface FFFRecorderViewController ()

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
    
    
    self.recordEncoding = 1;
    

    self.numberOfSaves = [[NSUserDefaults standardUserDefaults] integerForKey:@"numberofsaves"];
    if(self.numberOfSaves == 0){
        self.numberOfSaves = 1;
    }
    self.somethingRecorded = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
     self.savesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"saves"]];
    if(self.savesArray == nil) {
        self.savesArray = [[NSMutableArray alloc] init];
    }
    
    self.namesToFiles = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"dictionaryKey"] mutableCopy];
    if(self.namesToFiles == nil) {
        self.namesToFiles = [[NSMutableDictionary alloc] init];
    }


    self.background = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, [[UIScreen mainScreen] bounds].size.width+2, ([[UIScreen mainScreen] bounds].size.height+2))];
    [self.background setImage:[UIImage imageNamed:@"Background.png"]];
    [self.view addSubview:self.background];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-3677742875636291/8598865284";
    self.bannerView.rootViewController = self;
    [self.bannerView setDelegate:self];
    self.bannerView.alpha = 0.0;
    //[self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordButton setImage:[UIImage imageNamed:@"Record.png"] forState:UIControlStateNormal];
    self.recordButton.frame = CGRectMake(55, 80, self.recordButton.imageView.image.size.width, self.recordButton.imageView.image.size.height);
    [self.recordButton addTarget:self action:@selector(recordAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
    self.playButton.frame = CGRectMake((self.view.frame.size.width/2 - self.playButton.imageView.image.size.width/2), 80, self.playButton.imageView.image.size.width, self.playButton.imageView.image.size.height);
    [self.playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stopButton setImage:[UIImage imageNamed:@"StopRecording.png"] forState:UIControlStateNormal];
    self.stopButton.frame = CGRectMake(55, 80, self.stopButton.imageView.image.size.width, self.stopButton.imageView.image.size.height);
    [self.stopButton addTarget:self action:@selector(stopAudio:) forControlEvents:UIControlEventTouchUpInside];
    self.stopButton.hidden = YES;
    [self.view addSubview:self.stopButton];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setImage:[UIImage imageNamed:@"Save.png"] forState:UIControlStateNormal];
    self.saveButton.frame = CGRectMake(209, 80, self.saveButton.imageView.image.size.width, self.saveButton.imageView.image.size.height);
    [self.saveButton addTarget:self action:@selector(saveAudioAlert) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.enabled = NO;
    [self.view addSubview:self.saveButton];
    
    NSLog(@"%f",(self.view.frame.size.width/2 - self.playButton.imageView.image.size.width/2));
    
    
    self.fartsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, 320, 176)];
    self.fartsTable.dataSource = self;
    self.fartsTable.delegate = self;
    self.fartsTable.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:.5];
    [self.fartsTable setSeparatorInset:UIEdgeInsetsZero];

    [self.view addSubview:self.fartsTable];

    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                NSLog(@"User will not be able to use the microphone!");
            }
        }];
    }

    self.mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mailButton setImage:[UIImage imageNamed:@"Mail.png"] forState:UIControlStateNormal];
    self.mailButton.frame = CGRectMake(0, 0, self.mailButton.imageView.image.size.width, self.mailButton.imageView.image.size.height);
    self.mailButton.center = CGPointMake(self.view.center.x+40, 400);
    [self.mailButton addTarget:self action:@selector(composeMail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mailButton];
    
    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.messageButton setImage:[UIImage imageNamed:@"Message.png"] forState:UIControlStateNormal];
    self.messageButton.frame = CGRectMake(0, 0, self.messageButton.imageView.image.size.width, self.messageButton.imageView.image.size.height);
    self.messageButton.center = CGPointMake(self.view.center.x-40, 400);
    [self.messageButton addTarget:self action:@selector(composeMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.messageButton];
    

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

- (void)recordAudio:(id)sender {
    
    IAPProduct* product = [[IAPStoreManager sharedInstance] productForIdentifier:@"FartRecordingAbility"];
    [product purchase];
    
    if(self.purchased){
        
        self.somethingRecorded = YES;
        self.saveButton.enabled = NO;
        
        NSLog(@"startRecording");
        self.recordButton.hidden = YES;
        self.stopButton.hidden = NO;
        
        // Init audio with record capability
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
        if(self.recordEncoding == 6)
        {
            [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
            [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
            [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
            [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
            [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
            [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        }
        else
        {
            NSNumber *formatObject;
            
            switch (self.recordEncoding) {
                case (1):
                    formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                    break;
                case (2):
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                    break;
                case (3):
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                    break;
                case (4):
                    formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                    break;
                case (5):
                    formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                    break;
                default:
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
            }
            
            [recordSettings setObject:formatObject forKey: AVFormatIDKey];
            [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
            [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
            [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
            [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
            [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
        }
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/fart%d.caf", [[NSBundle mainBundle] resourcePath], self.numberOfSaves]];
        
        NSError *error = nil;
        self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        
        if ([self.audioRecorder prepareToRecord] == YES){
            [self.audioRecorder record];
        }else {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
        NSLog(@"recording");
        
    }
    else{
        //[self buyProduct];
    }
    
}

- (void)playAudio:(id)sender {
    
    if(self.somethingRecorded){
        NSLog(@"playRecording");
        // Init audio with playback capability
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSURL *url;
        if(self.somethingRecorded){
          url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/fart%d.caf", [[NSBundle mainBundle] resourcePath], self.numberOfSaves]];
        }
        else{
            url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/fart%d.caf", [[NSBundle mainBundle] resourcePath], self.numberOfSaves-1]];

        }
        NSLog(@"%@",url);

        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.numberOfLoops = 0;
        [self.audioPlayer play];
        NSLog(@"playing");
    }
}

- (void)stopAudio:(id)sender {
    self.saveButton.enabled = YES;
    NSLog(@"stopRecording");
    [self.audioRecorder stop];
    self.recordButton.hidden = NO;
    self.stopButton.hidden = YES;
    NSLog(@"stopped");
}

- (void)saveAudioAlert {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Name the fart" message:@"Enter the fart name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1;
    [alertView show];
}


- (void)saveAudio:(NSString*)name {
    

    [self.namesToFiles setValue:[NSString stringWithFormat:@"fart%d.caf", self.numberOfSaves] forKey:name];
    
    self.somethingRecorded = NO;
    [self.savesArray addObject:[NSString stringWithString:name]];
    [self.fartsTable reloadData];
    self.numberOfSaves++;
    self.saveButton.enabled = NO;
    
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: [self.savesArray count]-1 inSection: 0];
    [self.fartsTable scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.savesArray forKey:@"saves"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.numberOfSaves forKey:@"numberofsaves"];
    [[NSUserDefaults standardUserDefaults] setObject:self.namesToFiles forKey:@"dictionaryKey"];


}

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //self.recordButton.enabled = YES;
    //self.stopButton.enabled = NO;
}

-(void)audioRecorderDidFinishRecording:successfully{
    //self.saveButton.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.savesArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }
    
    NSString *fart = [self.savesArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:fart];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *fartName = cell.textLabel.text;
    NSString *fileName =  [self.namesToFiles valueForKey:cell.textLabel.text];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName]];
    self.currectSelectedFilePath = url;
    self.currectSelectedFartName = fartName;
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer play];
    
    NSLog(@"%@",url);

    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.savesArray removeObjectAtIndex:indexPath.row];
    NSLog(@"%ld",(long)indexPath.row);
    
    [self.fartsTable beginUpdates];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.fartsTable endUpdates];
    [self.fartsTable reloadData];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.savesArray forKey:@"saves"];



}

-(void)composeMessage{
    
    
    NSIndexPath *path = [self.fartsTable indexPathForSelectedRow];
    if (path){
        
        if ([MFMessageComposeViewController canSendText]) {
            
            MFMessageComposeViewController *composeViewController = [[MFMessageComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setMessageComposeDelegate:self];
            [composeViewController setBody:@"I just farted"];
            NSString *path = [self.currectSelectedFilePath path];
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
            [composeViewController addAttachmentData:data typeIdentifier:@"com.apple.coreaudio-​format" filename:[NSString stringWithFormat:@"%@.caf",self.currectSelectedFartName]];
            
            [self presentViewController:composeViewController animated:YES completion:nil];
            
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Looks like you can't send messages :(" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select a fart to share" message:@"Or save one if you haven't done that yet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }

    
}


-(void)composeMail{
    
    
    NSIndexPath *path = [self.fartsTable indexPathForSelectedRow];
    if (path){
        
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setMailComposeDelegate:self];
            [composeViewController setToRecipients:@[@""]];
            [composeViewController setSubject:@"I just farted"];
            [composeViewController setMessageBody:@"Recorded with <a href=\"https://itunes.apple.com/us/app/fart-for-free/id300897713?mt=8\">Fart For Free</a>" isHTML:YES];
            NSString *path = [self.currectSelectedFilePath path];
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
            [composeViewController addAttachmentData:data mimeType:@"audio/caf" fileName:[NSString stringWithFormat:@"%@.caf",self.currectSelectedFartName]];
            
            [self presentViewController:composeViewController animated:YES completion:nil];
            
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Looks like you can't send mail :(" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select a fart to share" message:@"Or save one if you haven't done that yet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }

    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    if(alertView.tag == 1){
        if (buttonIndex == 1) {
            UITextField *textfield =  [alertView textFieldAtIndex: 0];
            if([textfield.text  isEqual: @""]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Blank name" message:@"Please enter a name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                alertView.tag = 2;
                [alertView show];
                

            }
            else{
                [self saveAudio:textfield.text];
                
            }
        }
    }
    if(alertView.tag == 2){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Name the fart" message:@"Enter the fart name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 1;
        [alertView show];
    }
}

@end
