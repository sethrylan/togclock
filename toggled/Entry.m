//
//  Entry.m
//  toggled
//

#import "Entry.h"

@implementation Entry : NSObject

- (instancetype)initFromProject:(Project*)project {
    if (self = [super init]) {
        self._pid = project._id;
        self._projectName = project._name;
    }
    return self;
}

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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld", propertyName, self._pid];
        NSArray *filteredArray = [projects filteredArrayUsingPredicate:predicate];
        if ([filteredArray count] > 0 && [filteredArray objectAtIndex:0]) {
            [self setValue:[filteredArray objectAtIndex:0] forKey:@"_project"];
            [self setValue:[[filteredArray objectAtIndex:0] _name] forKey:@"_projectName"];
        }
    }
    
    // set active if duration is <0
    // "If the time entry is currently running, the duration attribute contains a negative value, denoting the start of the time entry in seconds since epoch (Jan 1 1970)"
    self._running = (self._duration < 0);
    
    return self;
}

@end
