//
//  NSString+Security.h
//  hh-ios
//
//  Created by Ian Richard on 1/30/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Security)

- (BOOL)isValidEmail;
- (NSString *)createSHA512;
- (NSDate *)getDateFromString;

@end
