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
#import "Box2D.h"
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
	if( (self=[super initWithColor:ccc4(155,155,155,255)] )) {

        gameState=gs;
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
        
        defaults2=[NSUserDefaults standardUserDefaults];
        //[defaults2 integerForKey:@"airResist"]+
        AchievementEngine *achEng=[[AchievementEngine alloc] init:defaults2];
        [gameState setAchEng:achEng];
        gameState.state=0;
        gg1=[CCColorLayer layerWithColor:ccc4(50, 155, 50, 255) width:2000 height:500];
        [gg1 setPosition:ccp(-1000,-300)];
        [self addChild:gg1 z:0];
        gg2=[CCColorLayer layerWithColor:ccc4(60, 65, 0, 255) width:2000 height:500];
        [gg2 setPosition:ccp(-1000,-450)];
        [self addChild:gg2 z:0];

        //        gg2=[CCColorLayer layerWithColor:ccc4(50, 155, 50, 255) width:2000 height:500];
        //        [gg2 setPosition:ccp(-1000,-400)];
        //        [self addChild:gg2 z:0];
        bg80 = [CCSprite spriteWithFile:@"bg2.png"];
        bg80.scale = 1.3;
        [bg80 setPosition:ccp(-1000,40+bg80.boundingBox.size.height/2)];
        [self addChild:bg80 z:0];
        bg81 = [CCSprite spriteWithFile:@"bg2.png"];
        bg81.scale = 1.3;
        [bg81 setPosition:ccp(-1000,40+bg81.boundingBox.size.height/2)];
        [self addChild:bg81 z:0];
        bg90 = [CCSprite spriteWithFile:@"ScienceBG.png"];
        bg90.scale = .8;
        [bg90 setPosition:ccp(-1000,-20+bg90.boundingBox.size.height/2)];
        [self addChild:bg90 z:0];
        bg91 = [CCSprite spriteWithFile:@"ScienceBG2.png"];
        bg91.scale = .8;
        [bg91 setPosition:ccp(-1000,-20+bg91.boundingBox.size.height/2)];
        [self addChild:bg91 z:0];
        

        
		// Enable touch events
		self.isTouchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
        
        //p1center = ccp(winSize.width/2,winSize.height/8);
        //p2center = ccp(winSize.width/2,7*winSize.height/8);
        //character=[Character alloc];
        
		//runAI = true;
        
        _ball = [Character spriteWithFile:@"brain_test.png"];
        _ball.scale=.2;
        _ball.position = ccp(100, 100);
        [self addChild:_ball z:1];
        
        
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
        
        for (Powerup *pow in [gameState powerups]) {
            [pow removeFromParentAndCleanup:true];
            pow.position=ccp(-1000,0);
            [self addChild:pow z:1];
        }
        
        // SHIELDS
        for (Shield *shield in [gameState shields]) {
            [shield removeFromParentAndCleanup:true];
            shield.position=ccp(-1000,0);
            [self addChild:shield z:1];
        }
        
        // Create ainitWithGame world
        
        world = new b2World(b2Vec2(0.0f, gravity));
        //world->SetContinuousPhysics(false);
        //[self setWorld:world];
        
        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        b2Body *groundBody = world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        int myWidth=999999;
        int myHeight=bg.boundingBox.size.height+99999;
        groundEdge.Set(b2Vec2(0,0), b2Vec2(myWidth/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(0,0), b2Vec2(0, myHeight/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(0, myHeight/PTM_RATIO),
                       b2Vec2(myWidth/PTM_RATIO, myHeight/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(myWidth/PTM_RATIO,
                              myHeight/PTM_RATIO), b2Vec2(myWidth/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        // Create ball body and shape
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(150/PTM_RATIO, 150/PTM_RATIO);
        ballBodyDef.userData = _ball;
        ballBodyDef.linearVelocity= b2Vec2(gameState.ballvx, gameState.ballvy);
        ballBodyDef.linearDamping=0;
        _body = world->CreateBody(&ballBodyDef);
        
        _circle.m_radius=50/PTM_RATIO;
        _box.SetAsBox(.06, .06, b2Vec2(0, 0), .01);
        ballShapeDef.shape = &_box;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = friction;
        ballShapeDef.restitution = restitution;
        _fixture = _body->CreateFixture(&ballShapeDef);
        
        if(fabs(_body->GetAngularVelocity())<.05)
            _body->SetAngularVelocity(.1);
        
        self.scale=.8;
        [self schedule:@selector(tick:)];
        [self schedule:@selector(calc:) interval:.5f];
        [gameState setCharge:4];
	}
	return self;
}

- (void)calc:(ccTime) dt {
    if(_body->GetLinearVelocity().x<0){
        _body->SetLinearVelocity(b2Vec2(0, _body->GetLinearVelocity().y));
    }
    if([gameState state]==0){
        [gameState setComboTimer:[gameState comboTimer]+1];
        if([gameState comboTimer]>2){
            [gameState setComboVal:1];
        }
        //count
        if(_body->GetLinearVelocity().x ==0){
            gameState.quizTime++;
            if(gameState.quizTime>1){
                //_ball=[[CCSprite alloc] initWithFile:@"brain_squash01.png"];
            }
            if(gameState.quizTime>3){
                [self.parent addTotal];
                [gameState setState:99];
            }
        }else{
            gameState.quizTime=0;
            if(flattened){
                //_ball =[[CCSprite alloc] initWithFile:@"brain_test.png"];
            }
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
            if(gameState.zerograv==-1){
                world->SetGravity(b2Vec2(0.0f, gravity));
            }else{
                world->SetGravity(b2Vec2(0.0f,0.0f));
            }
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

- (void)tick:(ccTime) dt {
    if([gameState state]==0 || [gameState state]==99){
        static double UPDATE_INTERVAL = 1.0f/60.0f;
        static double MAX_CYCLES_PER_FRAME = 5;
        static double timeAccumulator = 0;
        
        
        timeAccumulator += dt;
        if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
            timeAccumulator = UPDATE_INTERVAL;
        }
        
        int32 velocityIterations = 3;
        int32 positionIterations = 2;
        while (timeAccumulator >= UPDATE_INTERVAL) {
            CCSprite *ballData1 = (CCSprite *)_body->GetUserData();
            CGPoint lastBallPos =ballData1.position;
            timeAccumulator -= UPDATE_INTERVAL;
            world->Step(UPDATE_INTERVAL,
                        velocityIterations, positionIterations);
            CCSprite *ballData = (CCSprite *)_body->GetUserData();
            ballData.position = ccp(_body->GetPosition().x * PTM_RATIO,
                                    _body->GetPosition().y * PTM_RATIO);
            //ROCKET
            if(gameState.rocketTime>=0){
                fireOffset=fireOffset-(_body->GetLinearVelocity().x/4)-4;
                fireback.position=ccp(_ball.position.x+100+fireOffset,_ball.position.y+fireOffset);
                arrow.position=ccp(_ball.position.x-fireOffset*2,_ball.position.y);
                if(fireOffset<-255){
                    fireOffset=256;
                }
            }
            //ZOOM
            float xx = 25.0/(fabs(_body->GetLinearVelocity().x)+20.0)-fabs(_body->GetLinearVelocity().y)*.001;
            self.scale=xx>self.scale?self.scale+.002:self.scale-.002;
            
            [gameState setScale:self.scale]; 
            [self swtViewCenter:ccp(ballData.position.x+60*(2/self.scale),ballData.position.y+20)];
            //SHIELD
            for(Shield *s in gameState.shields){
                if(s.timer>0){
                    s.position=_ball.position;
                }
            }
            //BOOST
            if([gameState boost]>0){
                float vx=_body->GetLinearVelocity().x;
                float vy=_body->GetLinearVelocity().y < 0.0 ?0.0:_body->GetLinearVelocity().y;
                _body->SetLinearVelocity(b2Vec2(vx+[gameState boost],vy+[gameState boost]*.8));
                [gameState setBoost:0];
            }
            //TOPSPEED
            if(_body->GetLinearVelocity().x>gameState.topSpeed){
                _body->SetLinearVelocity(b2Vec2(gameState.topSpeed,_body->GetLinearVelocity().y));
            }
            int delta = (float)ballData.position.x - (float)lastBallPos.x;
            [gameState setScore:[gameState score] + delta];
            [gameState setSpeed:_body->GetLinearVelocity().x];
            
            //check for enemy collision
            if(!rocketing){
                for (Powerup *pow in [gameState powerups]) {
                    if(CGRectIntersectsRect(ballData.boundingBox, pow.boundingBox)){
                        [pow collide: _body gameState:gameState];
                        //TODO Make Powerup Shield
                        //[self shieldAdd:];
                        if(gameState.state==1){
                            
                            //[self.parent addChild:q z:10];
                            CGPoint center=ccp(ballData.position.x+60*(2/self.scale),ballData.position.y+320);
                            card.position=ccp(center.x,center.y+320);
                            [[self.parent getHud] drawCard];
                        }
                    }
                }
                
                
                //update positions
                for (Powerup *pow in [gameState powerups]) {
                    if(ballData.position.x>pow.position.x+2000){
                        //NSLog(@"%f", _body->GetLinearVelocity().x);
                        [pow updatePosition:ballData.position];
                    }
                }
            }
            if([gameState spinPower]>0){
                for(Shield *s in gameState.shields){
                    if([s.name isEqualToString:@"RollShield"]){
                        [self shieldAdd:s];
                        gameState.spinPower=0;
                    }
                }
            }
        
            if(ballData.position.x>bg80.position.x+bg80.boundingBox.size.width){
                bg80.position = ccp(bg81.position.x+bg81.boundingBox.size.width/2+bg80.boundingBox.size.width/2-9,bg80.position.y);
            }if(ballData.position.x>bg81.position.x+bg81.boundingBox.size.width){
                bg81.position = ccp(bg80.position.x+bg80.boundingBox.size.width/2+bg81.boundingBox.size.width/2-9,bg81.position.y);
            }

            if(ballData.position.x>bg90.position.x+bg90.boundingBox.size.width/2+200){
                bg90.position = ccp(bg91.position.x+bg91.boundingBox.size.width/2+bg90.boundingBox.size.width/2-9,bg90.position.y);
            }if(ballData.position.x>bg91.position.x+bg91.boundingBox.size.width/2+200){
                bg91.position = ccp(bg90.position.x+bg90.boundingBox.size.width/2+bg91.boundingBox.size.width/2-9,bg91.position.y);
            }
            
            
            gg1.position = ccp(ballData.position.x-512,gg1.position.y);
            gg2.position = ccp(ballData.position.x-512,gg2.position.y);
            float lol = (float)ballData.position.x - (float)lastBallPos.x  ;
            bg80.position=ccp(bg80.position.x+(float)lol*0.9f,40+bg80.boundingBox.size.height/2+ballData.position.y*.7);
            bg81.position=ccp(bg81.position.x+(float)lol*0.9f,40+bg81.boundingBox.size.height/2+ballData.position.y*.7);
            bg90.position=ccp(bg90.position.x+(float)lol*0.5f,-20+bg90.boundingBox.size.height/2+ballData.position.y*.4);
            bg91.position=ccp(bg91.position.x+(float)lol*0.5f,-20+bg91.boundingBox.size.height/2+ballData.position.y*.4);
            
            //update for distance
            //NSLo
            _body->SetLinearDamping((_body->GetLinearVelocity().x/500)+((ballData.position.x/100)/(40000.0+(ballData.position.x/100))));
            //int i =  ballData.position.x;
            //NSLog(@"%f", _body->GetLinearVelocity().x);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
        }
    }
}

@end
