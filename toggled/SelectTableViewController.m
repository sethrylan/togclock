//
//  SelectTableViewController.m
//  toggled
//

#import "SelectTableViewController.h"

@implementation SelectTableViewController

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,45,320,200) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.projects = [[NSArray alloc] init];
    // TODO: Replace with API data
    NSArray *projects = [NSTimeZone knownTimeZoneNames];
    self.projects = [projects sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    [self getRelatedData];
}

-(void)getRelatedData
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:@"https://www.toggl.com/api/v8/me?with_related_data=true"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSString *authString = @"d72c72d4e4594c56dae41204d0860ce4:api_token"; // [NSString stringWithFormat:@"%@:%@", [self passwordField], [self password]];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *getMeDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            NSLog(@"Data = %@",text);
                                                            NSLog(@"response status code: %ld", (long)[(NSHTTPURLResponse *)response statusCode]);
//                                                            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                                                            for (NSMutableDictionary *project in json[@"data"][@"projects"]) {
//                                                                [self.projects addObject: project[@"name"]];
//                                                            }
                                                        }
                                                    }];
    [getMeDataTask resume];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of time zone names.
    return [self.projects count];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [self.projects objectAtIndex:indexPath.row];
            break;
        default:
            cell.textLabel.text = [self.projects objectAtIndex:indexPath.row];
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
            return @"Client";
            break;
    };
}

@end