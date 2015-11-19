//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//
//  See http://stackoverflow.com/questions/16230700/display-uiviewcontroller-as-popup-in-iphone for development hints
//

#import "LoginModalViewController.h"
#import "KeychainItemWrapper.h"

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
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
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
        [self loginUp:self];
        return NO;
    }
    return YES;
}

- (void)login:(NSString*) username withPassword:(NSString*)password onSuccess:(void (^)(NSData*))successBlock onFailure:(void (^)(NSError*))failureBlock
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:@"https://www.toggl.com/api/v8/sessions"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask =
        [session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if(error == nil)
                        {
//                            NSLog(@"Data = %@",[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
//                            NSLog(@"response status code: %ld", (long)[(NSHTTPURLResponse *)response statusCode]);
                            if ((long)[(NSHTTPURLResponse *)response statusCode] == 403)
                            {
                                failureBlock(error);
                            }
                            else
                            {
                                successBlock(data);
                            }
                        }
                    }];
    [postDataTask resume];
}


// see https://developer.apple.com/library/ios/samplecode/GenericKeychain/Listings/ReadMe_txt.html#//apple_ref/doc/uid/DTS40007797-ReadMe_txt-DontLinkElementID_11
- (void)saveToKeychain:(NSString*)username withPassword:(NSString*)password withApiToken:(NSString*)apiToken
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"togglLogin" accessGroup:nil];
    
    [keychainItem setObject:@"username" forKey:username];
    [keychainItem setObject:@"password" forKey:password];
    [keychainItem setObject:@"apiToken" forKey:apiToken];

//    //    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"toggltoken" accessGroup:nil];
//    
//    self.passwordItem = wrapper;
//    //    detailViewController.passwordItem = wrapper;
//    
//    self.accountNumberItem = wrapper;
    //    detailViewController.accountNumberItem = wrapper;

}

- (IBAction)loginUp:(id)sender
{
    NSString *email = emailField.text;
    NSString *password = passwordField.text;
    
    void (^successBlock)(NSData*) = ^void(NSData *data) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        NSString *apiToken = [json valueForKeyPath:@"data.api_token"];
        NSLog(@"api_token=%@", apiToken);
        
//        [self saveToKeychain:email withPassword:password withApiToken:apiToken];
        [self dismissViewControllerAnimated:YES completion:Nil];
    };
    
    void (^failureBlock)(NSError*) = ^void(NSError *error) {
        [self showLoginFailure];
    };

    [self login:email withPassword:password onSuccess:successBlock onFailure:failureBlock];
}

-(void)showLoginFailure
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info" message:@"Login Incorrect" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
