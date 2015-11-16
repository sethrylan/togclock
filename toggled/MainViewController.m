//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import "MainViewController.h"
#include "JPSVolumeButtonHandler.h"

@interface MainViewController ()
@property JPSVolumeButtonHandler *volumeButtonHandler;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
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

- (IBAction)vupButtonUp:(id)sender
{
    NSLog(@"VUP!");
    self.vupButton.selected = !self.vupButton.selected;
    
    [self.vupButton setTitle:@"start" forState:UIControlStateNormal];
    [self.vupButton setTitle:@"stop" forState:UIControlStateSelected];
}

- (IBAction)vdownButtonUp:(id)sender {
    NSLog(@"VDOWN!");
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

@end
