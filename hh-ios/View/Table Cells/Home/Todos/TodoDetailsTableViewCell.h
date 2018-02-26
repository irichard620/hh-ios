//
//  TodoDetailsTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 2/20/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descrTextView;
@property (weak, nonatomic) IBOutlet UILabel *assigneeLabel;

- (void)restrictEditForNonOwner;
- (void)displayNewAssignee:(NSString *)fullName;
- (NSString *)getCurrentAssignee;

@end
