//
//  TitleScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import "ShopLayer.h"
#import "Powerup.h"
#import "Boost.h"
#import "Rocket.h"
#import "Spin.h"
#import "PCoin.h"
#import "Bonus.h"
#import "Quiz.h"
#import "Ride.h"
#import "Energy.h"

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
@synthesize onePlayer, shopSprite, gameState;
-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        gameState=[[GameState alloc] init];
        [gameState setState:10];
        gameState.powerups=[[NSMutableArray alloc] init];
        Boost *boostPow=[[Boost alloc] initSelf];
        boostPow.position=ccp(-1000,50);
        [gameState.powerups addObject:boostPow];
        
        Ride *ridePow=[[Ride alloc] initSelf];
        ridePow.position=ccp(-1000,50);
        [gameState.powerups addObject:ridePow];
        
        Quiz *quizPow=[[Quiz alloc] initSelf];
        quizPow.position=ccp(-1000,50);
        [gameState.powerups addObject:quizPow];
        
        Spin *spinPow=[[Spin alloc] initSelf];
        spinPow.position=ccp(-1000,50);
        [gameState.powerups addObject:spinPow];
        
        PCoin *coinPow=[[PCoin alloc] initSelf];
        coinPow.position=ccp(-1000,50);
        [gameState.powerups addObject:coinPow];
        
        Energy *energy=[[Energy alloc] initSelf];
        energy.position=ccp(-1000,50);
        [gameState.powerups addObject:energy];
        
        Bonus *bonusPow=[[Bonus alloc] initSelf];
        bonusPow.position=ccp(-1000,50);
        [gameState.powerups addObject:bonusPow];
        
        Rocket *rocketPow=[[Rocket alloc] initSelf];
        rocketPow.position=ccp(-1000,50);
        [gameState.powerups addObject:rocketPow];
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		onePlayer = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		onePlayer.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:onePlayer];
		shopSprite = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		[self addChild:shopSprite];
	}	
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
    if([gameState state] ==10){
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        if (CGRectContainsPoint(onePlayer.boundingBox,location)) {
            [[CCDirector sharedDirector] pushScene:[GameScene initNode:gameState]];
        }
        if (CGRectContainsPoint(shopSprite.boundingBox,location)) {
            //[gameState setState:-10];
            ShopLayer *q = [[ShopLayer alloc] init:gameState];
            self.isTouchEnabled=NO;
            [q setParentLayer:self];
            [self.parent addChild:q z:10];
        }
    }

}

@end
