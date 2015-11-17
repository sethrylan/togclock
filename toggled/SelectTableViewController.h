//
//  SelectTableViewController.h
//  toggled
//

@protocol SecondDelegate;

@interface SelectTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>

@property (nonatomic, assign) id<SecondDelegate>    myDelegate;

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *projects;
@property (strong, nonatomic) NSMutableArray *previousEntries;

@end

@protocol SecondDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(SelectTableViewController *)secondDetailViewController;
@end
