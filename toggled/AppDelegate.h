//
//  AppDelegate.h
//  toggled
//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeychainItemWrapper;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) KeychainItemWrapper *passwordItem;
@property (nonatomic, retain) KeychainItemWrapper *accountNumberItem;


@end
