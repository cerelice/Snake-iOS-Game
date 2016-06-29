//
//  HelloWorldScene.m
//
//  Created by : Admin
//  Project    : SnakeGame
//  Date       : 2/16/16
//
//  Copyright (c) 2016 Interlogic.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HelloWorldScene.h"
#import "GameOverScene.h"
#import "AbstactFactoryDesign.h"

NSInteger const SnakeItemSize = 10;

// -----------------------------------------------------------------------

@implementation HelloWorldScene

// -----------------------------------------------------------------------

+(CCScene *) scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    /*
    headColor = [CCColor colorWithUIColor:UIColorFromRGB(0x66FF66)];
    tailColor = [CCColor colorWithUIColor:UIColorFromRGB(0x66FFCC)];
    foodColor = [CCColor colorWithUIColor:UIColorFromRGB(0xFF6666)];
    wallColor = [CCColor colorWithUIColor:UIColorFromRGB(0x169E38)];
    */
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    
    // Background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;
    background.contentSize = [CCDirector sharedDirector].viewSize;
    background.color = [CCColor grayColor];
    [self addChild:background];
    
    //Game Board
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    int width = viewSize.width;
    int height = viewSize.height;
    width = (width / SnakeItemSize) * SnakeItemSize;
    height = (height / SnakeItemSize) * SnakeItemSize;
    _gameBoardSize = CGSizeMake(width, height - 2 * SnakeItemSize);
    _gameBoardPosition = ccp(
                             (viewSize.width - _gameBoardSize.width)/2,
                             (viewSize.height - _gameBoardSize.height)/2
                            );
    
    CCSprite9Slice *gameBoard = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    gameBoard.anchorPoint = CGPointZero;
    gameBoard.contentSize = _gameBoardSize;
    gameBoard.color = [CCColor whiteColor];
    gameBoard.position = _gameBoardPosition;
    
    [self addChild:gameBoard];

    [self drawWalls];

    [self drawSnakeWithLength:5];
    
    [self drawStartFoodItemsWithCount:10];
    
    self.direction = SnakeDirectionDown;
    
    UISwipeGestureRecognizer* swipeLeftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    swipeLeftGR.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [[UIApplication sharedApplication].delegate.window addGestureRecognizer:swipeLeftGR];
    
    UISwipeGestureRecognizer* swipeRightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    swipeRightGR.direction = UISwipeGestureRecognizerDirectionRight;
    
    [[UIApplication sharedApplication].delegate.window addGestureRecognizer:swipeRightGR];
    
    UISwipeGestureRecognizer* swipeUpGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGR.direction = UISwipeGestureRecognizerDirectionUp;
    
    [[UIApplication sharedApplication].delegate.window addGestureRecognizer:swipeUpGR];
    
    UISwipeGestureRecognizer* swipeDownGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGR.direction = UISwipeGestureRecognizerDirectionDown;
    
    [[UIApplication sharedApplication].delegate.window addGestureRecognizer:swipeDownGR];
    
    speed = 0.5f;
    
    _timer = [self schedule:@selector(gameLogic) interval:speed];
    
    int backgroundHeight = _gameBoardPosition.y;
    
    CGPoint rectPoints[4] = {
        CGPointMake(0.0f, 0.0f),
        CGPointMake(0.0f, backgroundHeight),
        CGPointMake(viewSize.width, backgroundHeight),
        CGPointMake(viewSize.width, 0.0f)
    };
    CCDrawNode *progressBarBackground = [CCDrawNode node];
    [self addChild:progressBarBackground];
    progressBarBackground.anchorPoint = CGPointZero;
    progressBarBackground.position = CGPointMake(0, 0);
    progressBarBackground.contentSize = CGSizeMake(viewSize.width, backgroundHeight);
    [progressBarBackground drawPolyWithVerts:rectPoints
                             count:4
                         fillColor:[CCColor whiteColor]
                       borderWidth:1.0f
                       borderColor:[CCColor grayColor]];
    
    progressBar = [CCDrawNode node];
    [self addChild:progressBar];
    progressBar.anchorPoint = CGPointZero;
    progressBar.position = CGPointMake(0, 0);
    progressBar.contentSize = CGSizeMake(viewSize.width, SnakeItemSize);
    [progressBar drawPolyWithVerts:rectPoints
                          count:4
                      fillColor:[CCColor colorWithUIColor:[FactoryDesign sharedInstance].foodColor]
                    borderWidth:0.0f
                    borderColor:[CCColor whiteColor]];
    CCActionScaleTo *scaleAnim = [CCActionScaleTo actionWithDuration:0.0f scaleX:0 scaleY:1.0f];
    [progressBar runAction:scaleAnim];
    
    CCDrawNode *historyBarBackground = [CCDrawNode node];
    [self addChild:historyBarBackground];
    historyBarBackground.anchorPoint = CGPointZero;
    historyBarBackground.position = CGPointMake(0, _gameBoardPosition.y + _gameBoardSize.height);
    historyBarBackground.contentSize = CGSizeMake(viewSize.width, backgroundHeight);
    [historyBarBackground drawPolyWithVerts:rectPoints
                                       count:4
                                   fillColor:[CCColor whiteColor]
                                 borderWidth:1.0f
                                 borderColor:[CCColor grayColor]];
    _history = [NSMutableArray new];
    _bonuses = [NSMutableArray new];
    _speedBonuses = [NSMutableArray new];
    
    return self;
}

