#import <Foundation/Foundation.h>

/**
 * Provides extensions to `NSDictionary` for various common tasks.
 */
@interface NSDictionary (Additions)

/**
 * Returns a double for a key
 */
- (double)doubleForKey:(NSString*)key;

@end
