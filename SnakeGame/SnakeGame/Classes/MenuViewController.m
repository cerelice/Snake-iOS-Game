//
//  MenuViewController.m
//  SnakeGame
//
//  Created by Admin on 2/16/16.
//  Copyright © 2016 Interlogic. All rights reserved.
//

#import "MenuViewController.h"
#import "AbstactFactoryDesign.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *leaderboardButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playButtonWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playButtonHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *lowLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *middleLevelButton;


@property(assign, nonatomic) BOOL isPlayButton;


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playButton.layer.cornerRadius = 50;
    self.playButton.clipsToBounds = YES;
    self.leaderboardButton.layer.cornerRadius = 20;
    self.leaderboardButton.clipsToBounds = YES;
    self.settingsButton.layer.cornerRadius = 20;
    self.settingsButton.clipsToBounds = YES;
    
    self.isPlayButton = YES;
    self.lowLevelButton.layer.cornerRadius = 50;
    self.lowLevelButton.clipsToBounds = YES;
    self.middleLevelButton.layer.cornerRadius = 50;
    self.middleLevelButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.topView.backgroundColor = [FactoryDesign sharedInstance].headColor;
    self.bottomView.backgroundColor = [FactoryDesign sharedInstance].tailColor;
    self.playButton.backgroundColor = [FactoryDesign sharedInstance].foodColor;
    self.leaderboardButton.backgroundColor = [FactoryDesign sharedInstance].wallColor;
    self.settingsButton.backgroundColor = [FactoryDesign sharedInstance].wallColor;
    self.lowLevelButton.backgroundColor = [FactoryDesign sharedInstance].foodColor;
    self.middleLevelButton.backgroundColor = [FactoryDesign sharedInstance].foodColor;
}

- (IBAction)playButtonClick:(id)sender {
    self.isPlayButton = !self.isPlayButton;
    int levelSize = self.isPlayButton ? 60 : 100;
    /*
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:50.0];
    animation.toValue = [NSNumber numberWithFloat:30.0];
    animation.duration = 1.0;
    [self.lowLevelButton.layer addAnimation:animation forKey:@"cornerRadius"];
    //[animation.layer setCornerRadius:0.0];
    [self.lowLevelButton.layer setCornerRadius:30.0];
     */
    CGAffineTransform lowTransform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.6, 0.6), -100, 0);
    CGAffineTransform middleTransform = CGAffineTransformScale(CGAffineTransformMakeTranslation(80, 0), 0.6, 0.6);
    if(self.isPlayButton ) {
        [UIView animateWithDuration:4.5f
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             /*
                             CGAffineTransform lowTransform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1.667, 1.667);
                             CGAffineTransform middleTransform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1.667, 1.667);
                             self.lowLevelButton.transform = lowTransform;
                             self.middleLevelButton.transform = middleTransform;
                              */
                             self.lowLevelButton.transform = CGAffineTransformInvert(lowTransform);
                             //self.middleLevelButton.transform = CGAffineTransformInvert(middleTransform);
                         } completion:^(BOOL finished) {
                             self.lowLevelButton.alpha = self.isPlayButton ? 0.0f : 1.0f;
                             self.middleLevelButton.alpha = self.isPlayButton ? 0.0f : 1.0f;
                         }];
    } else {
        self.lowLevelButton.alpha = self.isPlayButton ? 0.0f : 1.0f;
        self.middleLevelButton.alpha = self.isPlayButton ? 0.0f : 1.0f;
        [UIView animateWithDuration:0.5f
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.lowLevelButton.transform = lowTransform;
                             //self.middleLevelButton.transform = middleTransform;
                         } completion: nil];
    }
    
    self.playButton.backgroundColor = self.isPlayButton ? [FactoryDesign sharedInstance].foodColor : [UIColor lightGrayColor];
    [self.playButton setTitle:self.isPlayButton ? @"Play" : @"x" forState:UIControlStateNormal];
    
    int size = self.isPlayButton ? 100 : 26;
    
    self.playButtonWidthConstraint.constant = size;
    self.playButtonHeightConstraint.constant =  size;
    
    self.playButton.layer.cornerRadius = size / 2;

    [self.view updateConstraints];
    [self.playButton updateConstraints];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
