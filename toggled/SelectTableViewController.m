//
//  SelectTableViewController.m
//  toggled
//

#import "SelectTableViewController.h"
#import "Project.h"
#import "Entry.h"

@implementation SelectTableViewController

@synthesize delegate;

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,45,320,200) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    self.tableView = tableView;
    self.sections = [[NSArray alloc] init];
    self.projects = [[NSMutableArray alloc] init];
    self.previousEntries = [[NSMutableArray alloc] init];
    self.sections = @[self.projects, self.previousEntries];
    [self getRelatedData];
//    NSLog(@"self.entry = %@", self.entry);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)getRelatedData
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:@"https://www.toggl.com/api/v8/me?with_related_data=true"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    NSString *authString = @"d72c72d4e4594c56dae41204d0860ce4:api_token"; // [NSString stringWithFormat:@"%@:%@", [self passwordField], [self password]];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    void (^parseData)(NSData*, NSURLResponse*, NSError*) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil)
        {
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
            NSLog(@"response status code: %ld", (long)[(NSHTTPURLResponse *)response statusCode]);
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:nil];
            for (NSDictionary *projectJson in json[@"data"][@"projects"]) {
                Project *project = [[Project alloc] initWithDictionary:projectJson];
                [self.projects addObject:project];
            }
            
            for (NSDictionary *entryJson in json[@"data"][@"time_entries"]) {
                Entry *entry = [[Entry alloc] initWithDictionary:entryJson withProjects:self.projects];
                [self.previousEntries addObject:entry];
            }

            [self.tableView reloadData];
        }
    };
    
    NSURLSessionDataTask *getMeDataTask = [session dataTaskWithRequest:request
                                                     completionHandler:parseData];
    [getMeDataTask resume];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    /*
     Retrieve a cell with the given identifier from the table view.
     The cell is defined in the main storyboard: its identifier is MyIdentifier, and  its selection style is set to None.
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[self.projects objectAtIndex:indexPath.row] _name];
            break;
        default:
            cell.textLabel.text = [[[self.previousEntries objectAtIndex:indexPath.row] _project] _name];
            cell.detailTextLabel.text = [[self.previousEntries objectAtIndex:indexPath.row] _description];
            break;
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Projects";
            break;
        default:
            return @"Previous Entries";
            break;
    };
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
//    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
//    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;

    [self closePopup:indexPath];
}


- (IBAction)closePopup:(id)sender
{
    if (self.callback) {
        self.callback(@{@"project" : @"callbackproject"});
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(tableDismissed:withEntry:)]) {
        [self.delegate tableDismissed:self withEntry:@{@"project" : @"someproject"}];
    }
}

@end