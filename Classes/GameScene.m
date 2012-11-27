// Import the interfaces
#import "GameScene.h"
#import "SimpleAudioEngine.h"
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
#include <AudioToolbox/AudioToolbox.h>

@implementation GameScene
//@synthesize layer = _layer;
BOOL runAI;
CGSize winSize;
CGPoint firstTouch, lastTouch;
#define PTM_RATIO 150.0
#define HEIGHTDIFF 1000
#define HEIGHTDIFF2 2000
#define pi 3.14

AVAudioPlayer *player;
+ (id)initNode:(GameState*) gameState {
	return [[[self alloc] initWithMonsters:gameState] autorelease];
}

- (id)initWithMonsters:(GameState*) gs{
    if ((self = [super init])) {
        GameState *gameState=gs;
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
        Game *lay = [Game initNode:gameState];
        _hudLayer = [[HudLayer alloc] init];;
        _hudLayer->gameState = gameState;
        [self addChild:[CCColorLayer layerWithColor:ccc4(124,106,128,255)]];
        [self addChild:lay z:2 tag:0];
        [self addChild:_hudLayer z:3 tag:1];
    }     
    return self;
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
CCSprite* bg, *bg1, *bg2, *bg3, *bg10,*bg11,*bg20,*bg21,*bg30,*bg31;
b2Body *_body;
CCSprite *_ball;
CCSprite *_bonusshield,*_ballshield,*_bounceshield,*_boostshield,*fireback,*arrow;
QuizLayer *_quizLayer;
b2BodyDef ballBodyDef;
b2FixtureDef ballShapeDef;
b2Fixture *_fixture;
NSUserDefaults *defaults2;
int comboTimer,comboVal;
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
        [defaults2 setFloat:-3 forKey:@"gravity"];
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
        gameState.rocketTime=-1;
        //[defaults2 integerForKey:@"airResist"]+
        AchievementEngine *achEng=[[AchievementEngine alloc] init:defaults2];
        [gameState setAchEng:achEng];
        int scale=2.5;
        bg = [CCSprite spriteWithFile:@"slice_3_0.jpg"];
        bg.scale = scale;
        [bg setPosition:ccp(1000,-100+bg.boundingBox.size.height/2)];
        [self addChild:bg z:0];
        bg1 = [CCSprite spriteWithFile:@"slice_3_1.jpg"];
        bg1.scale = scale;
        [bg1 setPosition:ccp([bg boundingBox].size.width/2+[bg1 boundingBox].size.width/2,-100+bg1.boundingBox.size.height/2)];
        [self addChild:bg1 z:0];
        bg2 = [CCSprite spriteWithFile:@"slice_3_2.jpg"];
        bg2.scale = scale;
        //bg2.color=ccc3(10, 10, 200);
        [bg2 setPosition:ccp(-9000,-100+bg2.boundingBox.size.height/2)];
        [self addChild:bg2 z:0];
        bg3 = [CCSprite spriteWithFile:@"slice_3_3.jpg"];
        bg3.scale = scale;
        [bg3 setPosition:ccp(-9000,-100+bg3.boundingBox.size.height/2)];
        [self addChild:bg3 z:0];
        bg10 = [CCSprite spriteWithFile:@"slice_2_0.jpg"];
        bg10.scale = scale;
        [bg10 setPosition:ccp(0,-100+bg.boundingBox.size.height+bg10.boundingBox.size.height/2)];
        [self addChild:bg10 z:0];
        bg11 = [CCSprite spriteWithFile:@"slice_2_0.jpg"];
        bg11.scale = scale;
        [bg11 setPosition:ccp(-1000,-100+bg.boundingBox.size.height+bg11.boundingBox.size.height/2)];
        [self addChild:bg11 z:0];
        bg20 = [CCSprite spriteWithFile:@"slice_1_0.jpg"];
        bg20.scale = scale;
        [bg20 setPosition:ccp(-1000,-100+bg.boundingBox.size.height+bg10.boundingBox.size.height+bg20.boundingBox.size.height/2)];
        [self addChild:bg20 z:0];
        bg21 = [CCSprite spriteWithFile:@"slice_1_0.jpg"];
        bg21.scale = scale;
        [bg21 setPosition:ccp(-1000,-100+bg.boundingBox.size.height+bg10.boundingBox.size.height+bg20.boundingBox.size.height/2)];
        [self addChild:bg21 z:0];
        bg30 = [CCSprite spriteWithFile:@"slice_0_0.jpg"];
        bg30.scale = scale;
        [bg30 setPosition:ccp(-1000,-100+bg.boundingBox.size.height+bg10.boundingBox.size.height+bg20.boundingBox.size.height+bg30.boundingBox.size.height/2)];
        [self addChild:bg30 z:0];
        bg31 = [CCSprite spriteWithFile:@"slice_0_0.jpg"];
        bg31.scale = scale;
        [bg31 setPosition:ccp(-1000,-100+bg.boundingBox.size.height+bg10.boundingBox.size.height+bg20.boundingBox.size.height+bg30.boundingBox.size.height/2)];
        [self addChild:bg31 z:0];
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
        _ball.scale=.3;
        _ball.position = ccp(100, 100);
        [self addChild:_ball z:1];
        // SHIELDS
        _boostshield = [CCSprite spriteWithFile:@"shield2.png"];
        _boostshield.position = ccp(100, 100);
        _boostshield.scale=1.1;
        [self addChild:_boostshield z:1];
        _bonusshield = [CCSprite spriteWithFile:@"shield3.png"];
        _bonusshield.position = ccp(100, 100);
        [self addChild:_bonusshield z:1];
        _bounceshield = [CCSprite spriteWithFile:@"shield4.png"];
        _bounceshield.position = ccp(100, 100);
        _boostshield.scale=.9;
        [self addChild:_bounceshield z:1];
        _ballshield = [CCSprite spriteWithFile:@"shield1.png"];
        _ballshield.position = ccp(100, 100);
        _ballshield.scale=.8;
        [self addChild:_ballshield z:1];
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
        
        b2PolygonShape box;
        box.SetAsBox(.1, .1, b2Vec2(0, 0), .01);
        
        ballShapeDef.shape = &box;
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

- (void)calc:(ccTime) dt {
    if(_body->GetLinearVelocity().x<0){
        _body->SetLinearVelocity(b2Vec2(0, _body->GetLinearVelocity().y));
    }
    if([gameState state]==0){
    comboTimer++;
    if(comboTimer>2){
        comboVal=1;
    }
    //count 
    if(_body->GetLinearVelocity().x ==0){
        gameState.quizTime++;
        if(gameState.quizTime>1){
            //_ball=[[CCSprite alloc] initWithFile:@"brain_squash01.png"];
        }
        if(gameState.quizTime>3){
            [self popScene];
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
            //[self removeChild:_ball cleanup:NO];
            //_ball =[[CCSprite alloc] initWithFile:@"brain_grrr.png"];
            //[self addChild:_ball];
        }else{
            if(!rocketing){
//                CCSprite *rocketWrap =[[CCSprite alloc] init];
//                rocketWrap.position=_ball.position;
//                [self addChild:rocketWrap z:99];
                
                [fireback runAction:[CCFadeIn actionWithDuration:1]];
                [arrow runAction:[CCFadeIn actionWithDuration:1]];
                rocketing=true;
                
            }
            //[self removeChild:_ball cleanup:NO];
            //_ball =[[CCSprite alloc] initWithFile:@"brain_grrr.png"];
            //[self addChild:_ball];
        }
    }//ZEROGRAV
    if(gameState.zerograv>=0){
        gameState.zerograv--;
        if(gameState.zerograv==-1){
            world->SetGravity(b2Vec2(0.0f, [defaults2 floatForKey:@"gravity"]));
        }else{
            world->SetGravity(b2Vec2(0.0f,0.0f));
        }
    }//BALLTIMEOUT
    if(gameState.spinShield>=0){
        gameState.spinShield--;
        if(gameState.spinShield==-1){
            [self shieldCalc];
            _ballshield.position=ccp(0,0);
        }
    }//BOUNCETIMEOUT
    if(gameState.bounceTime>=0){
        gameState.bounceTime--;
        if(gameState.bounceTime==-1){
            [self shieldCalc];
            _bounceshield.position=ccp(0,0);
        }
    }//BONUSTIMEOUT
    if(gameState.bonusTime>=0){
        gameState.bonusTime--;
        if(gameState.bonusTime==-1){
            [self shieldCalc];
            _bonusshield.position=ccp(0,0);
        }
    }//BOOSTTIMEOUT
    if(gameState.boostTime>=0){
        gameState.boostTime--;
        if(gameState.boostTime==-1){
            [self shieldCalc];
            _boostshield.position=ccp(0,0);
        }
    }
    }
}

-(void)popScene{
    [gameState setState:10];
    [self.parent removeChild:self cleanup:TRUE];
    [[CCDirector sharedDirector] popScene];
}

-(void)shieldCalc{
    if(gameState.spinShield>0){
        _body->DestroyFixture(_fixture);
        b2CircleShape circle;
        circle.m_radius=50/PTM_RATIO;
        ballShapeDef.shape = &circle;
        ballShapeDef.friction = 0.11f;
        ballShapeDef.restitution = .8f;
    }else{
        _body->DestroyFixture(_fixture);
        b2PolygonShape box;
        box.SetAsBox(.33, .33, b2Vec2(0, 0), .01);
        
        ballShapeDef.shape = &box;
        ballShapeDef.friction = friction;
    }
    ballShapeDef.density = 1.0f;
    if(gameState.bounceTime>0){
        ballShapeDef.restitution = 1.2f;
        ballShapeDef.friction=.11;
    }else{
        ballShapeDef.restitution = restitution;
    }
    _fixture = _body->CreateFixture(&ballShapeDef);
}

- (void)tick:(ccTime) dt {
    if([gameState state]==0){
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
                float xx = 70.0/(fabs(_body->GetLinearVelocity().x)+70.0);
                self.scale=xx>self.scale?self.scale+.002:self.scale-.002;

                [gameState setScale:self.scale];
                [self swtViewCenter:ccp(ballData.position.x+60*(2/self.scale),ballData.position.y)];
                //SHIELD
                if(gameState.boostTime>0)
                    _boostshield.position=_ball.position;
                if(gameState.spinShield>0)
                    _ballshield.position=_ball.position;
                if(gameState.bounceTime>0)
                    _bounceshield.position=_ball.position;
                if(gameState.bonusTime>0)
                    _bonusshield.position=_ball.position;
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
                    [self shieldCalc];
                    if(gameState.state==1){
                        QuizLayer *q = [[QuizLayer alloc] init];
                        q->gameState=gameState;
                        [self.parent addChild:q z:10];
                    }
                }
            }
            
            
                //update positions
            for (Powerup *pow in [gameState powerups]) {
                if(ballData.position.x>pow.position.x+2000){
                    //NSLog(@"%f", _body->GetLinearVelocity().x);
                    pow.position=ccp(pow.position.x+[self calcFreq:(pow.freq/4) withMin:(pow.freq/4) withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 100));
                }
            }
            }

                //check for bg spawn
                float totalDist=[bg boundingBox].size.width+[bg1 boundingBox].size.width+[bg2 boundingBox].size.width+[bg3 boundingBox].size.width;
                if(ballData.position.x>bg.position.x+totalDist/2){
                        bg.position = ccp(bg3.position.x+bg3.boundingBox.size.width/2+bg.boundingBox.size.width/2-9,bg.position.y);
                } if(ballData.position.x>bg1.position.x+totalDist/2){
                    bg1.position = ccp(bg.position.x+bg.boundingBox.size.width/2+bg1.boundingBox.size.width/2-9,bg1.position.y);
                } if(ballData.position.x>bg2.position.x+totalDist/2){
                    bg2.position = ccp(bg1.position.x+bg1.boundingBox.size.width/2+bg2.boundingBox.size.width/2-9,bg2.position.y);
                } if(ballData.position.x>bg3.position.x+totalDist/2){
                    bg3.position = ccp(bg2.position.x+bg2.boundingBox.size.width/2+bg3.boundingBox.size.width/2-9,bg3.position.y);
                }
            totalDist=bg10.boundingBox.size.width+bg11.boundingBox.size.width;
            if(ballData.position.x>bg10.position.x+totalDist/3){
                bg10.position = ccp(bg11.position.x+bg11.boundingBox.size.width/2+bg10.boundingBox.size.width/2-9,bg10.position.y);
            } if(ballData.position.x>bg11.position.x+totalDist/3){
                bg11.position = ccp(bg10.position.x+bg10.boundingBox.size.width/2+bg11.boundingBox.size.width/2-9,bg11.position.y);
            }
            if(ballData.position.x>bg20.position.x+totalDist/3){
                bg20.position = ccp(bg21.position.x+bg21.boundingBox.size.width/2+bg20.boundingBox.size.width/2-9,bg20.position.y);
            } if(ballData.position.x>bg21.position.x+totalDist/3){
                bg21.position = ccp(bg20.position.x+bg20.boundingBox.size.width/2+bg21.boundingBox.size.width/2-9,bg21.position.y);
            }
            if(ballData.position.x>bg30.position.x+totalDist/3){
                bg30.position = ccp(bg31.position.x+bg31.boundingBox.size.width/2+bg30.boundingBox.size.width/2-9,bg30.position.y);
            }if(ballData.position.x>bg31.position.x+totalDist/3){
                bg31.position = ccp(bg30.position.x+bg30.boundingBox.size.width/2+bg31.boundingBox.size.width/2-9,bg31.position.y);
            }
            
                //update for distance
                //NSLo
                _body->SetLinearDamping((_body->GetLinearVelocity().x/500)+((ballData.position.x/100)/(40000.0+(ballData.position.x/100))));
                //int i =  ballData.position.x;
                //NSLog(@"%f", _body->GetLinearVelocity().x);
                ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
        }
    }
}

