//
//  Project.m
//  toggled
//

#import "Project.h"

@implementation Project : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
            NSString *propertyName = [NSString stringWithFormat:@"_%@", key];
            //            NSLog(@"%@ => %@", key, value);
            if ([self respondsToSelector:NSSelectorFromString(propertyName)]) {
                [self setValue:value forKey:propertyName];
            }
        }];
    }
    return self;
}

@end