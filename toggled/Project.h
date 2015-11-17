@interface Project : NSObject

@property (nonatomic) long pid;
@property (nonatomic) long id;
@property (strong, nonatomic) NSString *name;
//- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

//@implementation Project
//- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
//    if (self = [super init]) {
//        self->pid = dictionary[@"pid"];
//        self->name = dictionary[@"name"];
//    }
//    return self;
//}
//@end
