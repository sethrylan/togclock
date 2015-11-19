
#import <UIKit/UIKit.h>

@interface Project : NSObject

@property (nonatomic) long _id;
@property (strong, nonatomic) NSString *_name;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
