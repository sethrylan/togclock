//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "NSDate+ISO8601.h"
#import "LoginModalViewController.h"
#import "JNKeychain.h"
#import "NSDictionary+Additions.h"
#import "HistoryTableViewController.h"
#import "Utils.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    HistoryTableViewController *historyTableViewController = [[HistoryTableViewController alloc] init];
    historyTableViewController.view.frame = self.historyTable.bounds;
    [self.historyTable addSubview:historyTableViewController.view];
    [self addChildViewController:historyTableViewController];
    [historyTableViewController didMoveToParentViewController:self];
    
    self.buttonMaskView = [[ButtonMaskView alloc] initWithFrame:CGRectMake(10,0,500,312)];
    [self.buttonMaskView setVdownColor:[ButtonMaskView unselectedColor]];
    [self.buttonMaskView setVupColor:[ButtonMaskView unselectedColor]];
    [self.buttonMaskView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.buttonMaskView];
    self.buttonMaskView.layer.zPosition = -1;

    // set starting titles
    [self.vdownStatusLabel setText:@"hold to select"];
    [self.vupStatusLabel setText:@"hold to select"];
    
    NSDictionary *vdownBounds = [[ButtonMaskView bounds] valueForKey:@"vdown"];
    CGRect vdownProjectLabelFrame = CGRectMake(
                                               [vdownBounds doubleForKey:@"left"] + 20, // x
                                               [vdownBounds doubleForKey:@"top"] + 20, // y
                                               170,  // width
                                               20);  // height
    
    // create vdownProjectLabel
    self.vdownProjectLabel = [self makeLabel:@"" withBounds:vdownProjectLabelFrame];
    [self.view addSubview:self.vdownProjectLabel];
    
    
    // register tap and long press gestures for button mask
    UITapGestureRecognizer *buttonMaskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonMaskTap:)];
    [self.buttonMaskView addGestureRecognizer:buttonMaskTap];
    UILongPressGestureRecognizer *buttonMaskSelectButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonMaskSelect:)];
    [buttonMaskSelectButtonLongPress setMinimumPressDuration:0.25]; // triggers the action after 250ms of press
    [self.buttonMaskView addGestureRecognizer:buttonMaskSelectButtonLongPress];

    // register volume button presses
    self.volumeButtonHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
        // Volume Up Button Pressed
        [self vupButtonUp:self];
    } downBlock:^{
        // Volume Down Button Pressed
        [self vdownButtonUp:self];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // if API token doesn't exist, then log back in
    NSString *apiToken = [JNKeychain loadValueForKey:@"apiToken"];
    if (!apiToken) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginModalViewController *loginView = (LoginModalViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [self presentViewController:loginView animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel*)makeLabel:(NSString*)text withBounds:(CGRect)bounds
{
    UILabel *label = [[UILabel alloc]initWithFrame:bounds];
    //    UIFont * customFont = [UIFont fontWithName:ProximaNovaSemibold size:12]; //custom font
    //    NSString * text = [self fromSender];
    //    CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(380, 20) lineBreakMode:NSLineBreakByTruncatingTail];
    label.text = text;
    //    fromLabel.font = customFont;
    label.numberOfLines = 1;
    label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    label.adjustsFontSizeToFitWidth = YES;
    //    self.vdownProjectLabel.adjustsLetterSpacingToFitWidth = YES;
    label.minimumScaleFactor = 10.0f/12.0f;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingNone;
    return label;
}

- (void)buttonMaskTap:(UITapGestureRecognizer *)recognizer
{
    // See also using a delegate : http://stackoverflow.com/questions/16618109/how-to-get-uitouch-location-from-uigesturerecognizer
    CGPoint touchPoint = [recognizer locationInView: self.buttonMaskView];
    NSLog(@"x=%f, y=%f", touchPoint.x, touchPoint.y);

    if ([ButtonMaskView isPoint:touchPoint insidePath:self.buttonMaskView.vupPath])
    {
        [self vupButtonUp:recognizer];
    }
    if ([ButtonMaskView isPoint:touchPoint insidePath:self.buttonMaskView.vdownPath])
    {
        [self vdownButtonUp:recognizer];
    }
}

- (IBAction)vupButtonUp:(id)sender
{
    NSLog(@"VUP!");
    //    self.vupButton = [UIButton buttonWithType:UIButtonTypeCustom];

    if (self.vupEntry) {
        
        // if running then stop vupEntry
        if (self.vupEntry._active)
        {
            NSLog(@"stopping entry.");
            [self stopEntry:self.vupEntry];
            [self.buttonMaskView setVupColor:[ButtonMaskView inactiveColor]];
            [self.buttonMaskView setNeedsDisplay];
            
            [self.vupStatusLabel reset];
            [self.vupStatusLabel pause];
            [self.vupStatusLabel setText:@"start"];
            
        }
        // if not running then start vupEntry (implicitly creates)
        else
        {
            // if vup entry is running, stop it before starting vdown
            if (self.vdownEntry._active)
            {
                [self vdownButtonUp:sender];
            }

            NSLog(@"starting entry.");
            [self startEntry:self.vupEntry];
            [self.buttonMaskView setVupColor:[ButtonMaskView activeColor]];
            [self.buttonMaskView setNeedsDisplay];
            [self.vupStatusLabel start];
        }
    }
}

- (IBAction)vdownButtonUp:(id)sender
{
    NSLog(@"VDOWN!");
    
    if (self.vdownEntry) {
        
        // if running then stop vdownEntry
        if (self.vdownEntry._active)
        {
            NSLog(@"stopping entry.");
            [self stopEntry:self.vdownEntry];
            [self.buttonMaskView setVdownColor:[ButtonMaskView inactiveColor]];
            [self.buttonMaskView setNeedsDisplay];
            
            [self.vdownStatusLabel reset];
            [self.vdownStatusLabel pause];
            [self.vdownStatusLabel setText:@"start"];

        }
        // if not running then start vdownEntry (implicitly creates)
        else
        {
            // if vdown entry is running, stop it before starting vup
            if (self.vupEntry._active)
            {
                [self vupButtonUp:sender];
            }
            NSLog(@"starting entry.");
            [self startEntry:self.vdownEntry];
            [self.buttonMaskView setVdownColor:[ButtonMaskView activeColor]];
            [self.buttonMaskView setNeedsDisplay];
            [self.vdownStatusLabel start];

        }
    }
}

- (void)stopEntry:(Entry*)entry
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *authString = [NSString stringWithFormat:@"%@:api_token", [JNKeychain loadValueForKey:@"apiToken"]];
    NSString *url = [NSString stringWithFormat:@"https://www.toggl.com/api/v8/time_entries/%ld/stop", entry._id];
    NSMutableURLRequest *request = [Utils makeJSONRequest:url withAuth:authString withOperation:@"PUT"];
    
    NSURLSessionDataTask *postDataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   if(error == nil)
                   {
                       // NSLog(@"Data = %@",[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
                       // NSLog(@"response status code: %ld", (long)[(NSHTTPURLResponse *)response statusCode]);
                       if ((long)[(NSHTTPURLResponse *)response statusCode] == 403)
                       {
                           NSLog(@"unauthorized");
                           // TODO: relogin
                       }
                       else
                       {
                           NSLog(@"stop succeeded");
                           entry._active = false;
                           // TODO: update entry with response data
                       }
                   }
               }];
    [postDataTask resume];

}