// -----------------------------------------------------------------------

- (void)drawStartFoodItemsWithCount:(NSInteger)count
{
    _foods = [NSMutableArray new];
    for(int i = 0; i < count; i++) {
        [self drawFoodItem];
    }
}

- (void)showBonusProgress
{
    progressBar.contentSize = CGSizeMake(_gameBoardSize.width, SnakeItemSize);
    CCActionCallBlock * speedBonusIsDone = [CCActionCallBlock actionWithBlock:^ {
        speed *= 2;
        [self schedule:@selector(gameLogic) interval:speed];
    }];
    CCActionScaleTo *refreshBar = [CCActionScaleTo actionWithDuration:0.0f scaleX:1.0f scaleY:1.0f];
    CCActionScaleTo *scaleAnim = [CCActionScaleTo actionWithDuration:15.0f scaleX:0 scaleY:1.0f];
    [progressBar runAction:[CCActionSequence actions:refreshBar, scaleAnim, speedBonusIsDone, nil]];
}

- (void)drawSnakeWithLength:(NSInteger)length
{
    _snake = [NSMutableArray new];
    int xDelta = ((int)_gameBoardSize.width / 2 / SnakeItemSize) * SnakeItemSize;
    int yDelta = ((int)_gameBoardSize.height / 2 / SnakeItemSize) * SnakeItemSize;
    CGPoint location = ccp(xDelta + _gameBoardPosition.x,
                           yDelta + _gameBoardPosition.y);
    CGPoint rectPoints[4] = {
        CGPointMake(0.0f, 0.0f),
        CGPointMake(0.0f, SnakeItemSize),
        CGPointMake(SnakeItemSize, SnakeItemSize),
        CGPointMake(SnakeItemSize, 0.0f)
    };
    
    CCDrawNode *head = [CCDrawNode node];
    [self addChild:head];
    head.anchorPoint = CGPointZero;
    head.position = CGPointMake(location.x, location.y);
    head.contentSize = CGSizeMake(SnakeItemSize, SnakeItemSize);
    [head drawPolyWithVerts:rectPoints
                      count:4
                  fillColor:[CCColor colorWithUIColor:[FactoryDesign sharedInstance].headColor]
                borderWidth:1.0f
                borderColor:[CCColor whiteColor]];
    [_snake addObject:head];
    
    for(int i = 1; i < length; i++) {
        [self snakeGrow];
    }
}

- (void)pause {
    _timer.paused = YES;
}

