
#import <Foundation/Foundation.h>

/**
 Provides extensions to `NSDate` for various common tasks.
 */
@interface NSDate (ISO8601)

/**
 Returns a string representation of the receiver in ISO8601 format.
 
 @return A string representation of the receiver in ISO8601 format.
 */
- (NSString *)asISO8601String;

+ (NSDate *)fromISO8601String:(NSString *)iso8601String;


@end
