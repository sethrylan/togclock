//
//  NSDictionary+Additions.m
//  toggled
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (double)doubleForKey:(NSString*)key
{
    return [[self valueForKey:key] doubleValue];
}

@end
