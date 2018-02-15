//
//  NSString+EmailValidation.m
//  hh-ios
//
//  Created by Ian Richard on 1/30/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "NSString+Security.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Security)

- (BOOL)isValidEmail {
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
//    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
//    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)createSHA512 {
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    
    CC_SHA512(keyData.bytes, (unsigned int)keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    return [out description];
}

@end