- (void)drawFoodItem {
    int xCellsCount = _gameBoardSize.width / SnakeItemSize;
    int yCellsCount = _gameBoardSize.height / SnakeItemSize;
    int xDelta = arc4random_uniform(xCellsCount) * SnakeItemSize;
    int yDelta = arc4random_uniform(yCellsCount) * SnakeItemSize;
    CGPoint foodPosition = ccp(xDelta + _gameBoardPosition.x,
                               yDelta + _gameBoardPosition.y);
    while([self checkForFoodCollisionWithPoint:foodPosition] ||
          [self checkForSnakeCollisionWithPoint:foodPosition] ||
          [self checkForWallCollisionWithPoint:foodPosition]) {
        xDelta = arc4random_uniform(xCellsCount) * SnakeItemSize;
        yDelta = arc4random_uniform(yCellsCount) * SnakeItemSize;
        foodPosition = ccp(xDelta + _gameBoardPosition.x,
                                   yDelta + _gameBoardPosition.y);
    }
    CGPoint rectPoints[4] = {
        CGPointMake(0.0f, 0.0f),
        CGPointMake(0.0f, SnakeItemSize),
        CGPointMake(SnakeItemSize, SnakeItemSize),
        CGPointMake(SnakeItemSize, 0.0f)
    };
    
    CCDrawNode *foodItem = [CCDrawNode node];
    [self addChild:foodItem];
    foodItem.anchorPoint = CGPointZero;
    foodItem.position = CGPointMake(foodPosition.x, foodPosition.y);
    foodItem.contentSize = CGSizeMake(SnakeItemSize, SnakeItemSize);
    [foodItem drawPolyWithVerts:rectPoints
                          count:4
                      fillColor:[CCColor colorWithUIColor:[FactoryDesign sharedInstance].foodColor]
                    borderWidth:1.0f
                    borderColor:[CCColor whiteColor]];
    [_foods addObject:foodItem];
}

- (void)drawBonusItem {
    int xCellsCount = _gameBoardSize.width / SnakeItemSize;
    int yCellsCount = _gameBoardSize.height / SnakeItemSize;
    int xDelta = arc4random_uniform(xCellsCount) * SnakeItemSize;
    int yDelta = arc4random_uniform(yCellsCount) * SnakeItemSize;
    CGPoint bonusPosition = ccp(xDelta + _gameBoardPosition.x,
                               yDelta + _gameBoardPosition.y);
    while([self checkForFoodCollisionWithPoint:bonusPosition] ||
          [self checkForSnakeCollisionWithPoint:bonusPosition] ||
          [self checkForWallCollisionWithPoint:bonusPosition]) {
        xDelta = arc4random_uniform(xCellsCount) * SnakeItemSize;
        yDelta = arc4random_uniform(yCellsCount) * SnakeItemSize;
        bonusPosition = ccp(xDelta + _gameBoardPosition.x,
                           yDelta + _gameBoardPosition.y);
    }
    CGPoint rectPoints[4] = {
        CGPointMake(0.0f, 0.0f),
        CGPointMake(0.0f, SnakeItemSize),
        CGPointMake(SnakeItemSize, SnakeItemSize),
        CGPointMake(SnakeItemSize, 0.0f)
    };
    
    CCDrawNode *bonusItem = [CCDrawNode node];
    [self addChild:bonusItem];
    bonusItem.anchorPoint = CGPointZero;
    bonusItem.position = bonusPosition;
    bonusItem.contentSize = CGSizeMake(SnakeItemSize, SnakeItemSize);
    [bonusItem drawPolyWithVerts:rectPoints
                          count:4
                      fillColor:[CCColor yellowColor]
                    borderWidth:1.0f
                    borderColor:[CCColor whiteColor]];
    [_bonuses addObject:bonusItem];
}

