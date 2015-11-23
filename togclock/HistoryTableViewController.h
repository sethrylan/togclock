//
//  HistoryTableViewController.h
//

@interface HistoryTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) NSMutableArray *previousEntries;

@property (strong, nonatomic) IBOutlet UITableView *historyTable;

@end
