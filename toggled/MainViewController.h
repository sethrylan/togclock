//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSVolumeButtonHandler.h"
#import "SelectTableViewController.h"

@interface MainViewController : UIViewController<SelectTableDelegate>

@property JPSVolumeButtonHandler *volumeButtonHandler;

@property (strong, nonatomic) IBOutlet UIButton *vupButton;
@property (strong, nonatomic) IBOutlet UIButton *vdownButton;

@property (strong, nonatomic) IBOutlet UIButton *vupSelectButton;
@property (strong, nonatomic) IBOutlet UIButton *vdownSelectButton;

@property (strong, nonatomic) IBOutlet NSMutableDictionary *vupEntry;
@property (strong, nonatomic) IBOutlet NSMutableDictionary *vdownEntry;

@end
