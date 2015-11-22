
#import <UIKit/UIKit.h>
#import "Project.h"

@interface Entry : NSObject
@property (strong, nonatomic) Project *_project;      // convenience property; constructed
@property (strong, nonatomic) NSString *_projectName; // convenience property; constructed
@property (nonatomic) long _uid;
@property (nonatomic) long _id;
@property (strong, nonatomic) NSString *_description;
@property (nonatomic) long _pid;
@property (strong, nonatomic) NSString *_start;
@property (strong, nonatomic) NSString *_stop;
@property (nonatomic) long _duration;
@property (strong, nonatomic) NSString *_createdWith;
@property (nonatomic) BOOL _active;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary withProjects:(NSArray*)projects;
- (instancetype)initFromProject:(Project*)project;
@end