- (void)drawSpeedUpBonusItem {
    int xCellsCount = _gameBoardSize.width / SnakeItemSize;
    int yCellsCount = _gameBoardSize.height / SnakeItemSize;
    int xDelta = arc4random_uniform(xCellsCount) * SnakeItemSize;
    int yDelta = arc4random_uniform(yCellsCount) * SnakeItemSize;
    CGPoint bonusPosition = ccp(xDelta + _gameBoardPosition.x,
                                yDelta + _gameBoardPosition.y);
    while([self checkForFoodCollisionWithPoint:bonusPosition] ||
          [self checkForSnakeCollisionWithPoint:bonusPosition] ||
          [self checkForWallCollisionWithPoint:bonusPosition]) {
        xDelta = arc4random_uniform(xCellsCount) * SnakeItemSize;
        yDelta = arc4random_uniform(yCellsCount) * SnakeItemSize;
        bonusPosition = ccp(xDelta + _gameBoardPosition.x,
                            yDelta + _gameBoardPosition.y);
    }
    CGPoint rectPoints[4] = {
        CGPointMake(0.0f, 0.0f),
        CGPointMake(0.0f, SnakeItemSize),
        CGPointMake(SnakeItemSize, SnakeItemSize),
        CGPointMake(SnakeItemSize, 0.0f)
    };
    
    CCDrawNode *bonusItem = [CCDrawNode node];
    [self addChild:bonusItem];
    bonusItem.anchorPoint = CGPointZero;
    bonusItem.position = bonusPosition;
    bonusItem.contentSize = CGSizeMake(SnakeItemSize, SnakeItemSize);
    [bonusItem drawPolyWithVerts:rectPoints
                           count:4
                       fillColor:[CCColor redColor]
                     borderWidth:1.0f
                     borderColor:[CCColor whiteColor]];
    [_speedBonuses addObject:bonusItem];
}

- (void)drawWalls {
    _walls = [NSMutableArray new];
    
    int xCellsCount = _gameBoardSize.width / SnakeItemSize;
    int yCellsCount = _gameBoardSize.height / SnakeItemSize;
    for(int i = 0; i < xCellsCount; i++) {
        CGPoint topWallPosition = ccp(_gameBoardPosition.x + i * SnakeItemSize,
                                      _gameBoardPosition.y + _gameBoardSize.height - SnakeItemSize);
        [self drawWallItemWithPosition:topWallPosition];
        CGPoint bottomWallPosition = ccp(_gameBoardPosition.x + i * SnakeItemSize,
                                      _gameBoardPosition.y);
        [self drawWallItemWithPosition:bottomWallPosition];
    }
    for(int i = 1; i < yCellsCount - 1; i++) {
        CGPoint rightWallPosition = ccp(_gameBoardPosition.x + _gameBoardSize.width - SnakeItemSize,
                                        _gameBoardPosition.y + i * SnakeItemSize);
        [self drawWallItemWithPosition:rightWallPosition];
        CGPoint leftWallPosition = ccp(_gameBoardPosition.x,
                                       _gameBoardPosition.y + i * SnakeItemSize);
        [self drawWallItemWithPosition:leftWallPosition];
    }
}

- (void)drawWallItemWithPosition:(CGPoint)position {

    CGPoint rectPoints[4] = {
        CGPointMake(0.0f, 0.0f),
        CGPointMake(0.0f, SnakeItemSize),
        CGPointMake(SnakeItemSize, SnakeItemSize),
        CGPointMake(SnakeItemSize, 0.0f)
    };
    
    CCDrawNode *wallItem = [CCDrawNode node];
    [self addChild:wallItem z:16];
    wallItem.anchorPoint = CGPointZero;
    wallItem.position = position;
    wallItem.contentSize = CGSizeMake(SnakeItemSize, SnakeItemSize);
    [wallItem drawPolyWithVerts:rectPoints
                          count:4
                      fillColor:[CCColor colorWithUIColor:[FactoryDesign sharedInstance].wallColor]
                    borderWidth:0.0f
                    borderColor:[CCColor whiteColor]];
    [_walls addObject:wallItem];
}

