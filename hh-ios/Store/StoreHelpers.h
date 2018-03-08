//
//  StoreHelpers.h
//  hh-ios
//
//  Created by Ian Richard on 2/26/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Messages
//---------------------------
// Todos - pass id for all messages
extern NSString * const CREATE_TODO_MESSAGE;
extern NSString * const EDIT_TODO_MESSAGE;
extern NSString * const DELETE_TODO_MESSAGE;
extern NSString * const REASSIGN_TODO_MESSAGE;
extern NSString * const COMPLETE_TODO_MESSAGE;
// House messages
// Create - do nothing - only sent when not loaded in yet
extern NSString * const EDIT_HOUSE_MESSAGE; /* Pass ID */
extern NSString * const MEMBER_ADDED; /* Pass ID */
extern NSString * const MEMBER_REMOVED; /* Pass ID */
// Chat messages
extern NSString * const CHAT_MESSAGE; /* Pass avatar link */

// Error codes
//---------------------------
extern NSString * const UNKNOWN_ERROR;
extern NSString * const NOT_FOUND_ERROR;
extern NSString * const CONNECTION_ERROR;
extern NSString * const MISSING_INFO_ERROR;
extern NSString * const NOT_AUTHORIZED_ERROR;
extern NSString * const DUPLICATE_ERROR;

@interface StoreHelpers : NSObject

+ (NSURL *)saveImageToFile:(UIImage *)image;
+ (NSString *)getErrorTypeToReturnFrom:(NSError *)error andCode:(NSInteger) code;

+ (void)sendPostRequestWithEndpoint:(NSString *)endpoint requiresAuth:(BOOL)requiresAuth hasParameters:(NSDictionary *)parameters withCallback:(void(^)(NSDictionary *jsonResponse, NSString *errorType))callback;
+ (void)sendPutRequestWithEndpoint:(NSString *)endpoint requiresAuth:(BOOL)requiresAuth hasParameters:(NSDictionary *)parameters withCallback:(void(^)(NSDictionary *jsonResponse, NSString *errorType))callback;
+ (void)sendGetRequestWithEndpoint:(NSString *)endpoint requiresAuth:(BOOL)requiresAuth withCallback:(void(^)(NSDictionary *jsonResponse, NSString *errorType))callback;
+ (void)sendDeleteRequestWithEndpoint:(NSString *)endpoint requiresAuth:(BOOL)requiresAuth withCallback:(void(^)(NSDictionary *jsonResponse, NSString *errorType))callback;

@end
