
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

@end
