// Import the interfaces
#import "GameScene.h"
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

@implementation GameScene
//@synthesize layer = _layer;
BOOL runAI;
CGSize winSize;
CGPoint firstTouch, lastTouch;
#define PTM_RATIO 150.0

#define pi 3.14
GameState *gameState;
AVAudioPlayer *player;
+ (id)initNode:(GameState*) gameState {
	return [[[self alloc] initWithMonsters:gameState] autorelease];
}

- (id)initWithMonsters:(GameState*) gs{
    if ((self = [super init])) {
        gameState=gs;
        gameState.state=0;
        gameState.charge=20;
        gameState.topSpeed=100;
        //SystemSoundID mySound;
        //NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"ggs" ofType:@"mp3"];
        //AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
        //player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        //player.numberOfLoops=-1;
        //player.volume=.2;
        //[player play];
        //self.layer = [Game initNode];
        //[self.layer setGameState:gameState];
        lay = [Game initNode:gameState];
        _hudLayer = [[HudLayer alloc] init];;
        _hudLayer->gameState = gameState;
        [self addChild:[CCColorLayer layerWithColor:ccc4(124,106,128,255)]];
        [self addChild:lay];
        [self addChild:_hudLayer];
    }
    return self;
}

- (HudLayer*)getHud{
    return _hudLayer;
}

-(void)addTotal{
    TotalLayer* tt = [[TotalLayer alloc] init:gameState];
    [self addChild:tt];
}

- (void)hideGame{
    lay.visible=0;
}
- (void)showGame{
    lay.visible=1;
}

- (void)dealloc {
    //self.layer = nil;
    //[_quizLayer dealloc];
    //[_hudLayer dealloc];
    [player stop];
    [super dealloc];
}

@end


// Game implementation
@implementation Game

NSUserDefaults *defaults2;

float fireOffset=0;
AchievementEngine *achEngine;
bool paused = false;
bool flattened = false;
bool rocketing=false;
b2Vec2 launchSpeed=b2Vec2(10,10);
float restitution=.6;
float friction=.2;

+ (id)initNode:(GameState*) gs {
	return [[[self alloc] initWithMonsters:gs] autorelease];
}

