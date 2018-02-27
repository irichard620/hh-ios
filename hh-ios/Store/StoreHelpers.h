//
//  StoreHelpers.h
//  hh-ios
//
//  Created by Ian Richard on 2/26/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const UNKNOWN_ERROR;
extern NSString * const NOT_FOUND_ERROR;
extern NSString * const CONNECTION_ERROR;
extern NSString * const MISSING_INFO_ERROR;

@interface StoreHelpers : NSObject

+ (NSURL *)saveImageToFile:(UIImage *)image;

@end
