//
//  StoreHelpers.m
//  hh-ios
//
//  Created by Ian Richard on 2/26/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "StoreHelpers.h"
#import "AuthenticationManager.h"
#import <UNIRest.h>

NSString * const CREATE_TODO_MESSAGE = @"create_todo";
NSString * const EDIT_TODO_MESSAGE = @"edit_todo";
NSString * const DELETE_TODO_MESSAGE = @"delete_todo";
NSString * const REASSIGN_TODO_MESSAGE = @"reassign_todo";
NSString * const COMPLETE_TODO_MESSAGE = @"complete_todo";
NSString * const EDIT_HOUSE_MESSAGE = @"edit_house";
NSString * const MEMBER_ADDED = @"member_added";
NSString * const MEMBER_REMOVED = @"member_removed";
NSString * const CHAT_MESSAGE = @"chat";

NSString * const UNKNOWN_ERROR = @"unknown";
NSString * const NOT_FOUND_ERROR = @"not_found";
NSString * const CONNECTION_ERROR = @"connection";
NSString * const MISSING_INFO_ERROR = @"missing_info";
NSString * const NOT_AUTHORIZED_ERROR = @"not_invited";
NSString * const DUPLICATE_ERROR = @"duplicate";

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

+ (NSString *)getErrorTypeToReturnFrom:(NSError *)error andCode:(NSInteger)code {
    if (!error) {
        if (code == 200 || code == 201) {
            return nil;
        } else if (code == 400) {
            return MISSING_INFO_ERROR;
        } else if (code == 401) {
            return NOT_AUTHORIZED_ERROR;
        } else if (code == 409) {
            return NOT_FOUND_ERROR;
        } else if (code == 409) {
            return DUPLICATE_ERROR;
        } else {
            return UNKNOWN_ERROR;
        }
    } else {
        NSLog(@"%@", error.localizedDescription);
        return UNKNOWN_ERROR;
    }
}

+ (NSString *)getURLWithEndpoint:(NSString *)endpoint {
    return [NSString stringWithFormat:@"https://honesthousemate.herokuapp.com/api%@",endpoint];
}

+ (NSDictionary *)createHeadersWithAuth:(BOOL)withAuth {
    if (withAuth) {
        NSDictionary *headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
        return headers;
    } else {
         return @{@"accept": @"application/json"};
    }
}

+ (void)sendPostRequestWithEndpoint:(NSString *)endpoint requiresAuth:(BOOL)requiresAuth hasParameters:(NSDictionary *)parameters withCallback:(void (^)(NSDictionary *, NSString *))callback {
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:[StoreHelpers getURLWithEndpoint:endpoint]];
        [request setHeaders:[StoreHelpers createHeadersWithAuth:requiresAuth]];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        callback(jsonResponse.body.JSONObject, [StoreHelpers getErrorTypeToReturnFrom:error andCode:jsonResponse.code]);
    }];
}

+ (void)sendPutRequestWithEndpoint:(NSString *)endpoint requiresAuth:(BOOL)requiresAuth hasParameters:(NSDictionary *)parameters withCallback:(void (^)(NSDictionary *, NSString *))callback {
    [[UNIRest put:^(UNISimpleRequest *request) {
        [request setUrl:[StoreHelpers getURLWithEndpoint:endpoint]];
        [request setHeaders:[StoreHelpers createHeadersWithAuth:requiresAuth]];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        callback(jsonResponse.body.JSONObject, [StoreHelpers getErrorTypeToReturnFrom:error andCode:jsonResponse.code]);
    }];
}

+ (void)sendGetRequestWithEndpoint:(NSString *)endpoint requiresAuth:(BOOL)requiresAuth withCallback:(void (^)(NSDictionary *, NSString *))callback {
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[StoreHelpers getURLWithEndpoint:endpoint]];
        [request setHeaders:[StoreHelpers createHeadersWithAuth:requiresAuth]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        callback(jsonResponse.body.JSONObject, [StoreHelpers getErrorTypeToReturnFrom:error andCode:jsonResponse.code]);
    }];
}

+ (void)sendDeleteRequestWithEndpoint:(NSString *)endpoint requiresAuth:(BOOL)requiresAuth withCallback:(void (^)(NSDictionary *, NSString *))callback {
    [[UNIRest delete:^(UNISimpleRequest *request) {
        [request setUrl:[StoreHelpers getURLWithEndpoint:endpoint]];
        [request setHeaders:[StoreHelpers createHeadersWithAuth:requiresAuth]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        callback(jsonResponse.body.JSONObject, [StoreHelpers getErrorTypeToReturnFrom:error andCode:jsonResponse.code]);
    }];
}

@end
