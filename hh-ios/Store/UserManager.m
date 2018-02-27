//
//  UserManager.m
//  hh-ios
//
//  Created by Ian Richard on 1/30/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "UserManager.h"
#import <UNIRest.h>
#import "House.h"
#import "AuthenticationManager.h"

@implementation UserManager

+ (void)getHouseListForUserWithCompletion:(void (^)(NSArray *, NSString *))completion; {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // Create get request to /api/user/houses
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/user/houses"];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 200) {
                // If no error, get json response and deserialize to house object
                NSArray *housesJson = jsonResponse.body.JSONObject[@"houses"];
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < housesJson.count; i++) {
                    House *house = [House deserializeHouse:housesJson[i]];
                    [resultArray addObject:house];
                }
                completion(resultArray, nil);
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
            
        }
    }];
}

+ (void)uploadProfilePic:(UIImage *)image withCompletion:(void (^)(NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // Create get request to /api/user/createUploadLink
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/user/createUploadLink"];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                NSString *presignedURL = jsonResponse.body.JSONObject[@"url"];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:presignedURL]];
                request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                [request setHTTPMethod:@"PUT"];
                [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
                
                // Create upload
                NSURLSessionUploadTask *uploadTask = [[[NSURLSession alloc]init]uploadTaskWithRequest:request fromFile:[StoreHelpers saveImageToFile:image] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        completion(UNKNOWN_ERROR);
                    } else {
                        completion(nil);
                    }
                }];
                [uploadTask resume];
            } else {
                completion(UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(UNKNOWN_ERROR);
        }
    }];
}

@end
