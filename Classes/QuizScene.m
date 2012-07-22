//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "QuizScene.h"

@implementation QuizScene
@synthesize layer = _layer;

- (id)init {
    
	if ((self = [super init])) {
		self.layer = [QuizLayer node];
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

@implementation QuizLayer
@synthesize oneLevel;
@synthesize booster;
@synthesize gameState;
CCParticleExplosion* parc;
CCSprite *wrong;
-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 75, 75)];
		[self addChild:oneLevel];
        oneLevel.position = ccp(winSize.width/4, winSize.height/2);
        
        wrong = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(0, 0, 75, 75)];
		[self addChild:wrong];
        wrong.position = ccp(winSize.width/1.5, winSize.height/2);
        
	}	
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([gameState state]==1){
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        CGRect rect=oneLevel.boundingBox;
        if (CGRectContainsPoint(rect,location)) {
            [gameState setBoost:60];
        rect=wrong.boundingBox;
        }else if (CGRectContainsPoint(wrong.boundingBox,location)) {
            [gameState setBoost:-10];
        }
        [gameState setState:0];
    }
}

@end
