//
//  SettingsTableViewController.m
//  SnakeGame
//
//  Created by Admin on 2/17/16.
//  Copyright © 2016 Interlogic. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AbstactFactoryDesign.h"

NSInteger const kColorThemePickerIndex = 2;
NSInteger const kColorThemeLabelIndex = 1;
NSInteger const kColorThemePickerHeight = 164;

@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *colorThemePicker;
@property (weak, nonatomic) IBOutlet UILabel *colorThemeLabel;

@property(strong, nonatomic) NSArray *colorThemes;
@property(strong, nonatomic) NSArray *colorThemesClasses;
@property(assign, nonatomic) BOOL colorThemePickerIsShowing;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.colorThemes = @[@"Sea",
                         @"Forrest",
                         @"Strawberry",
                         @"Plum",
                         @"Peach",
                         @"Midnight Desert",
                         @"Violet",
                         @"Lavenger",
                         @"Winter",
                         @"BlueBerry"];
    self.colorThemesClasses = @[[SeaFactoryDesign class],
                               [ForrestFactoryDesign class],
                               [StrawberryFactoryDesign class],
                               [PlumFactoryDesign class],
                               [PeachFactoryDesign class],
                               [MidnightDesertFactoryDesign class],
                               [VioletFactoryDesign class],
                               [LavengerFactoryDesign class],
                               [WinterFactoryDesign class],
                               [BlueBerryFactoryDesign class]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    
    if(indexPath.row == kColorThemePickerIndex) {
        height = self.colorThemePickerIsShowing ? kColorThemePickerHeight : 0.0f;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1) {
        if(self.colorThemePickerIsShowing) {
            [self hideColorThemePicker];
        } else {
            [self showColorThemePicker];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showColorThemePicker
{
    
    self.colorThemePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.colorThemePicker.hidden = NO;
    self.colorThemePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.colorThemePicker.alpha = 1.0f;
    }];
}

- (void)hideColorThemePicker
{
    self.colorThemePickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.colorThemePicker.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.colorThemePicker.hidden = YES;
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.colorThemeLabel.text = self.colorThemes[row];
    Class designClass = self.colorThemesClasses[row];
    [FactoryDesign setSharedInstanceWithDesign:[designClass new]];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [FactoryDesign sharedInstance].headColor;
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [FactoryDesign sharedInstance].headColor;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.colorThemes.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.colorThemes[row];
}

- (void)signUpForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow
{
    if(self.colorThemePickerIsShowing) {
        [self hideColorThemePicker];
    }
}


@end