// on "init" you need to initialize your instance
- (id)initWithMonsters:(GameState*) gs
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(155,155,155,255)] )) {
        //self.pow
        gameState=gs;
        defaults2=[NSUserDefaults standardUserDefaults];
        
        [defaults2 setInteger:1 forKey:@"airResist"];
        [defaults2 setInteger:1 forKey:@"enemyFreq"];
        [defaults2 setInteger:1 forKey:@"quizFreq"];
        [defaults2 setInteger:1 forKey:@"enemyBoost"];
        [defaults2 setInteger:1 forKey:@"quizBoost"];
        [defaults2 setFloat:-2.5 forKey:@"gravity"];
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
        //[defaults2 setInteger:0 forKey:@"gold"];
        //[defaults2 setInteger:0 forKey:@"xp"];
        //[defaults2 setInteger:0 forKey:@"brains"];
        gameState.rocketTime=-1;
        
        //[defaults2 integerForKey:@"airResist"]+
        AchievementEngine *achEng=[[AchievementEngine alloc] init:defaults2];
        [gameState setAchEng:achEng];
        int scale=1;
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
        bg90 = [CCSprite spriteWithFile:@"bg3.png"];
        bg90.scale = 1.5;
        [bg90 setPosition:ccp(-1000,40+bg90.boundingBox.size.height/2)];
        [self addChild:bg90 z:0];
        bg91 = [CCSprite spriteWithFile:@"bg3.png"];
        bg91.scale = 1.5;
        [bg91 setPosition:ccp(-1000,40+bg91.boundingBox.size.height/2)];
        [self addChild:bg91 z:0];
        bg70 = [CCSprite spriteWithFile:@"bg4.png"];
        bg70.scale = .8;
        [bg70 setPosition:ccp(-1000,40+bg70.boundingBox.size.height/2)];
        [self addChild:bg70 z:0];
        bg71 = [CCSprite spriteWithFile:@"bg4.png"];
        bg71.scale = .8;
        [bg71 setPosition:ccp(-1000,40+bg71.boundingBox.size.height/2)];
        [self addChild:bg71 z:0];
        
        
        for (Powerup *pow in [gameState powerups]) {
            pow.position=ccp(-1000,0);
            [self addChild:pow z:1];
        }
        
		// Enable touch events
		self.isTouchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
        
		winSize = [[CCDirector sharedDirector] winSize];
        //p1center = ccp(winSize.width/2,winSize.height/8);
        //p2center = ccp(winSize.width/2,7*winSize.height/8);
        //character=[Character alloc];
        
		runAI = true;
        
        _ball = [Character spriteWithFile:@"brain_test.png"];
        _ball.scale=.2;
        _ball.position = ccp(100, 100);
        [self addChild:_ball z:1];
        
        // SHIELDS
        for (Shield *shield in [gameState shields]) {
            shield.position=ccp(-1000,0);
            [self addChild:shield z:1];
        }
        
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
        
        // Create ainitWithGame world
        
        b2Vec2 gravity = b2Vec2(0.0f, [defaults2 floatForKey:@"gravity"]);
        world = new b2World(gravity);
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
        ballBodyDef.linearVelocity= launchSpeed;
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
                world->SetGravity(b2Vec2(0.0f, [defaults2 floatForKey:@"gravity"]));
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

-(void)popScene{
    [gameState setState:10];
    [self.parent removeChild:self cleanup:TRUE];
    [[CCDirector sharedDirector] popScene];
}

-(void)shieldAdd:(Shield *) s{
    if([s.name isEqual: @"RollShield"]){
        ballShapeDef.shape = &_circle;
        ballShapeDef.friction = 0.11f;
        ballShapeDef.restitution = .9f;
        //backspin
        if(_body->GetAngularVelocity()>0){
            _body->SetAngularVelocity(-_body->GetAngularVelocity());
        }
    }else if([s.name isEqual: @"BounceShield"]){
        float f =1.1+s.power*.1;
        ballShapeDef.restitution = f;
        ballShapeDef.friction=.01f;
    }
    _body->DestroyFixture(_fixture);
    _fixture = _body->CreateFixture(&ballShapeDef);
}

-(void)shieldRemove:(Shield *) s{
    if([s.name isEqual: @"BounceShield"]){
        ballShapeDef.restitution = restitution;
        ballShapeDef.friction = friction;
    }else if([s.name isEqual: @"RollShield"]){
        ballShapeDef.shape = &_box;
        ballShapeDef.friction = friction;
        ballShapeDef.restitution = .8f;
    }
    _body->DestroyFixture(_fixture);
    _fixture = _body->CreateFixture(&ballShapeDef);
}

//-(void)shieldCalc:(Shield *) s{
//    if([s.name isEqual: @"RollShieldMake"]){
//        _body->DestroyFixture(_fixture);
//        b2CircleShape circle;
//        circle.m_radius=50/PTM_RATIO;
//        ballShapeDef.shape = &circle;
//        ballShapeDef.friction = 0.11f;
//        ballShapeDef.restitution = .8f;
//    }else if([s.name isEqual: @"RollShieldDestroy"]){
//        _body->DestroyFixture(_fixture);
//        b2PolygonShape box;
//        box.SetAsBox(.33, .33, b2Vec2(0, 0), .01);
//        
//        ballShapeDef.shape = &box;
//        ballShapeDef.friction = friction;
//    }
//    if([s.name isEqual: @"BounceShieldMake"]){
//        ballShapeDef.restitution = 1.2f;
//        ballShapeDef.friction=.11;
//    }
//    if([s.name isEqual: @"BounceShieldDestroy"]){
//        ballShapeDef.restitution = restitution;
//    }
//    _fixture = _body->CreateFixture(&ballShapeDef);
//}

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
            [gameState setScore:_ball.position.x];
            [gameState setSpeed:_body->GetLinearVelocity().x];
            
            //check for enemy collision
            if(!rocketing){
                for (Powerup *pow in [gameState powerups]) {
                    if(CGRectIntersectsRect(ballData.boundingBox, pow.boundingBox)){
                        [pow collide: _body gameState:gameState];
                        //TODO Make Powerup Shield
                        //[self shieldAdd:<#(Shield *)#>];
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
            
            //check for bg spawn
//            float totalDist=[bg boundingBox].size.width+[bg1 boundingBox].size.width+[bg2 boundingBox].size.width+[bg3 boundingBox].size.width;
//            if(ballData.position.x>bg.position.x+totalDist/2){
//                bg.position = ccp(bg3.position.x+bg3.boundingBox.size.width/2+bg.boundingBox.size.width/2-9,bg.position.y);
//            } if(ballData.position.x>bg1.position.x+totalDist/2){
//                bg1.position = ccp(bg.position.x+bg.boundingBox.size.width/2+bg1.boundingBox.size.width/2-9,bg1.position.y);
//            } if(ballData.position.x>bg2.position.x+totalDist/2){
//                bg2.position = ccp(bg1.position.x+bg1.boundingBox.size.width/2+bg2.boundingBox.size.width/2-9,bg2.position.y);
//            } if(ballData.position.x>bg3.position.x+totalDist/2){
//                bg3.position = ccp(bg2.position.x+bg2.boundingBox.size.width/2+bg3.boundingBox.size.width/2-9,bg3.position.y);
//            }
//            totalDist=bg10.boundingBox.size.width+bg11.boundingBox.size.width;
//            if(ballData.position.x>bg10.position.x+totalDist/3){
//                bg10.position = ccp(bg11.position.x+bg11.boundingBox.size.width/2+bg10.boundingBox.size.width/2-9,bg10.position.y);
//            } if(ballData.position.x>bg11.position.x+totalDist/3){
//                bg11.position = ccp(bg10.position.x+bg10.boundingBox.size.width/2+bg11.boundingBox.size.width/2-9,bg11.position.y);
//            }
//            if(ballData.position.x>bg20.position.x+totalDist/3){
//                bg20.position = ccp(bg21.position.x+bg21.boundingBox.size.width/2+bg20.boundingBox.size.width/2-9,bg20.position.y);
//            } if(ballData.position.x>bg21.position.x+totalDist/3){
//                bg21.position = ccp(bg20.position.x+bg20.boundingBox.size.width/2+bg21.boundingBox.size.width/2-9,bg21.position.y);
//            }
//            if(ballData.position.x>bg30.position.x+totalDist/3){
//                bg30.position = ccp(bg31.position.x+bg31.boundingBox.size.width/2+bg30.boundingBox.size.width/2-9,bg30.position.y);
//            }if(ballData.position.x>bg31.position.x+totalDist/3){
//                bg31.position = ccp(bg30.position.x+bg30.boundingBox.size.width/2+bg31.boundingBox.size.width/2-9,bg31.position.y);
//            }
            if(ballData.position.x>bg80.position.x+bg80.boundingBox.size.width){
                bg80.position = ccp(bg81.position.x+bg81.boundingBox.size.width/2+bg80.boundingBox.size.width/2-9,bg80.position.y);
            }if(ballData.position.x>bg81.position.x+bg81.boundingBox.size.width){
                bg81.position = ccp(bg80.position.x+bg80.boundingBox.size.width/2+bg81.boundingBox.size.width/2-9,bg81.position.y);
            }
            if(ballData.position.x>bg70.position.x+bg70.boundingBox.size.width){
                bg70.position = ccp(bg71.position.x+bg71.boundingBox.size.width/2+bg70.boundingBox.size.width/2-9,bg70.position.y);
            }if(ballData.position.x>bg71.position.x+bg71.boundingBox.size.width){
                bg71.position = ccp(bg70.position.x+bg70.boundingBox.size.width/2+bg71.boundingBox.size.width/2-9,bg71.position.y);
            }
            if(ballData.position.x>bg90.position.x+bg90.boundingBox.size.width){
                bg90.position = ccp(bg91.position.x+bg91.boundingBox.size.width/2+bg90.boundingBox.size.width/2-9,bg90.position.y);
            }if(ballData.position.x>bg91.position.x+bg91.boundingBox.size.width){
                bg91.position = ccp(bg90.position.x+bg90.boundingBox.size.width/2+bg91.boundingBox.size.width/2-9,bg91.position.y);
            }
            
            
            gg1.position = ccp(ballData.position.x-512,gg1.position.y);
            gg2.position = ccp(ballData.position.x-512,gg2.position.y);
            float lol = (float)ballData.position.x - (float)lastBallPos.x  ;
            bg80.position=ccp(bg80.position.x+(float)lol*0.9f,40+bg80.boundingBox.size.height/2+ballData.position.y*.7);
            bg81.position=ccp(bg81.position.x+(float)lol*0.9f,40+bg81.boundingBox.size.height/2+ballData.position.y*.7);
            bg90.position=ccp(bg90.position.x+(float)lol*0.5f,40+bg90.boundingBox.size.height/2+ballData.position.y*.4);
            bg91.position=ccp(bg91.position.x+(float)lol*0.5f,40+bg91.boundingBox.size.height/2+ballData.position.y*.4);
            
            //update for distance
            //NSLo
            _body->SetLinearDamping((_body->GetLinearVelocity().x/500)+((ballData.position.x/100)/(40000.0+(ballData.position.x/100))));
            //int i =  ballData.position.x;
            //NSLog(@"%f", _body->GetLinearVelocity().x);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([gameState state]==99){
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]+(gameState.score/1000) forKey:@"xp"];
        [self popMe];
    }
    if([gameState state]==0){
        // Choose one of the touches to work with
        //gameState.rocketTime=10;
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        lastTouch = [[CCDirector sharedDirector] convertToGL:location];
        float len=ccpDistance(firstTouch,lastTouch);
        
        if(fabs(_body->GetAngularVelocity())<.05)
            _body->SetAngularVelocity(.05);
        if(gameState.rocketTime>-1){
            if(firstTouch.x+60<lastTouch.x && len>80){
                _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+len/200,_body->GetLinearVelocity().y+len/400));
            }
        }else if(gameState.charge>0) {
            if(firstTouch.y>lastTouch.y+120){
                if(_body->GetLinearVelocity().y>0){
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,-3.0));
                }else{
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,_body->GetLinearVelocity().y-3.0));
                }
                [gameState setCharge:(gameState.charge-1)];
            }
            if(firstTouch.y+120<lastTouch.y){
                if(_body->GetLinearVelocity().y<0){
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,3.0));
                }else{
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,_body->GetLinearVelocity().y+3.0));
                }

                [gameState setCharge:(gameState.charge-1)];
            }
            //combos
            ///<<<<
            if(firstTouch.x>lastTouch.x+120){
                [gameState setComboTimer:0];
                [gameState setComboVal:[gameState comboVal]*10];
                [self fireShield];
            }
            ///>>>>
            if(firstTouch.x+120<lastTouch.x){
                [gameState setComboTimer:0];
                [gameState setComboVal:[gameState comboVal]*10+1];
                [self fireShield];
            }
        }
    }
}

-(void)fireShield{
    //SHIELD
    if([gameState comboVal]>999){
        for(Shield *s in gameState.shields){
            if(s.triggerCombo==[gameState comboVal]){
                s.timer=s.dur;
                [self shieldAdd:s];
            }
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	firstTouch = [[CCDirector sharedDirector] convertToGL:location];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[_targets release];
	_targets = nil;
    [self removeAllChildrenWithCleanup:true];
    //    [bg dealloc];
    //    [bg1 dealloc];
    //    [bg2 dealloc];
    //    [bg3 dealloc];
    //    [bg10 dealloc];
    //    [bg11 dealloc];
    //    [bg20 dealloc];
    //    [bg21 dealloc];
    //    [bg30 dealloc];
    //    [bg31 dealloc];
    //    [_ball dealloc];
    //    [_boostshield dealloc];
    //    [_bounceshield dealloc];
    //    [_ballshield dealloc];
    //    [_bonusshield dealloc];
    //    [achEngine dealloc];
    //	[_quizLayer dealloc];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
