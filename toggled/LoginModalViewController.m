//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//
//  See http://stackoverflow.com/questions/16230700/display-uiviewcontroller-as-popup-in-iphone for development hints
//

#import "LoginModalViewController.h"

@interface LoginModalViewController ()

@end

@implementation LoginModalViewController

@synthesize passwordField, emailField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Add actions to "Return" key
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField==emailField)
    {
        // advance to password field
        [passwordField becomeFirstResponder];
    }
    else if (theTextField==passwordField)
    {
        // close keyboard
        [passwordField resignFirstResponder];
        // login
        [self login:self];
        return NO;
    }
    return YES;
}

- (IBAction)login:(id)sender
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];

    NSURL *url = [NSURL URLWithString:@"https://www.toggl.com/api/v8/sessions"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSString *authString = @"user:pass"; // [NSString stringWithFormat:@"%@:%@", [self passwordField], [self password]];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];

    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil)
        {
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
            NSLog(@"response status code: %ld", (long)[(NSHTTPURLResponse *)response statusCode]);
        }
    }];
    [postDataTask resume];

    // close modal
    [self dismissViewControllerAnimated:YES completion:Nil];
}


@end
