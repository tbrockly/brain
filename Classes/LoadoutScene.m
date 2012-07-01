//
//  LoadoutScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadoutScene.h"
#import "GameScene.h"

@implementation LoadoutScene
@synthesize layer = _layer;

- (id)init {
    
	if ((self = [super init])) {
		self.layer = [LoadoutLayer node];
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

@implementation LoadoutLayer
@synthesize readyButton;
-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		readyButton = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		readyButton.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:readyButton];
		
	}	
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    CGRect launcherRect = CGRectMake(readyButton.position.x - (readyButton.contentSize.width/2), 
                                     readyButton.position.y - (readyButton.contentSize.height/2), 
                                     readyButton.contentSize.width, 
                                     readyButton.contentSize.height);
    if (CGRectContainsPoint(launcherRect,location)) {
        NSMutableArray *monsters=[[NSMutableArray alloc] init];
        NSMutableArray *weapons=[[NSMutableArray alloc] init];
        [[CCDirector sharedDirector] replaceScene:[GameScene initNode:monsters weapons:weapons]];
    }
    
}
@end