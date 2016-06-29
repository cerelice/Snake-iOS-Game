//
//  GameOverScene.h
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

// -----------------------------------------------------------------

@interface GameOverScene : CCScene

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
+ (CCScene*)sceneWithPoints:(NSInteger)points;
- (instancetype)initWithPoints:(NSInteger)points;

// -----------------------------------------------------------------

@end




