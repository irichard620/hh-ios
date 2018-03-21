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
@property (weak, nonatomic) IBOutlet UILabel *assigneeSectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;

- (void)restrictEdit;
- (void)allowEdit;
- (void)setupForCreateWithCreatedBy:(NSString *)createdBy;
- (void)setupForEditWithTitle:(NSString *)title andDescr:(NSString *)description andCreatedBy:(NSString *)createdBy;
- (void)setupForViewWithTitle:(NSString *)title andDescr:(NSString *)description andCreatedBy:(NSString *)createdBy;
- (void)setupForCompleteWithTitle:(NSString *)title andDescr:(NSString *)description andCreatedBy:(NSString *)createdBy;

@end
