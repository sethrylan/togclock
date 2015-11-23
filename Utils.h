//
//  Utils.h
//  toggled
//

@interface Utils : NSObject 

+ (NSMutableURLRequest*)makeJSONRequest:(NSString *)urlString withAuth:(NSString *)authString withOperation:(NSString *)op;

@end