//
//  StoreHelpers.m
//  hh-ios
//
//  Created by Ian Richard on 2/26/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "StoreHelpers.h"

NSString * const UNKNOWN_ERROR = @"unknown";
NSString * const NOT_FOUND_ERROR = @"not_found";
NSString * const CONNECTION_ERROR = @"connection";
NSString * const MISSING_INFO_ERROR = @"missing_info";

@implementation StoreHelpers

+ (NSURL *)saveImageToFile:(UIImage *)image {
    // Get temp path
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.png"];
    
    // Get data about image
    NSData *imageData = UIImagePNGRepresentation(image);
    
    // Save image to temp path and get file URL
    [imageData writeToFile:path atomically:YES];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    return url;
}

@end
