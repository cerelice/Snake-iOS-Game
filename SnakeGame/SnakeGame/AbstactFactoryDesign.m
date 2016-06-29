//
//  AbstactFactoryDesign.m
//  SnakeGame
//
//  Created by Admin on 2/17/16.
//  Copyright © 2016 Interlogic. All rights reserved.
//

#import "AbstactFactoryDesign.h"

static AbstactFactoryDesign *sharedObject = nil;
NSString * const ThemeKey = @"Theme";
static NSUserDefaults *_userDefaults = nil;

@implementation FactoryDesign

+ (AbstactFactoryDesign*)sharedObject
{
    return sharedObject;
}

+ (AbstactFactoryDesign*)sharedInstance {
    static dispatch_once_t pred;
    //static AbstactFactoryDesign *sharedObject = nil;
    if (sharedObject) { return sharedObject; }
    dispatch_once(&pred, ^{
        NSString *className = [[AbstactFactoryDesign userDefaults] stringForKey:NSStringFromSelector(@selector(sharedInstance))];
        Class designClass = NSClassFromString(className);
        if(designClass) {
            sharedObject = [designClass new];
        } else {
            [FactoryDesign setSharedInstanceWithDesign:[MidnightDesertFactoryDesign new]];
        }
        //sharedObject = [MidnightDesertFactoryDesign new];
    });
    return sharedObject;
}

+ (void)setSharedInstanceWithDesign:(AbstactFactoryDesign*)design {
    sharedObject = design;
    NSString *key = NSStringFromSelector(@selector(sharedInstance));
    NSString *className = NSStringFromClass([design class]);
    [[AbstactFactoryDesign userDefaults] setObject:className forKey:key];
    [[AbstactFactoryDesign userDefaults] synchronize];
}

@end

@implementation AbstactFactoryDesign

#pragma mark - Accessors

+ (NSUserDefaults *)userDefaults
{
    if (!_userDefaults) _userDefaults = [NSUserDefaults standardUserDefaults];
    return _userDefaults;
}

- (NSArray*)factoryDesigns
{
    if(!_factoryDesigns) {
        _factoryDesigns = @[@"SeaFactoryDesign", @"ForrestFactoryDesign", @"StrawberryFactoryDesign", @"PlumFactoryDesign", @"PeachFactoryDesign", @"MidnightDesertFactoryDesign"];
    }
    return _factoryDesigns;
}

- (NSArray*)factoryDesignsClasses
{
    if(!_factoryDesignsClasses) {
        _factoryDesignsClasses = @[[SeaFactoryDesign class],
                                   [ForrestFactoryDesign class],
                                   [StrawberryFactoryDesign class],
                                   @"PlumFactoryDesign",
                                   @"PeachFactoryDesign",
                                   @"MidnightDesertFactoryDesign"];
    }
    return _factoryDesignsClasses;
}

@end

@implementation SeaFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0x2EFF69);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0x2EFFF5);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0x20B2AA);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0x20B34A);
}

@end

@implementation ForrestFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0x64FA96);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0x91F065);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0xEF8575);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0x64A345);
}

@end

@implementation StrawberryFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0x7BB526);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0xEF8575);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0xF32c22);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0x7BB526);
}

@end

@implementation PlumFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0x916991);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0xDDA0DD);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0x912F70);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0xDE47AC);
}

@end

@implementation PeachFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0xF08080);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0xF0B77F);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0xA35656);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0xA37D56);
}

@end

@implementation MidnightDesertFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0x8C789F);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0xA4BCBC);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0x4C3F77);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0x007F97);
}

@end

@implementation VioletFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0x8C789F);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0xFCA4BE);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0x59B8BA);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0x007F97);
}

@end

@implementation LavengerFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0xBEA4D2);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0xBDCCFF);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0x4C3F77);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0x007F97);
}

@end

@implementation WinterFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0x92E2E9);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0xB9E8F0);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0x59B8BA);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0x329C98);
}

@end

@implementation BlueBerryFactoryDesign

-(UIColor*)headColor
{
    return UIColorFromRGB(0x59B8BA);
}

-(UIColor*)tailColor
{
    return UIColorFromRGB(0xB9E8F0);
}

-(UIColor*)foodColor
{
    return UIColorFromRGB(0xE40445);
}

-(UIColor*)wallColor
{
    return UIColorFromRGB(0x329C98);
}

@end
