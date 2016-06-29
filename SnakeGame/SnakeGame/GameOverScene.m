//
//  GameOverScene.m
//
//  Created by : Admin
//  Project    : SnakeGame
//  Date       : 2/16/16
//
//  Copyright (c) 2016 Interlogic.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameOverScene.h"
#import "HelloWorldScene.h"

// -----------------------------------------------------------------

@implementation GameOverScene

// -----------------------------------------------------------------

+ (CCScene*)sceneWithPoints:(NSInteger)points
{
    return [[self alloc] initWithPoints:points];
}

- (instancetype)initWithPoints:(NSInteger)points
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    CCLabelTTF * label = [CCLabelTTF labelWithString:@"Game over" fontName:@"Arial" fontSize:18];
    label.color = [CCColor whiteColor];
    label.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:label];
    
    NSString *result = [NSString stringWithFormat:@"Points: %ld", (long)points];
    
    CCLabelTTF * resultLabel = [CCLabelTTF labelWithString:result fontName:@"Arial" fontSize:14];
    resultLabel.color = [CCColor whiteColor];
    resultLabel.position = ccp(winSize.width / 2, label.position.y - 20);
    [self addChild:resultLabel];
    
    [self runAction:
     [CCActionSequence actions:
      [CCActionDelay actionWithDuration:3],
      [CCActionCallBlock actionWithBlock:^{
         [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]];
     }],
      nil]];
    
    return self;
}

// -----------------------------------------------------------------

@end





