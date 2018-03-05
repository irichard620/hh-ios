//
//  JoinHouseViewController.h
//  hh-ios
//
//  Created by Ian Richard on 1/3/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

@protocol JoinHouseDelegate;

@interface JoinHouseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *messageContainer;

@property (weak, nonatomic) IBOutlet UITextField *houseCodeField;
@property (weak, nonatomic) IBOutlet UIButton *joinHouseButton;

@property(weak,nonatomic) id<JoinHouseDelegate> delegate;
@end
@protocol JoinHouseDelegate <NSObject>

- (void)joinedHouse:(House *)house;

@end
