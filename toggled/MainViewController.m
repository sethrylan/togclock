//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "LoginModalViewController.h"
#import "JNKeychain.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    // set starting titles
    [self.vupButton setTitle:@"hold to select" forState:UIControlStateNormal];
    [self.vdownButton setTitle:@"hold to select" forState:UIControlStateNormal];

    // register long press gestures
    UILongPressGestureRecognizer *vupSelectButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(vupSelect:)];
    [vupSelectButtonLongPress setMinimumPressDuration:0.25]; // triggers the action after 2250ms of press
    [self.vupSelectButton addGestureRecognizer:vupSelectButtonLongPress];
    [self.vupSelectButton addTarget:self action:@selector(vupSelectButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];

    UILongPressGestureRecognizer *vdownSelectButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(vdownSelect:)];
    [vdownSelectButtonLongPress setMinimumPressDuration:0.25]; // triggers the action after 250ms of press
    [self.vdownSelectButton addGestureRecognizer:vdownSelectButtonLongPress];
    [self.vdownSelectButton addTarget:self action:@selector(vdownSelectButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (IBAction)vdownButtonDown:(id)sender {
}

- (IBAction)vupButtonDown:(id)sender {
}

- (IBAction)vupButtonUp:(id)sender
{
    NSLog(@"VUP!");
    //    self.vupButton = [UIButton buttonWithType:UIButtonTypeCustom];

    if (self.vupEntry) {
        self.vupButton.selected = !self.vupButton.selected;
        [self.vupButton setTitle:@"start" forState:UIControlStateNormal];
        [self.vupButton setTitle:@"stop" forState:UIControlStateSelected];
        
        if (self.vupButton.selected) {
            [self.vupButton setBackgroundColor:[UIColor redColor]];
        } else {
            [self.vupButton setBackgroundColor:[UIColor greenColor]];
        }
        
        // if UIControlStateSelected then create and start vupEntry
        // if UIControlStateNormal, then stop vupEntry
    }
}

- (IBAction)vdownButtonUp:(id)sender
{
    NSLog(@"VDOWN!");
    
    if (self.vdownEntry) {
        self.vdownButton.selected = !self.vdownButton.selected;
        [self.vdownButton setTitle:@"start" forState:UIControlStateNormal];
        [self.vdownButton setTitle:@"stop" forState:UIControlStateSelected];
        
        if (self.vdownButton.selected) {
            [self.vdownButton setBackgroundColor:[UIColor redColor]];
        } else {
            [self.vdownButton setBackgroundColor:[UIColor greenColor]];
        }
        
        // if UIControlStateSelected then start vdownEntry (implicitly creates)
        if (self.vdownButton.isSelected)
        {
            NSLog(@"starting entry.");
            [self startEntry:self.vdownEntry];
        }
        // if UIControlStateNormal then stop vdownEntry
        else
        {
            NSLog(@"stopping entry.");
            [self stopEntry:self.vdownEntry];
        }
    }
}

- (void)stopEntry:(Entry*)entry
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *authString = [NSString stringWithFormat:@"%@:api_token", [JNKeychain loadValueForKey:@"apiToken"]];
    NSString *url = [NSString stringWithFormat:@"https://www.toggl.com/api/v8/time_entries/%ld/stop", entry._id];
    NSMutableURLRequest *request = [self makeJSONRequest:url withAuth:authString withOperation:@"PUT"];
    
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
    NSMutableURLRequest *request = [self makeJSONRequest:@"https://www.toggl.com/api/v8/time_entries/start" withAuth:authString withOperation:@"POST"];
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
                       }
                   }
               }];
    [postDataTask resume];
}

- (NSMutableURLRequest*)makeJSONRequest:(NSString *)urlString withAuth:(NSString *)authString withOperation:(NSString *)op
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
                  
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];

    NSDictionary *headers = @{
                              @"Content-Type":@"application/json",
                              @"Accept":@"application/json"
                              };
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setAllHTTPHeaderFields:headers];
    
    [request setHTTPMethod:op];
    return request;
}

- (void)vupSelect:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"held");
        
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

- (IBAction)vupSelectButtonTouchUp:(id)sender {
    NSLog(@"SELECT!");
}

- (IBAction)vdownSelectButtonTouchUp:(id)sender {
    NSLog(@"SELECT!");
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
    
    // update vup/vdown buttons
    [self.vupProjectLabel setText:[self.vupEntry _projectName]];
    [self.vupDescriptionLabel setText:[self.vupEntry _description]];
    [self.vdownButton setTitle:@"start" forState:UIControlStateNormal];
    
    [self.vdownProjectLabel setText:[self.vdownEntry _projectName]];
    [self.vdownDescriptionLabel setText:[self.vdownEntry _description]];
    [self.vdownButton setTitle:@"start" forState:UIControlStateNormal];
}

@end
