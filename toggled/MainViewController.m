//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "LoginModalViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self.vupButton setTitle:@"hold to select" forState:UIControlStateNormal];
    [self.vdownButton setTitle:@"hold to select" forState:UIControlStateNormal];

    // Register long press gesture
    UILongPressGestureRecognizer *vupSelectButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(vupSelect:)];
    [vupSelectButtonLongPress setMinimumPressDuration:0.25]; // triggers the action after 2250ms of press
    [self.vupSelectButton addGestureRecognizer:vupSelectButtonLongPress];
    [self.vupSelectButton addTarget:self action:@selector(vupSelectButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];

    UILongPressGestureRecognizer *vdownSelectButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(vdownSelect:)];
    [vdownSelectButtonLongPress setMinimumPressDuration:0.25]; // triggers the action after 250ms of press
    [self.vdownSelectButton addGestureRecognizer:vdownSelectButtonLongPress];
    [self.vdownSelectButton addTarget:self action:@selector(vdownSelectButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
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
    // if we haven't checked authentication
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"hasCheckedLoginForLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"hasCheckedLoginForLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // if no authentication info available, then force login
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
    }
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