- (void)startEntry:(Entry*)entry
{
    NSMutableDictionary *timeEntry = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithLong:entry._pid], @"pid",
                                      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"], @"created_with",
                                      [[NSDate date] asISO8601String], @"start",
                                      nil];
    // create time_entry data. Cannot use a NSDictionary literal because "[n]either keys nor values can have the value nil in containers". See http://clang.llvm.org/docs/ObjectiveCLiterals.html
    if (entry._description)
    {
        [timeEntry setObject:entry._description forKey:@"description"];
    }
    
    NSDictionary *jsonValues = @{
                                 @"time_entry" : timeEntry
                                 };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonValues
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    //            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *authString = [NSString stringWithFormat:@"%@:api_token", [JNKeychain loadValueForKey:@"apiToken"]];
    NSMutableURLRequest *request = [Utils makeJSONRequest:@"https://www.toggl.com/api/v8/time_entries/start" withAuth:authString withOperation:@"POST"];
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *postDataTask =
        [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   if(error == nil)
                   {
                       // NSLog(@"Data = %@",[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
                       // NSLog(@"response status code: %ld", (long)[(NSHTTPURLResponse *)response statusCode]);
                       if ((long)[(NSHTTPURLResponse *)response statusCode] == 403)
                       {
                           NSLog(@"unauthorized");
                           // TODO: relogin
                       }
                       else
                       {
                           NSLog(@"start succeeded");
                           NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingMutableContainers
                                                                                          error:nil];
                           long id = [[responseJson[@"data"] objectForKey:@"id"] longValue];
                           entry._id = id;
                           entry._active = true;
                           // TODO: update entry with response data
                       }
                   }
               }];
    [postDataTask resume];
}

