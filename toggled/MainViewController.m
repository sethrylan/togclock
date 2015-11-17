//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import "MainViewController.h"
#import "SelectTableViewController.h"
#import "UIViewController+MJPopupViewController.h"
#include "JPSVolumeButtonHandler.h"

@interface MainViewController ()
@property JPSVolumeButtonHandler *volumeButtonHandler;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self.vupButton setTitle:@"hold to select" forState:UIControlStateNormal];
    [self.vdownButton setTitle:@"hold to select" forState:UIControlStateNormal];
    

    // Register long press gesture
    UILongPressGestureRecognizer *vupSelectButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(vupSelect:)];
    [vupSelectButtonLongPress setMinimumPressDuration:0.25]; // triggers the action after 2 seconds of press
    [self.vupSelectButton addGestureRecognizer:vupSelectButtonLongPress];
    [self.vupSelectButton addTarget:self action:@selector(vupSelectButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];

    UILongPressGestureRecognizer *vdownSelectButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(vdownSelect:)];
    [vdownSelectButtonLongPress setMinimumPressDuration:0.25]; // triggers the action after 2 seconds of press
    [self.vdownSelectButton addGestureRecognizer:vdownSelectButtonLongPress];
    [self.vdownSelectButton addTarget:self action:@selector(vdownSelectButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    self.volumeButtonHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
        // Volume Up Button Pressed
        [self vupButtonUp:self];
    } downBlock:^{
        // Volume Down Button Pressed
        [self vdownButtonUp:self];
        /*
        UIAlertController* alert= [UIAlertController
                                   alertControllerWithTitle:@"Info"
                                   message:@"Volume Down Pressed"
                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
         */
    }];

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

    self.vupButton.selected = !self.vupButton.selected;
    [self.vupButton setTitle:@"start" forState:UIControlStateNormal];
    [self.vupButton setTitle:@"stop" forState:UIControlStateSelected];

    if (self.vupButton.selected) {
        [self.vupButton setBackgroundColor:[UIColor redColor]];
    } else {
        [self.vupButton setBackgroundColor:[UIColor greenColor]];
    }
}

- (IBAction)vdownButtonUp:(id)sender {
    NSLog(@"VDOWN!");
    self.vdownButton.selected = !self.vdownButton.selected;
    [self.vdownButton setTitle:@"start" forState:UIControlStateNormal];
    [self.vdownButton setTitle:@"stop" forState:UIControlStateSelected];
    
    if (self.vdownButton.selected) {
        [self.vdownButton setBackgroundColor:[UIColor redColor]];
    } else {
        [self.vdownButton setBackgroundColor:[UIColor greenColor]];
    }
}

- (void)vupSelect:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"held");
        
        SelectTableViewController *selectTableViewController = [[SelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        selectTableViewController.delegate = self;
        selectTableViewController.callback = ^(NSDictionary *entry) {
            self.vupEntry = entry;
        };
        
        selectTableViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        selectTableViewController.navigationController.navigationBarHidden = NO;
        [self presentPopupViewController:selectTableViewController animationType:MJPopupViewAnimationFade];
    }
}

- (void)vdownSelect:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"held");
        
        SelectTableViewController *selectTableViewController = [[SelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        selectTableViewController.delegate = self;
        selectTableViewController.callback = ^(NSDictionary *entry) {
            self.vdownEntry = entry;
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
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
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

}


@end
