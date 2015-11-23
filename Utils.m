//
//  Utils.m
//  toggled
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@implementation Utils

+ (NSMutableURLRequest*)makeJSONRequest:(NSString *)urlString withAuth:(NSString *)authString withOperation:(NSString *)op
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    
    NSDictionary *headers = @{
                              @"Content-Type":@"application/json",
                              @"Accept":@"application/json"
                              };
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setAllHTTPHeaderFields:headers];
    
    [request setHTTPMethod:op];
    return request;
}

@end