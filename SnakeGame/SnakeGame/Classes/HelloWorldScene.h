//
//  HelloWorldScene.h
//
//  Created by : Admin
//  Project    : SnakeGame
//  Date       : 2/16/16
//
//  Copyright (c) 2016 Interlogic.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef NS_ENUM(NSUInteger, SnakeDirection) {
    SnakeDirectionLeft,
    SnakeDirectionRight,
    SnakeDirectionUp,
    SnakeDirectionDown
};

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
    blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
    alpha:1.0]

// -----------------------------------------------------------------------

@interface HelloWorldScene : CCScene {
    NSMutableArray *_snake;
    CGSize _gameBoardSize;
    CGPoint _gameBoardPosition;
    NSMutableArray *_foods;
    NSMutableArray *_walls;
    NSInteger _points;
    //CCColor * headColor;
    //CCColor * tailColor;
    //CCColor * foodColor;
    //CCColor * wallColor;
    NSMutableArray * _history;
    NSMutableArray * _bonuses;
    NSMutableArray * _speedBonuses;
    CCTime speed;
    CCDrawNode *progressBar;
}

// -----------------------------------------------------------------------

@property(strong, nonatomic)CCTimer *timer;
@property(assign, nonatomic)SnakeDirection direction;
- (instancetype)init;
+ (CCScene *) scene;

// -----------------------------------------------------------------------

@end


































