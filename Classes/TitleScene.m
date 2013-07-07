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
#import "Hole.h"
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
@synthesize girl, gameState;
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
        
        Hole *hole=[[Hole alloc] initSelf];
        hole.position=ccp(-1000,50);
        [gameState.powerups addObject:hole];
        
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
        title = [[CCLabelTTF alloc] initWithString:@"Brainball lol" fontName:@"Verdana" fontSize:20];
        //onePlayer.scale=;
        title.color=ccBLACK;
		title.position = ccp(winSize.width/4, winSize.height/2);
        [self addChild:title];
        girl = [CCSprite spriteWithFile:@"girl.png"];
        girl.scale=.5;
		girl.position = ccp(winSize.width-100, winSize.height/2);
        [self addChild:girl];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"bearsssss.plist"];
        
        
//        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bearsssss.png"];
//        [self addChild:spriteSheet];
//        NSMutableArray *walkAnimFrames = [NSMutableArray array];
//        for (int i=1; i<=8; i++) {
//            [walkAnimFrames addObject:
//             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
//              [NSString stringWithFormat:@"bear%d.png",i]]];
//        }
//        CCAnimation *walkAnim = [CCAnimation
//                                 animationWithFrames:walkAnimFrames delay:0.1f];
//        self.bear = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
//        self.bear.scale=.2;
//        self.bear.position = ccp(400, 280);
//        self.walkAction = [CCRepeatForever actionWithAction:
//                           [CCAnimate actionWithAnimation:walkAnim]];
//        [self.bear runAction:self.walkAction];
//        [spriteSheet addChild:self.bear];
        
	}	
	return self;
}

-(void) load{
    title.string=@"Loading......";
}

-(void) startMe{
    [[CCDirector sharedDirector] pushScene:[GameScene initNode:gameState]];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
    if([gameState state] ==10){
        [self runAction:[CCSequence actions:
                         [CCCallFuncN actionWithTarget:self selector:@selector(load)],
                         [CCDelayTime actionWithDuration:.5],
                         [CCCallFuncN actionWithTarget:self selector:@selector(startMe)],
                        nil]];
        
            
    }

}

@end
