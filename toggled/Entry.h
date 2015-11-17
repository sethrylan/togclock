
#import "Project.h"
#import "Entry.h"

@interface Entry : NSObject
@property (strong, nonatomic) Project *project;
@property (nonatomic) long uid;
@property (nonatomic) long id;
@property (strong, nonatomic) NSString *name;
//- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