- (void)buttonMaskSelect:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [recognizer locationInView: self.buttonMaskView];
        NSLog(@"held at x=%f, y=%f", touchPoint.x, touchPoint.y);
        if ([ButtonMaskView isPoint:touchPoint insidePath:self.buttonMaskView.vupPath])
        {
            [self vupSelect:recognizer];
        }
        if ([ButtonMaskView isPoint:touchPoint insidePath:self.buttonMaskView.vdownPath])
        {
            [self vdownSelect:recognizer];
        }
    }
}

- (void)vupSelect:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"held");
        
        // stop entry if running
        if (self.vupEntry._active)
        {
            [self vupButtonUp:recognizer];
        }
        
        SelectTableViewController *selectTableViewController = [[SelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        selectTableViewController.delegate = self;
        selectTableViewController.callback = ^(NSDictionary *returnValue) {
            self.vupEntry = [returnValue objectForKey:@"entry"];
        };
        
        selectTableViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        selectTableViewController.navigationController.navigationBarHidden = NO;
        [self presentPopupViewController:selectTableViewController animationType:MJPopupViewAnimationFade];
    }
}

- (void)vdownSelect:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"held");
        
        // stop entry if running
        if (self.vdownEntry._active)
        {
            [self vdownButtonUp:recognizer];
        }
        
        SelectTableViewController *selectTableViewController = [[SelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        selectTableViewController.delegate = self;
        selectTableViewController.callback = ^(NSDictionary *returnValue) {
            self.vdownEntry = [returnValue objectForKey:@"entry"];
        };
        selectTableViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        selectTableViewController.navigationController.navigationBarHidden = NO;
        [self presentPopupViewController:selectTableViewController animationType:MJPopupViewAnimationFade];
    }
}

// Also set in the plist files, which usually override the VC methods
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

// Force landscape-leaf orientation
+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        [presentingController setProvidesPresentationContextTransitionStyle:YES];
        [presentingController setDefinesPresentationContext:YES];
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}

- (void)tableDismissed:(SelectTableViewController *)selectTableViewController withEntry:(NSDictionary *)entry
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    NSLog(@"passedentry = %@", entry);
    NSLog(@"self.vupEntry = %@", self.vupEntry);
    NSLog(@"self.vdownEntry = %@", self.vdownEntry);
    
    // update vdown/vup labels
    if (self.vdownEntry)
    {
        [self.vdownProjectLabel setText:[self.vdownEntry _projectName]];
        [self.vdownDescriptionLabel setText:[self.vdownEntry _description]];
        [self.vdownStatusLabel setText:@"start"];
    }

    if (self.vupEntry)
    {
        [self.vupProjectLabel setText:[self.vupEntry _projectName]];
        [self.vupDescriptionLabel setText:[self.vupEntry _description]];
        [self.vupStatusLabel setText:@"start"];
    }
}

@end
