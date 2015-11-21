//
//  NSDate+SSToolkitAdditions.m
//  SAMCategories
//
//  Created by Sam Soffes on 5/26/10.
//  Copyright (c) 2010-2014 Sam Soffes. All rights reserved.
//

#import "NSDate+ISO8601.h"

@implementation NSDate (ISO8601)

- (NSString *)asISO8601String {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    return [dateFormatter stringFromDate:self];
}

@end
