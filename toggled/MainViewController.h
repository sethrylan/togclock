//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSVolumeButtonHandler.h"
#import "SelectTableViewController.h"
#import "Entry.h"
#import "ButtonMaskView.h"

@interface MainViewController : UIViewController<SelectTableDelegate, NSURLSessionDelegate>

@property JPSVolumeButtonHandler *volumeButtonHandler;

@property (strong, nonatomic) IBOutlet UIButton *vupButton;
@property (strong, nonatomic) IBOutlet UIButton *vdownButton;

@property (strong, nonatomic) IBOutlet UILabel *vdownProjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *vdownDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *vupProjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *vupDescriptionLabel;

@property (strong, nonatomic) Entry *vupEntry;
@property (strong, nonatomic) Entry *vdownEntry;

@property (strong, nonatomic) IBOutlet ButtonMaskView *buttonMaskView;

@end
