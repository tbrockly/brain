//
//  TitleScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import "ShopHome.h"
#import "Powerup.h"
#import "Boost.h"
#import "Rocket.h"
#import "Spin.h"
#import "PCoin.h"
#import "Bonus.h"
#import "Quiz.h"
#import "Ride.h"
#import "Energy.h"
#import "Cloud.h"
#import "Shield.h"
#import "BounceShield.h"
#import "BoostShield.h"
#import "CoinShield.h"
#import "RollShield.h"
#import "GravityParam.h"
#import "FrictionParam.h"
#import "BounceParam.h"

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
        NSUserDefaults *defaults2=[NSUserDefaults standardUserDefaults];
        
        [defaults2 setInteger:0 forKey:@"version"];
        if([defaults2 integerForKey:@"version"] <1){
            [defaults2 setInteger:1 forKey:@"version"];
            [defaults2 setInteger:1 forKey:@"level"];
            [defaults2 setInteger:0 forKey:@"curxp"];
            [defaults2 setInteger:50 forKey:@"tonext"];
            [defaults2 setInteger:1 forKey:@"airResist"];
            [defaults2 setInteger:1 forKey:@"enemyFreq"];
            [defaults2 setInteger:1 forKey:@"quizFreq"];
            [defaults2 setInteger:1 forKey:@"enemyBoost"];
            [defaults2 setInteger:1 forKey:@"quizBoost"];
            [defaults2 setInteger:1 forKey:@"WorldGravity"];
            [defaults2 setInteger:1 forKey:@"WorldFriction"];
            [defaults2 setInteger:1 forKey:@"WorldBounce"];
            [defaults2 setInteger:1 forKey:@"friction"];
            [defaults2 setInteger:1 forKey:@"quizDifficulty"];
            [defaults2 setInteger:1 forKey:@"topSpeed"];
            [defaults2 setInteger:4 forKey:@"charge"];
            [defaults2 setInteger:1 forKey:@"airResist"];
            [defaults2 setInteger:1 forKey:@"coinFreq"];
            [defaults2 setInteger:1 forKey:@"energyFreq"];
            [defaults2 setInteger:1 forKey:@"bonusFreq"];
            [defaults2 setInteger:1 forKey:@"rocketFreq"];
            [defaults2 setInteger:1 forKey:@"coinLevel"];
            [defaults2 setInteger:1 forKey:@"boostLevel"];
            [defaults2 setInteger:1 forKey:@"energyLevel"];
            [defaults2 setInteger:1000 forKey:@"gold"];
            [defaults2 setInteger:1000 forKey:@"xp"];
            [defaults2 setInteger:1000 forKey:@"brains"];
        }
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
        
        Cloud *cPow=[[Cloud alloc] initSelf];
        cPow.position=ccp(-1000,50);
        [gameState.powerups addObject:cPow];
        cPow=[[Cloud alloc] initSelf];
        cPow.position=ccp(-1000,50);
        [gameState.powerups addObject:cPow];
        cPow=[[Cloud alloc] initSelf];
        cPow.position=ccp(-1000,50);
        [gameState.powerups addObject:cPow];
        
        gameState.shields=[[NSMutableArray alloc] init];
        BounceShield *bounceShld=[[BounceShield alloc] initSelf];
        [gameState.shields addObject:bounceShld];
        BoostShield *boostShld=[[BoostShield alloc] initSelf];
        [gameState.shields addObject:boostShld];
        CoinShield *coinShld=[[CoinShield alloc] initSelf];
        [gameState.shields addObject:coinShld];
        RollShield *rollShld=[[RollShield alloc] initSelf];
        [gameState.shields addObject:rollShld];
        
        gameState.globalParams=[[NSMutableArray alloc] init];
        GravityParam *grav=[[GravityParam alloc] initSelf];
        [gameState.globalParams addObject:grav];
        FrictionParam *fric=[[FrictionParam alloc] initSelf];
        [gameState.globalParams addObject:fric];
        BounceParam *bounce=[[BounceParam alloc] initSelf];
        [gameState.globalParams addObject:bounce];
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        onePlayer = [CCSprite spriteWithFile:@"Title.png"];
        onePlayer.scale=.5;
		onePlayer.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:onePlayer];
        
		shopSprite = [CCSprite spriteWithFile:@"super_mario_coin.png"];
        shopSprite.scale=1;
        shopSprite.position = ccp(winSize.width/8, winSize.height/8);
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
        
        if (CGRectContainsPoint(shopSprite.boundingBox,location)) {
            //[gameState setState:-10];
            ShopHome *q = [[ShopHome alloc] init:gameState];
            self.isTouchEnabled=NO;
            [q setParentLayer:self];
            [self.parent addChild:q z:10];
        }else if (CGRectContainsPoint(onePlayer.boundingBox,location)) {
            [[CCDirector sharedDirector] pushScene:[GameScene initNode:gameState]];
        }
    }

}

@end
