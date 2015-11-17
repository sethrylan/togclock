//
//  SelectTableViewController.h
//  toggled
//

@protocol SelectTableDelegate;

@interface SelectTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>

@property (nonatomic, assign) id<SelectTableDelegate> delegate;

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *projects;
@property (strong, nonatomic) NSMutableArray *previousEntries;

@end

@protocol SelectTableDelegate<NSObject>
@optional
- (void)tableDismissed:(SelectTableViewController *)selectTableViewController withEntry:(NSDictionary*)entry;
@end
