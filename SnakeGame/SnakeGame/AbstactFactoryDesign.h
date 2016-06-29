//
//  AbstactFactoryDesign.h
//  SnakeGame
//
//  Created by Admin on 2/17/16.
//  Copyright © 2016 Interlogic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
    blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
    alpha:1.0]

@interface AbstactFactoryDesign : NSObject

@property(strong, nonatomic, readonly) UIColor *headColor;
@property(strong, nonatomic, readonly) UIColor *tailColor;
@property(strong, nonatomic, readonly) UIColor *foodColor;
@property(strong, nonatomic, readonly) UIColor *wallColor;

@property (strong, nonatomic) NSArray *factoryDesigns;
@property (strong, nonatomic) NSArray *factoryDesignsClasses;
+ (NSUserDefaults *)userDefaults;

@end

@interface FactoryDesign : NSObject

+ (AbstactFactoryDesign*)sharedInstance;
+ (void)setSharedInstanceWithDesign:(AbstactFactoryDesign*)design;

@end

@interface SeaFactoryDesign : AbstactFactoryDesign

@end

@interface ForrestFactoryDesign : AbstactFactoryDesign

@end

@interface StrawberryFactoryDesign : AbstactFactoryDesign

@end

@interface PlumFactoryDesign : AbstactFactoryDesign

@end

@interface PeachFactoryDesign : AbstactFactoryDesign

@end

@interface MidnightDesertFactoryDesign : AbstactFactoryDesign

@end

@interface VioletFactoryDesign : AbstactFactoryDesign

@end

@interface LavengerFactoryDesign : AbstactFactoryDesign

@end

@interface WinterFactoryDesign : AbstactFactoryDesign

@end

@interface BlueBerryFactoryDesign : AbstactFactoryDesign

@end