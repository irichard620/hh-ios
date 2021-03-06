//
//  HouseEditViewController.m
//  hh-ios
//
//  Created by Ian Richard on 2/9/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "HouseEditViewController.h"
#import "UserHomeTableViewCell.h"
#import "SWRevealViewController.h"
#import "ViewHelpers.h"
#import "EditPropertyTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface HouseEditViewController ()

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) NSString *currentDisplayName;
@property (nonatomic) BOOL displayNameChanged;
@property (nonatomic) BOOL avatarChanged;

@end

@implementation HouseEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _displayNameChanged = NO;
        _avatarChanged = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationItem.title = @"Edit House";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Add gesture recognizer for reveal controller
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    // Create menu button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self.revealViewController andSelectorName:@"revealToggle:" andImage:[UIImage imageNamed:@"menu.png"] isBack:NO];
    self.navigationItem.rightBarButtonItem = [ViewHelpers createTextNavButtonWithTarget:self andSelectorName:@"saveButtonClicked:" andTitle:@"Save"];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    // Setup table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedSectionHeaderHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Edit nickname cell
        static NSString *CellIdentifier = @"editProperty";
        EditPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"EditPropertyTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.textField.text = self.house.displayName;
        [cell.textField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    } else {
        // Options cells
        static NSString *CellIdentifier = @"userCell";
        UserHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"UserHomeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            [cell setNoImageCellWithText:@"Manage Residents"];
        } else if (indexPath.row == 1) {
            [cell setNoImageCellWithText:@"Leave House"];
        } else {
            [cell setNoImageCellWithText:@"Disband House"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 110;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 110)];
        header.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.tableView.frame.size.width/2 - 35), 20, 70, 70)];
        if (self.house.avatarLink == nil) {
            [self.imageView setImage:[UIImage imageNamed:@"group-icon-white-background.png"]];
        } else {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.house.avatarLink] placeholderImage:[UIImage imageNamed:@"group-icon-white-background.png"]];
        }
        self.imageView.layer.cornerRadius = 16.0;
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapped:)];
        tap.delegate = self;
        [self.imageView addGestureRecognizer:tap];
        
        [header addSubview:self.imageView];
        
        return header;
    } else {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
        label.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        label.font = [UIFont systemFontOfSize:12];
        label.frame = CGRectMake(8, 20, self.tableView.frame.size.width, 30);
        label.text = @"OPTIONS";
        [header addSubview:label];
        header.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
        return header;
    }
}

#pragma mark Interaction

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.revealViewController revealToggle:self];
            [self.delegate manageResidentsClicked];
        }
    }
}

- (void)saveButtonClicked:(id)sender {
    // First - upload photo if needed
    if (self.avatarChanged) {
        [HouseManager uploadHousePic:self.imageView.image withUniqueName:self.house.uniqueName withCompletion:^(NSString *resourceURL, NSString *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
                });
            } else {
                [self editHouseWithResourceURL:resourceURL];
            }
        }];
    } else {
        [self editHouseWithResourceURL:nil];
    }
}

- (void)editHouseWithResourceURL:(NSString *)resourceURL {
    if (!self.displayNameChanged) {
        self.currentDisplayName = nil;
    }
    [HouseManager editHouseWithUniqueName:self.house.uniqueName withDisplayName:self.currentDisplayName andAvatarLink:resourceURL andFullName:self.user.fullName withCompletion:^(House *house, NSString *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
            });
        } else {
            self.house = house;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate houseUpdated];
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Success" andDescription:@"The details for your house were updated"] animated:YES completion:nil];
            });
        }
    }];
}

- (void)imageTapped:(id)sender {
    // Show action sheet
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak UIAlertController *weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateButtons {
    if (self.displayNameChanged || self.avatarChanged) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

#pragma mark Text delegate

- (void)textFieldDidChange:(UITextField *)textField {
    self.currentDisplayName = TRIM(textField.text);
    if ([self.currentDisplayName isEqualToString:self.house.displayName] || [self.currentDisplayName isEqualToString:@""]) {
        self.displayNameChanged = NO;
    } else {
        self.displayNameChanged = YES;
    }
}

#pragma mark Picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    self.avatarChanged = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self updateButtons];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
