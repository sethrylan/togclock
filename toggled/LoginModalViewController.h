//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginModalViewController : UIViewController <NSURLSessionDelegate>

// see http://www.makemegeek.com/implement-uitextfield-ios/ for implementing UITextField delegates
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end
