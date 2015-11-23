//
//  Utils.h
//

@interface Utils : NSObject 

+ (NSMutableURLRequest*)makeJSONRequest:(NSString *)urlString withAuth:(NSString *)authString withOperation:(NSString *)op;

+ (NSArray*)getLatestEntries:(NSArray*)entries withLimit:(long)limit;

@end