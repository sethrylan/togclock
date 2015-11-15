//
//  org_lenitionFirstViewController.m
//  toggled
//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import "FirstViewController.h"
#include "JPSVolumeButtonHandler.h"

@interface org_lenitionFirstViewController ()
@property JPSVolumeButtonHandler *volumeButtonHandler;
@end

@implementation org_lenitionFirstViewController


//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
////    return Int(UIInterfaceOrientationMask.Landscape.rawValue)
//    return UIInterfaceOrientationPortrait;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    self.volumeButtonHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
        // Volume Up Button Pressed
        UIAlertController* alert= [UIAlertController
                                        alertControllerWithTitle:@"Info"
                                        message:@"Volume Up Pressed"
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
        
    } downBlock:^{
        // Volume Down Button Pressed
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
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleButtonUp:(id)sender
{
    NSLog(@"Toggled!");
    self.toggleButton.selected = !self.toggleButton.selected;
    
    [self.toggleButton setTitle:@"start" forState:UIControlStateNormal];
    [self.toggleButton setTitle:@"stop" forState:UIControlStateSelected];
}

- (IBAction)switchButtonUp:(id)sender {
    NSLog(@"Switched!");
}

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
