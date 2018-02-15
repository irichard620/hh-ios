//
//  ToDo.h
//  hh-ios
//
//  Created by Ian Richard on 2/13/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserReference.h"

@interface ToDo : NSObject

// Unique ID of todo
@property(nonatomic) NSString *_id;

// Owner of todo
@property(nonatomic) UserReference *owner;

// Assignee
@property(nonatomic) UserReference *assignee;

// ID of house
@property(nonatomic) NSString *house_id;

// Title, description of todo
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *todoDescription;

// Time taken - minutes
@property(nonatomic) NSNumber *timeTaken;

@end
