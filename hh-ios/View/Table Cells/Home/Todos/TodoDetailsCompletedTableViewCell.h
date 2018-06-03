//
//  TodoDetailsCompletedTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 4/9/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoDetailsCompletedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenLabel;

- (void)setUpForTitle:(NSString *)title andDescription:(NSString *)description andCreatedBy:(NSString *)createdBy andCompletedBy:(NSString *)completedBy andTimeTaken:(NSString *)timeTaken;

@end
