
#import "Project.h"
#import "Entry.h"

@interface Entry : NSObject
@property (strong, nonatomic) Project *_project;
@property (nonatomic) long _uid;
@property (nonatomic) long _id;
@property (strong, nonatomic) NSString *_description;
@property (strong, nonatomic) NSString *_pid;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary withProjects:(NSArray*)projects;
@end

@implementation Entry : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dictionary withProjects:(NSArray*)projects {
    if (self = [super init]) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
//            NSLog(@"%@ => %@", key, value);
            NSString *propertyName = [NSString stringWithFormat:@"_%@", key];
            if ([self respondsToSelector:NSSelectorFromString(propertyName)]) {
                [self setValue:value forKey:propertyName];
            }
        }];
        
    }
    
    // add project info
    if (self._pid && projects && [projects count] > 0) {
        NSString *propertyName = @"_id";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", propertyName, self._pid];
        NSArray *filteredArray = [projects filteredArrayUsingPredicate:predicate];
        if ([filteredArray count] > 0 && [filteredArray objectAtIndex:0]) {
            [self setValue:[filteredArray objectAtIndex:0] forKey:@"_project"];
        }
    }

    return self;
}

@end
