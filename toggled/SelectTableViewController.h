//
//  SelectTableViewController.h
//  toggled
//

@interface SelectTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) NSMutableArray *projects;

@end
