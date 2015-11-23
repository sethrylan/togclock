//
//  Created by Seth Rylan Gainey on 10/14/15.
//  Copyright (c) 2015 Seth Rylan Gainey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSVolumeButtonHandler.h"
#import "SelectTableViewController.h"
#import "Entry.h"
#import "ButtonMaskView.h"
#import "MZTimerLabel.h"

@interface MainViewController : UIViewController<SelectTableDelegate, NSURLSessionDelegate>

@property JPSVolumeButtonHandler *volumeButtonHandler;

@property (strong, nonatomic) IBOutlet UILabel *vdownProjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *vdownDescriptionLabel;
@property (strong, nonatomic) IBOutlet MZTimerLabel *vdownStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *vupProjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *vupDescriptionLabel;
@property (strong, nonatomic) IBOutlet MZTimerLabel *vupStatusLabel;

@property (strong, nonatomic) Entry *vupEntry;
@property (strong, nonatomic) Entry *vdownEntry;

@property (strong, nonatomic) IBOutlet ButtonMaskView *buttonMaskView;

@property (strong, nonatomic) IBOutlet UITableView *historyTable;


@end
