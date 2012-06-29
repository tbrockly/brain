//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectScene.h"
#import "LoadoutScene.h"

@implementation LevelSelectScene
@synthesize layer = _layer;

- (id)init {
    
	if ((self = [super init])) {
		self.layer = [LevelSelectLayer node];
		[self addChild:_layer];
	}
	return self;
}

- (void)dealloc {
	[_layer release];
	_layer = nil;
	[super dealloc];
}

@end

@implementation LevelSelectLayer
@synthesize oneLevel;
-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 75, 75)];
		oneLevel.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:oneLevel];
		
	}	
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    CGRect launcherRect = CGRectMake(oneLevel.position.x - (oneLevel.contentSize.width/2), 
                                     oneLevel.position.y - (oneLevel.contentSize.height/2), 
                                     oneLevel.contentSize.width, 
                                     oneLevel.contentSize.height);
    if (CGRectContainsPoint(launcherRect,location)) {
        [[CCDirector sharedDirector] replaceScene:[LoadoutScene node]];
    }
    
}

@end
