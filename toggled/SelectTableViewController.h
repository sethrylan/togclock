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

@property (copy) void(^callback)(NSDictionary *entry);

@end

@protocol SelectTableDelegate<NSObject>
@property (strong, nonatomic) NSDictionary *vupEntry;
@property (strong, nonatomic) NSDictionary *vdownEntry;
@optional
- (void)tableDismissed:(SelectTableViewController *)selectTableViewController withEntry:(NSDictionary*)entry;
@end
