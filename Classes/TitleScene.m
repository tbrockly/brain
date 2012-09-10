//
//  TitleScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"

@implementation TitleScene
@synthesize layer = _layer;

- (id)init {
    
	if ((self = [super init])) {
		self.layer = [TitleLayer node];
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

@implementation TitleLayer
@synthesize onePlayer;
-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		onePlayer = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		onePlayer.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:onePlayer];
		
	}	
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    CGRect launcherRect = CGRectMake(onePlayer.position.x - (onePlayer.contentSize.width/2), 
                                         onePlayer.position.y - (onePlayer.contentSize.height/2), 
                                         onePlayer.contentSize.width, 
                                         onePlayer.contentSize.height);
    if (CGRectContainsPoint(launcherRect,location)) {
        [[CCDirector sharedDirector] replaceScene:[GameScene initNode]];
    }

}

@end