- (BOOL)checkForFoodCollisionWithPoint:(CGPoint)point
{
    for (CCDrawNode *food in _foods) {
        if(CGPointEqualToPoint(food.position, point)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkForSnakeCollisionWithPoint:(CGPoint)point
{
    for (CCDrawNode *snakeItem in _snake) {
        if(snakeItem == [_snake firstObject]) {
            continue;
        }
        if(CGPointEqualToPoint(snakeItem.position, point)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkForWallCollisionWithPoint:(CGPoint)point
{
    for (CCDrawNode *wall in _walls) {
        if(CGPointEqualToPoint(wall.position, point)) {
            return YES;
        }
    }
    return NO;
}

- (CCDrawNode*)foodCollisionItemWithPoint:(CGPoint)point
{
    for (CCDrawNode *food in _foods) {
        if(CGPointEqualToPoint(food.position, point)) {
            return food;
        }
    }
    return nil;
}

- (CCDrawNode*)bonusCollisionItemWithPoint:(CGPoint)point
{
    for (CCDrawNode *bonus in _bonuses) {
        if(CGPointEqualToPoint(bonus.position, point)) {
            return bonus;
        }
    }
    return nil;
}

- (CCDrawNode*)speedBonusCollisionItemWithPoint:(CGPoint)point
{
    for (CCDrawNode *bonus in _speedBonuses) {
        if(CGPointEqualToPoint(bonus.position, point)) {
            return bonus;
        }
    }
    return nil;
}

- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    self.direction = SnakeDirectionLeft;
    CCLOG(@"Swipe Left which is down");
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    self.direction = SnakeDirectionRight;
    CCLOG(@"Swipe Right which is down");
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    self.direction = SnakeDirectionUp;
    CCLOG(@"Swipe Up which is down");
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    self.direction = SnakeDirectionDown;
    CCLOG(@"Swipe Down which is down");
}

- (void)drawBonus
{
    if(arc4random_uniform(2) == 1) {
        [self drawBonusItem];
    } else {
        [self drawSpeedUpBonusItem];
    }
}

- (void)gameLogic {
    [self snakeMove];
    CCDrawNode *head = [_snake firstObject];
    CCDrawNode *foodCollision = [self foodCollisionItemWithPoint:head.position];
    if(foodCollision) {
        _points++;
        if(_points % 3 == 0) {
            [self drawBonus];
            speed *= 0.9;
            [self schedule:@selector(gameLogic) interval:speed];
        }
        [self snakeGrow];
        [self removeChild:foodCollision cleanup:YES];
        [_foods removeObject:foodCollision];
        [self drawFoodItem];
        [self newItemInHistoryWithColor:[CCColor colorWithUIColor:[FactoryDesign sharedInstance].foodColor]];
    }
    CCDrawNode *bonusCollision = [self bonusCollisionItemWithPoint:head.position];
    if(bonusCollision) {
        _points += 5;
        [self removeChild:bonusCollision cleanup:YES];
        [_bonuses removeObject:bonusCollision];
        [self newItemInHistoryWithColor:[CCColor yellowColor]];

    }
    CCDrawNode *speedCollision = [self speedBonusCollisionItemWithPoint:head.position];
    if(speedCollision) {
        speed /= 2;
        [self schedule:@selector(gameLogic) interval:speed];
        [self showBonusProgress];
        [self removeChild:speedCollision cleanup:YES];
        [_speedBonuses removeObject:speedCollision];
        [self newItemInHistoryWithColor:[CCColor redColor]];
    }
    if([self checkForSnakeCollisionWithPoint:head.position]) {
        [[CCDirector sharedDirector] replaceScene:[GameOverScene sceneWithPoints:_points]];
    }
    if([self checkForWallCollisionWithPoint:head.position]) {
        [[CCDirector sharedDirector] replaceScene:[GameOverScene sceneWithPoints:_points]];
    }
}

- (void)snakeMove {
    CCDrawNode *head = [_snake firstObject];
    CCDrawNode *tail = [_snake lastObject];
    CGPoint headPosition = head.position;
    CGPoint newHeadPosition = headPosition;
    switch (self.direction) {
        case SnakeDirectionUp:
            newHeadPosition.y += SnakeItemSize;
            break;
        case SnakeDirectionDown:
            newHeadPosition.y -= SnakeItemSize;
            break;
        case SnakeDirectionLeft:
            newHeadPosition.x -= SnakeItemSize;
            break;
        case SnakeDirectionRight:
            newHeadPosition.x += SnakeItemSize;
            break;
    }
    
    if(newHeadPosition.x < _gameBoardPosition.x) {
        newHeadPosition.x = _gameBoardSize.width + _gameBoardPosition.x - SnakeItemSize;
    }
    if(newHeadPosition.x > _gameBoardSize.width + _gameBoardPosition.x - SnakeItemSize) {
        newHeadPosition.x = _gameBoardPosition.x;
    }
    if(newHeadPosition.y < _gameBoardPosition.y) {
        newHeadPosition.y = _gameBoardSize.height + _gameBoardPosition.y - SnakeItemSize;
    }
    if(newHeadPosition.y > _gameBoardSize.height + _gameBoardPosition.y - SnakeItemSize) {
        newHeadPosition.y = _gameBoardPosition.y;
    }
    
    tail.position = headPosition;
    [_snake removeObject:tail];
    [_snake insertObject:tail atIndex:1];
    head.position = newHeadPosition;
    //[head runAction:[CCActionMoveBy actionWithDuration:1.0f position:ccp(20, 0)]];
}

- (void)newItemInHistoryWithColor:(CCColor*)color
{
    CCDrawNode *lastItem = [_history lastObject];
    CGPoint itemPosition;
    CGPoint rectPoints[4] = {
        CGPointMake(0.0f, 0.0f),
        CGPointMake(0.0f, SnakeItemSize-1),
        CGPointMake(SnakeItemSize, SnakeItemSize-1),
        CGPointMake(SnakeItemSize, 0.0f)
    };
    
    if(!lastItem) {
        itemPosition = ccp(_gameBoardPosition.x, _gameBoardPosition.y + _gameBoardSize.height + 1);
    } else {
        if(lastItem.position.x + SnakeItemSize >= _gameBoardSize.width + _gameBoardPosition.x) {
            for(int i = (int)_history.count - 1; i >= 1; i--) {
                CCDrawNode *currentNode = _history[i];
                CCDrawNode *previousNode = _history[i-1];
                currentNode.position = previousNode.position;
            }
            [_history removeObjectAtIndex:0];
        }
        itemPosition = ccp(lastItem.position.x + SnakeItemSize, lastItem.position.y);
    }
    
    CCDrawNode *historyItem = [CCDrawNode node];
    [self addChild:historyItem];
    historyItem.anchorPoint = CGPointZero;
    historyItem.position = itemPosition;
    historyItem.contentSize = CGSizeMake(SnakeItemSize, SnakeItemSize);
    [historyItem drawPolyWithVerts:rectPoints
                          count:4
                      fillColor:color
                    borderWidth:1.0f
                    borderColor:[CCColor whiteColor]];
    [_history addObject:historyItem];

}

- (void)snakeGrow
{
    int xDelta = 0;
    int yDelta = 0;
    switch (self.direction) {
        case SnakeDirectionUp:
            yDelta = -SnakeItemSize;
            break;
        case SnakeDirectionDown:
            yDelta = SnakeItemSize;
            break;
        case SnakeDirectionLeft:
            xDelta = SnakeItemSize;
            break;
        case SnakeDirectionRight:
            xDelta = -SnakeItemSize;
            break;
    }
    
    CGPoint rectPoints[4] = {
        CGPointMake(0.0f, 0.0f),
        CGPointMake(0.0f, SnakeItemSize),
        CGPointMake(SnakeItemSize, SnakeItemSize),
        CGPointMake(SnakeItemSize, 0.0f)
    };
    
    CCDrawNode *tail = [_snake lastObject];
    CCDrawNode *snakeItem = [CCDrawNode node];
    [self addChild:snakeItem];
    snakeItem.anchorPoint = CGPointZero;
    snakeItem.position = CGPointMake(tail.position.x + xDelta, tail.position.y + yDelta);
    snakeItem.contentSize = CGSizeMake(SnakeItemSize, SnakeItemSize);
    [snakeItem drawPolyWithVerts:rectPoints
                           count:4
                       fillColor:[CCColor colorWithUIColor:[FactoryDesign sharedInstance].tailColor]
                     borderWidth:1.0f
                     borderColor:[CCColor whiteColor]];
    [_snake addObject:snakeItem];
}

-(void)setDirection:(SnakeDirection)direction
{
    if(!((direction == SnakeDirectionLeft && _direction == SnakeDirectionRight) ||
       (direction == SnakeDirectionRight && _direction == SnakeDirectionLeft) ||
       (direction == SnakeDirectionDown && _direction == SnakeDirectionUp) ||
       (direction == SnakeDirectionUp && _direction == SnakeDirectionDown))) {
        _direction = direction;
    }
}

@end























// why not add a few extra lines, so we dont have to sit and edit at the bottom of the screen ...
