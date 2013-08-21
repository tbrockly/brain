//
//  Level1.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/26/13.
//
//

#import "Level1.h"
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
#import "LevelScore.h"
#define PTM_RATIO 150.0

#define pi 3.14

@implementation Level1

NSUserDefaults *defaults2;



+ (id)initNode:(GameState*) gs {
	return [[[self alloc] initWithMonsters:gs] autorelease];
}

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
        
        skyLayer=[[CCColorLayer alloc] initWithColor:ccc4(200, 200, 255, 255) width:500 height:500];
        [self addChild:skyLayer];
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
        
//        [[CCTextureCache sharedTextureCache] addImage:@"slice_1_0.jpg"];
//        bg = [CCSprite spriteWithFile:@"slice_1_0.jpg"];
//        bg.scale = 2;
//        [bg setPosition:ccp(480,160)];
//        [bgLayer addChild:bg z:0];
        [[CCTextureCache sharedTextureCache] addImage:@"ScienceBG.png"];
        bg1 = [CCSprite spriteWithFile:@"ScienceBG.png"];
        bg1.scale = .4;
        [bg1 setPosition:ccp(200,120)];
        [bgLayer addChild:bg1 z:0];
        bg2 = [CCSprite spriteWithFile:@"ScienceBG.png"];
        bg2.scale = .4;
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
            [pow removeFromParentAndCleanup:true];
            pow.position=ccp(-1000,0);
            [pow initSelf];
            [self addChild:pow z:1];
        }
        
		// Enable touch events
		//self.isTouchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
        
        //p1center = ccp(winSize.width/2,winSize.height/8);
        //p2center = ccp(winSize.width/2,7*winSize.height/8);
        //character=[Character alloc];
        
		//runAI = true;
        
        // SHIELDS
        for (Shield *shield in [gameState shields]) {
            [shield removeFromParentAndCleanup:true];
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
        gameState.dy=20;
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
        
        [gameState setCharge:[[NSUserDefaults standardUserDefaults] integerForKey:@"startingCharge"]];
	}
	return self;
}

// this starts the magic of adding the game piece


- (void)swtViewCenter:(CGPoint)point{
    CGPoint centerPoint =ccp([self boundingBox].size.width/2,[self boundingBox].size.height/2);
    CGPoint viewPoint = ccpSub(centerPoint, point);
    self.position=(ccp(viewPoint.x*self.scaleX,viewPoint.y*self.scaleY));
    
}
int i=0;

-(void)popMe{
    [self popScene];
}

- (void)calc:(ccTime) dt {
//    if([gameState score]>50000){
//        [gameState setBallvx:_body->GetLinearVelocity().x];
//        [gameState setBallvy:_body->GetLinearVelocity().y];
//        [self.parent startLvl2:gameState];
//    }
    if([gameState state]==0){
        
        if(gameState.spinPower>=0){
            gameState.spinPower--;
        }
        
        [gameState setComboTimer:[gameState comboTimer]+1];
        if([gameState comboTimer]>2){
            [gameState setComboVal:1];
        }
        
        //Rocket
        if(gameState.rocketTime>=0){
            gameState.rocketTime--;
            if(gameState.rocketTime==0){
                [fireback runAction:[CCFadeOut actionWithDuration:1]];
                [arrow runAction:[CCFadeOut actionWithDuration:1]];
            }
            if(gameState.rocketTime==-1){
                rocketing=false;
                fireback.position=ccp(-2000,0);
            }else{
                if(!rocketing){
                    [fireback runAction:[CCFadeIn actionWithDuration:1]];
                    [arrow runAction:[CCFadeIn actionWithDuration:1]];
                    rocketing=true;
                    
                }
            }
        }//ZEROGRAV
        if(gameState.zerograv>=0){
            gameState.zerograv--;

        }
        //Shield
        for(Shield *s in gameState.shields){
            if(s.timer>0){
                s.timer--;
                if(s.timer == 0){
                    s.position=ccp(0,0);
                    [self shieldRemove: s];
                }
            }
        }
    }
}

-(void)popScene{
    [gameState setState:10];
   
    [self.parent removeChild:self cleanup:TRUE];
    [[CCDirector sharedDirector] popScene];
}

-(void)shieldAdd:(Shield *) s{
    s.timer=s.dur;
    if([s.name isEqual: @"RollShield"]){
       
    }else if([s.name isEqual: @"BounceShield"]){
        
    }

}

-(void)dropBrain{
    [self addxp:(gameState.score/1000)*(gameState.currLevel/2+1)];
    [[self.parent getHud] dropBrain];
}
-(void)restart{
    [self.parent restart:gameState];
}

-(void)shieldRemove:(Shield *) s{
    if([s.name isEqual: @"BounceShield"]){
       
    }else if([s.name isEqual: @"RollShield"]){
       
    }
}