- (int)calcFreq:(int)freq withMin:(int)min withDist:(int)dist {
    return (arc4random() % freq+(dist/10)) + min;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
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
            if(firstTouch.y>lastTouch.y+60 && len>80){
                if(_body->GetLinearVelocity().y>0){
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,-3.0));
                }else{
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,_body->GetLinearVelocity().y-3.0));
                }
                if(gameState.spinShield<7){gameState.spinShield=gameState.spinShield+6;}
                [self shieldCalc];
                [gameState setCharge:(gameState.charge-1)];
            }
            if(firstTouch.y+60<lastTouch.y && len>80){
                if(_body->GetLinearVelocity().y<0){
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,3.0));
                }else{
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,_body->GetLinearVelocity().y+3.0));
                }
                if(gameState.spinShield<7){gameState.spinShield=gameState.spinShield+6;}
                [self shieldCalc];
                [gameState setCharge:(gameState.charge-1)];
            }
            //combos
        ///<<<<
        if(firstTouch.x>lastTouch.x+60 && len>80){
            comboTimer=0;
            comboVal=comboVal*10;
            [self fireShield];
        }
        ///>>>>
        if(firstTouch.x+60<lastTouch.x && len>80){
            comboTimer=0;
            comboVal=comboVal*10+1;
            [self fireShield];
        }
        }
    }
}
               
-(void)fireShield{
    if(comboVal==1010){
        gameState.spinShield=gameState.spinShield+30;
    }else if(comboVal==1101){
        gameState.bounceTime=gameState.bounceTime+30;
    }else if(comboVal==1110){
        gameState.boostTime=gameState.boostTime+30;
    }else if(comboVal==1001){
        gameState.bonusTime=gameState.bonusTime+30;
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
