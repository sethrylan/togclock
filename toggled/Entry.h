
#import "Project.h"
#import "Entry.h"

@interface Entry : NSObject
@property (strong, nonatomic) Project *_project;
@property (nonatomic) long _uid;
@property (nonatomic) long _id;
@property (strong, nonatomic) NSString *_description;
@property (strong, nonatomic) NSString *_pid;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@implementation Entry : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
            NSLog(@"%@ => %@", key, value);
            NSString *propertyName = [NSString stringWithFormat:@"_%@", key];
            if ([self respondsToSelector:NSSelectorFromString(propertyName)]) {
                [self setValue:value forKey:propertyName];
            }
        }];
        
    }
    return self;
}

@end