-(void)addTotal{
    //[gameState setState:98];
    //[self.parent addTotal];
}

- (void)tick:(ccTime) dt {
    if([gameState state]==0){
        [gameState setVx:[gameState vx] + [gameState ax]*dt];
        if(gameState.zerograv<=0){
            [gameState setVy:[gameState vy] + [gameState ay]*dt];
        }
        [gameState setDx:[gameState dx] + [gameState vx]*dt];
        [gameState setDy:[gameState dy] + [gameState vy]*dt];
        if([gameState spinPower]>0){
            [gameState setRot:[gameState rot] + (200+[gameState vx]/2)*dt];
        }else{
           [gameState setRot:[gameState rot] + (20+[gameState vx]/10)*dt]; 
        }
        float mov=[gameState vx]*dt;
        bg1.position=ccp(bg1.position.x-mov, bg1.position.y);
        bg2.position=ccp(bg2.position.x-mov, bg2.position.y);
        float r=MAX(MIN(200-[gameState dy]*.06,100), MAX(200-[gameState dy]*.08, 0));
        float g=MAX(200-[gameState dy]*.08, 0);
        float b=MAX(MIN(255-[gameState dy]*.06, 255), 0);
        skyLayer.color=ccc3(r, g, b);
        //skyLayer.position=ccp([gameState dx],[gameState dy]);
        if(bg1.position.x<-500){
            bg1.position=ccp(bg2.position.x+bg2.boundingBox.size.width*2, bg1.position.y);
        }
        
        if(bg2.position.x<-500){
            bg2.position=ccp(bg1.position.x+bg1.boundingBox.size.width*2, bg2.position.y);
        }
        
        //core BG movement
        if([gameState dy] <110){
            bgLayer.position=ccp(bgLayer.position.x,0);
            gg1.position=ccp(gg1.position.x, 25);
            gg2.position=ccp(gg2.position.x, 15);
        }else{
            gg1.position=ccp(gg1.position.x, 135-[gameState dy]);
            gg2.position=ccp(gg2.position.x, 125-[gameState dy]);
            bgLayer.position=ccp(bgLayer.position.x,110-[gameState dy]);
        }
        //BOUNCE
        if([gameState dy]<0 && [gameState vy]<0){
            AudioServicesPlaySystemSound(mySound);
            [[self.parent getHud] brainbounce];
            gameState.vrot=(arc4random()%101)-50.0f;
            [gameState setDy:0];
            [gameState setVy:-[gameState vy]*(.8 -[gameState currLevel]*.03)];
            if(gameState.spinPower>=0 && [gameState vy]>50){
                [gameState setVx:[gameState vx]+20];
            }else{
                [gameState setVx:[gameState vx]*(.8 -[gameState currLevel]*.03)];
            }
            if([gameState vy] <100 && [gameState vy] >-100 && [gameState vx] <100){
                [[self.parent getHud] brainsplat];
                [gameState setState:99];
                [self addxp:(gameState.score/1000)*(gameState.currLevel/2+1)];
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:3],
                                 [CCCallFuncN actionWithTarget:[self.parent getHud] selector:@selector(pushEnd)],
                                 nil]];
            }
        }
        
        int pos=160+[gameState vy]/100;
        if([gameState dy] <110){
            pos=[gameState dy]+50;
        }
        for (Powerup *pow in [gameState powerups]) {
            if(pow.power>0){
                if([gameState dy] <110){
                    pow.position=ccp(pow.position.x-mov,pow.height);
                }else{
                    pow.position=ccp(pow.position.x-mov,110+pow.height-[gameState dy]);
                }
                if(CGRectContainsPoint(pow.boundingBox, ccp(160,pos))){
                    [pow collide:gameState];
                    if([pow.name isEqualToString:@"Quiz"]){
                        //[self.parent addChild:q z:10];
                        //CGPoint center=ccp(brain.position.x+60*(2/self.scale),brain.position.y+320);
                        //card.position=ccp(center.x,center.y+320);
                        [[self.parent getHud] drawCard];
                    }
                }
                
                
                if(pow.position.x<-200){
                    //NSLog(@"%f", _body->GetLinearVelocity().x);
                    [pow updatePosition:gameState];
                }
            }
        }
        
        //ROCKET
        if(gameState.rocketTime>=0){
            //fireOffset=fireOffset-(_body->GetLinearVelocity().x/4)-4;
            //fireback.position=ccp(_ball.position.x+100+fireOffset,_ball.position.y+fireOffset);
            //arrow.position=ccp(_ball.position.x-fireOffset*2,_ball.position.y);
            if(fireOffset<-255){
                fireOffset=256;
            }
        }
        //SHIELD
        for(Shield *s in gameState.shields){
            if(s.timer>0){
                //s.position=_ball.position;
            }
        }
        //BOOST
        if([gameState boost]>0){
            [gameState setVx:[gameState vx]+[gameState boost]*(100-[gameState currLevel]*5)];
            [gameState setVy:fabs([gameState vy])+[gameState boost]*(100-[gameState currLevel]*5)];
            [gameState setBoost:0];
        }
        //TOPSPEED
        //todo
        //score and speed
        //int delta = (float)ballData.position.x - (float)lastBallPos.x;
        [gameState setScore:[gameState dx]];
        //[gameState setSpeed:_body->GetLinearVelocity().x];
        
        
        
        //check for enemy collision
        if(!rocketing){
            for (Powerup *pow in [gameState powerups]) {
//                if(CGRectIntersectsRect(ballData.boundingBox, pow.boundingBox)){
//                    [pow collide:gameState];
//                    if(gameState.state==1){
//                        
//                        //[self.parent addChild:q z:10];
//                        //CGPoint center=ccp(ballData.position.x+60*(2/self.scale),ballData.position.y+320);
//                        //card.position=ccp(center.x,center.y+320);
//                        [[self.parent getHud] drawCard];
//                    }
//                }
            }
            
            
            //update positions
//            for (Powerup *pow in [gameState powerups]) {
//                if(ballData.position.x>pow.position.x+2000){
//                    //NSLog(@"%f", _body->GetLinearVelocity().x);
//                    [pow updatePosition:ballData.position];
//                }
//            }
        }
        
        //_body->SetLinearDamping((_body->GetLinearVelocity().x/500)+((ballData.position.x/100)/(40000.0+(ballData.position.x/100))));
        //int i =  ballData.position.x;
        //NSLog(@"%f", _body->GetLinearVelocity().x);
        //ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
    }
}

//- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if([gameState state]==99){
//        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]+(gameState.score/1000) forKey:@"xp"];
//        int curxp=[[NSUserDefaults standardUserDefaults] integerForKey:@"curxp"];
//        int tonext=[[NSUserDefaults standardUserDefaults] integerForKey:@"tonext"];
//        curxp=curxp+gameState.score/1000;
//        while(curxp>tonext){
//            curxp=curxp-tonext;
//            int level=[[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
//            [[NSUserDefaults standardUserDefaults] setInteger:level+1 forKey:@"level"];
//            tonext=(6*level*level-16*level+100)*.8;
//        }
//        [[NSUserDefaults standardUserDefaults] setInteger:curxp forKey:@"curxp"];
//        [[NSUserDefaults standardUserDefaults] setInteger:tonext forKey:@"tonext"];
//        [self.parent stopBearMusic];
//        [self popMe];
//    }
//    if([gameState state]==0){
//        // Choose one of the touches to work with
//        //gameState.rocketTime=10;
//        UITouch *touch = [touches anyObject];
//        CGPoint location = [touch locationInView:[touch view]];
//        lastTouch = [[CCDirector sharedDirector] convertToGL:location];
//        float len=ccpDistance(firstTouch,lastTouch);
//        
//        if(gameState.rocketTime>-1){
//            if(firstTouch.x+60<lastTouch.x && len>80){
//                _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+len/1200.0-myRocket.power*100.0,_body->GetLinearVelocity().y+len/600.0-myRocket.power*50.0));
//            }
//        }else
        
//            //combos
//            ///<<<<
//            if(firstTouch.x>lastTouch.x+120){
//                [gameState setComboTimer:0];
//                [gameState setComboVal:[gameState comboVal]*10];
//                [self fireShield];
//            }
//            ///>>>>
//            if(firstTouch.x+120<lastTouch.x){
//                [gameState setComboTimer:0];
//                [gameState setComboVal:[gameState comboVal]*10+1];
//                [self fireShield];
//            }
//        }
//    }
//}

-(void)fireShield{
    //SHIELD
    if([gameState comboVal]>999){
        for(Shield *s in gameState.shields){
            if(s.triggerCombo==[gameState comboVal]){
                [self shieldAdd:s];
            }
        }
    }
}

-(void)addCoins:(int)coinVal{
    [[self.parent getHud] addCoins:coinVal];
}

-(void)addBrains:(int)brainVal{
    [[self.parent getHud] addBrains:brainVal];
}

-(void)addxp:(int)xVal{
    [[self.parent getHud] addxp:xVal];
}

//- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    // Choose one of the touches to work with
//	UITouch *touch = [touches anyObject];
//	CGPoint location = [touch locationInView:[touch view]];
//	location = [[CCDirector sharedDirector] convertToGL:location];
//    
//}
//
//- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	// Choose one of the touches to work with
//	UITouch *touch = [touches anyObject];
//	CGPoint location = [touch locationInView:[touch view]];
//	firstTouch = [[CCDirector sharedDirector] convertToGL:location];
//}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[_targets release];
	_targets = nil;
    [self removeAllChildrenWithCleanup:true];
	[super dealloc];
}
@end
