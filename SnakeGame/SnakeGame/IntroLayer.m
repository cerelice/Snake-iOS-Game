//
//  IntroLayer.m
//  Cocos2d and Storyboards and ARC template
//
//  Created by Oscar Apeland on 08.08.13.
//  Copyright Oscar Apeland 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldScene.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	//CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	//IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	//[scene addChild: layer];
	
	// return the scene
	return [[self alloc] init];
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] viewSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithImageNamed:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithImageNamed:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene] withTransition:[CCTransition transitionFadeWithDuration:1.0]];
}
@end
