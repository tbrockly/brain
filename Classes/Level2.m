//
//  Level2.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/25/13.
//
//

#import "Level2.h"
#import "SimpleAudioEngine.h"
#include <AudioToolbox/AudioToolbox.h>
#import "math.h"
#import "cocos2d.h"
#import "CCActionInterval.h"
#import "AchievementEngine.h"
#import "Powerup.h"
#import "Boost.h"
#import "Rocket.h"
#import "Spin.h"
#import "PCoin.h"
#import "Bonus.h"
#import "Quiz.h"
#import "Ride.h"
#import "Energy.h"
#import "TotalLayer.h"
#import "Shield.h"
#import "BounceShield.h"
#import "BoostShield.h"
#import "CoinShield.h"
#import "RollShield.h"
#import "GlobalParam.h"
#define PTM_RATIO 150.0

#define pi 3.14

@implementation Level2
// on "init" you need to initialize your instance
- (id)initWithMonsters:(GameState*) gs
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        //self.pow
        gameState=gs;
        defaults2=[NSUserDefaults standardUserDefaults];
        fireOffset=0;
        paused = false;
        flattened = false;
        rocketing=false;
        for(GlobalParam *g in gameState.globalParams){
            if([g.name isEqualToString: @"WorldBounce"]){
                restitution=g.value;
            }else if([g.name isEqualToString: @"WorldFriction"]){
                friction=g.value;
            }else if([g.name isEqualToString: @"WorldGravity"]){
                gravity=g.value;
            }
        }
        
        
        
        gameState.score=0;
        
        gameState.rocketTime=-1;
        
        //[defaults2 integerForKey:@"airResist"]+
        AchievementEngine *achEng=[[AchievementEngine alloc] init:defaults2];
        [gameState setAchEng:achEng];
        
        bgLayer=[[CCLayer alloc] init];
        
        gg1=[CCColorLayer layerWithColor:ccc4(50, 155, 50, 255) width:500 height:20];
        [gg1 setPosition:ccp(0,30)];
        [self addChild:gg1 z:1];
        gg2=[CCColorLayer layerWithColor:ccc4(60, 65, 0, 255) width:500 height:20];
        [gg2 setPosition:ccp(0,20)];
        [self addChild:gg2 z:1];
        
        //        gg2=[CCColorLayer layerWithColor:ccc4(50, 155, 50, 255) width:2000 height:500];
        //        [gg2 setPosition:ccp(-1000,-400)];
        //        [self addChild:gg2 z:0];
        
        [[CCTextureCache sharedTextureCache] addImage:@"slice_1_0.jpg"];
        bg = [CCSprite spriteWithFile:@"slice_1_0.jpg"];
        bg.scale = 2;
        [bg setPosition:ccp(480,160)];
        [bgLayer addChild:bg z:0];
        [[CCTextureCache sharedTextureCache] addImage:@"bgtree.png"];
        bg1 = [CCSprite spriteWithFile:@"bgtree.png"];
        bg1.scale = 1;
        [bg1 setPosition:ccp(200,120)];
        [bgLayer addChild:bg1 z:0];
        bg2 = [CCSprite spriteWithFile:@"bgtree.png"];
        bg2.scale = 1;
        [bg2 setPosition:ccp(200+bg1.boundingBox.size.width,120)];
        [bgLayer addChild:bg2 z:0];
        
        //core BG movement
        //if([gameState dy] <120){
        bgLayer.position=ccp(bgLayer.position.x,0);
        
        [self addChild:bgLayer];
        //        bg81 = [CCSprite spriteWithFile:@"bg2.png"];
        //        bg81.scale = .8;
        //        [bg81 setPosition:ccp(-1000,40+bg81.boundingBox.size.height/2)];
        //        [self addChild:bg81 z:0];
        //        bg90 = [CCSprite spriteWithFile:@"bg3.png"];
        //        bg90.scale = .8;
        //        [bg90 setPosition:ccp(000,40+bg90.boundingBox.size.height/2)];
        //        [self addChild:bg90 z:0];
        //        bg91 = [CCSprite spriteWithFile:@"bg3.png"];
        //        bg91.scale = .8;
        //        [bg91 setPosition:ccp(bg91.boundingBox.size.width,40+bg91.boundingBox.size.height/2)];
        //        [self addChild:bg91 z:0];
        //        bg92 = [CCSprite spriteWithFile:@"bg3.png"];
        //        bg92.scale = .8;
        //        [bg92 setPosition:ccp(-1000,40+bg92.boundingBox.size.height/2)];
        //        [self addChild:bg92 z:0];
        
        
        
        for (Powerup *pow in [gameState powerups]) {
            pow.position=ccp(-1000,0);
            [self addChild:pow z:1];
        }
        
		// Enable touch events
		self.isTouchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
        
        //p1center = ccp(winSize.width/2,winSize.height/8);
        //p2center = ccp(winSize.width/2,7*winSize.height/8);
        //character=[Character alloc];
        
		//runAI = true;
        
        // SHIELDS
        for (Shield *shield in [gameState shields]) {
            shield.position=ccp(-1000,0);
            [self addChild:shield z:1];
        }
        [[CCTextureCache sharedTextureCache] addImage:@"arrow.png"];
        fireback=[CCSprite spriteWithFile:@"firebackground2.jpg" rect:CGRectMake(0,0,-2056,-2056)];
        arrow=[CCSprite spriteWithFile:@"arrow.png"];
        arrow.scale=3;
        ccTexParams params={GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [fireback.texture setTexParameters:&params];
        fireback.position=ccp(-3000,0);
        [self addChild:fireback z:0];
        arrow.position=ccp(-3000,0);
        [self addChild:arrow z:0];
        [fireback runAction:[CCFadeOut actionWithDuration:.1]];
        [arrow runAction:[CCFadeOut actionWithDuration:.1]];
        
        gameState.dx=0;
        gameState.dy=0;
        gameState.vx=200;
        gameState.vy=1000;
        //gameState.ax=0;
        gameState.ay=-1000;
        gameState.rot=0;
        gameState.vrot=1;
        NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"hit" ofType:@"wav"];
        AudioServicesCreateSystemSoundID(( CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
        
        
        [self schedule:@selector(tick:)];
        [self schedule:@selector(calc:) interval:.5f];
        [gameState setCharge:4];
	}
	return self;
}

@end
