// Import the interfaces
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
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

@implementation GameScene
//@synthesize layer = _layer;
@synthesize quizLayer = _quizLayer;
@synthesize hudLayer = _hudLayer;
BOOL runAI;
CGSize winSize;
CGPoint firstTouch, lastTouch;
#define PTM_RATIO 150.0
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000
#define pi 3.14

+ (id)initNode {
	return [[[self alloc] initWithMonsters] autorelease];
}

- (id)initWithMonsters{
    if ((self = [super init])) {
        GameState *gameState=[[GameState alloc] init];
        gameState.charge=20;
        gameState.topSpeed=100;
        //self.layer = [Game initNode];
        //[self.layer setGameState:gameState];
        Game *lay = [Game initNode];
        [lay setGameState:gameState];
        HudLayer *hudLayer = [[HudLayer alloc] init];;
        [hudLayer setGameState:gameState];
        [self addChild:[CCColorLayer layerWithColor:ccc4(124,106,128,255)]];
        [self addChild:lay z:2 tag:0];
        [self addChild:hudLayer z:3 tag:1];
    }     
    return self;
}

- (void)dealloc {
    //self.layer = nil;
    [super dealloc];
}

@end


// Game implementation
@implementation Game
@synthesize world;
@synthesize gameState;
CCSprite* bg, *bg1, *bg2, *bg3, *bg10,*bg11,*bg20,*bg21,*bg30,*bg31;
b2Body *_body, *_ebody;
CCSprite *_ball, *_quiz, *_ride, *_spin, *_target, *_coin, *_bonus, *_energy, *_rocket;
CCSprite *_bonusshield,*_ballshield,*_bounceshield,*_boostshield;
QuizLayer *_quizLayer;
b2BodyDef ballBodyDef;
b2FixtureDef ballShapeDef;
b2Fixture *_fixture;
NSUserDefaults *defaults2;
NSMutableArray *powerups;
int comboTimer,comboVal;
AchievementEngine *achEngine;
bool paused = false;
bool flattened = false;

-(void)addTarget {
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = _target.contentSize.height/2;
	int maxY = winSize.height - _target.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	_target.position = ccp(winSize.width + (_target.contentSize.width/2), actualY);
	[self addChild:_target];
	// Determine speed of the target
	int minDuration = 2.0;
	int maxDuration = 4.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-_target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[_target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	// Add to targets array
	_target.tag = 1;
	[_targets addObject:_target];
    
    
	
}

+ (id)initNode {
	return [[[self alloc] initWithMonsters] autorelease];
}

// on "init" you need to initialize your instance
- (id)initWithMonsters 
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(155,155,155,255)] )) {
        defaults2=[NSUserDefaults standardUserDefaults];
        powerups=[[NSMutableArray alloc] init];
        [defaults2 setInteger:1 forKey:@"airResist"];
        [defaults2 setInteger:1 forKey:@"enemyFreq"];
        [defaults2 setInteger:1 forKey:@"quizFreq"];
        [defaults2 setInteger:1 forKey:@"enemyBoost"];
        [defaults2 setInteger:1 forKey:@"quizBoost"];
        [defaults2 setFloat:1 forKey:@"gravity"];
        [defaults2 setInteger:1 forKey:@"friction"];
        [defaults2 setInteger:1 forKey:@"quizDifficulty"];
        [defaults2 setInteger:1 forKey:@"topSpeed"];
        [defaults2 setInteger:4 forKey:@"charge"];
        [defaults2 setInteger:1 forKey:@"airResist"];
        [defaults2 setInteger:1 forKey:@"coinFreq"];
        [defaults2 setInteger:1 forKey:@"energyFreq"];
        [defaults2 setInteger:1 forKey:@"bonusFreq"];
        [defaults2 setInteger:1 forKey:@"rocketFreq"];
        //[defaults2 integerForKey:@"airResist"]+
        NSMutableArray *coins=[NSMutableArray arrayWithObjects: nil];
        [gameState setCoins:coins];
        AchievementEngine *achEng=[[AchievementEngine alloc] init:defaults2];
        [gameState setAchEng:achEng];
        int scale=3;
        _target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)]; 
        bg = [CCSprite spriteWithFile:@"slice_3_0.jpg"];
        bg.scale = scale;
        [bg setPosition:ccp(1000,-500+bg.boundingBox.size.height/2)];
        [self addChild:bg z:0];
        bg1 = [CCSprite spriteWithFile:@"slice_3_1.jpg"];
        bg1.scale = scale;
        [bg1 setPosition:ccp([bg boundingBox].size.width/2+[bg1 boundingBox].size.width/2,-500+bg1.boundingBox.size.height/2)];
        [self addChild:bg1 z:0];
        bg2 = [CCSprite spriteWithFile:@"slice_3_2.jpg"];
        bg2.scale = scale;
        //bg2.color=ccc3(10, 10, 200);
        [bg2 setPosition:ccp(-9000,-500+bg2.boundingBox.size.height/2)];
        [self addChild:bg2 z:0];
        bg3 = [CCSprite spriteWithFile:@"slice_3_3.jpg"];
        bg3.scale = scale;
        [bg3 setPosition:ccp(-9000,-500+bg3.boundingBox.size.height/2)];
        [self addChild:bg3 z:0];
        bg10 = [CCSprite spriteWithFile:@"slice_2_0.jpg"];
        bg10.scale = scale;
        [bg10 setPosition:ccp(0,-510+bg.boundingBox.size.height+bg10.boundingBox.size.height/2)];
        [self addChild:bg10 z:0];
        bg11 = [CCSprite spriteWithFile:@"slice_2_0.jpg"];
        bg11.scale = scale;
        [bg11 setPosition:ccp(-6000,-510+bg.boundingBox.size.height+bg11.boundingBox.size.height/2)];
        [self addChild:bg11 z:0];
        bg20 = [CCSprite spriteWithFile:@"slice_1_0.jpg"];
        bg20.scale = scale;
        [bg20 setPosition:ccp(-5000,-520+bg.boundingBox.size.height+bg10.boundingBox.size.height+bg20.boundingBox.size.height/2)];
        [self addChild:bg20 z:0];
        bg21 = [CCSprite spriteWithFile:@"slice_1_0.jpg"];
        bg21.scale = scale;
        [bg21 setPosition:ccp(-4000,-520+bg.boundingBox.size.height+bg10.boundingBox.size.height+bg20.boundingBox.size.height/2)];
        [self addChild:bg21 z:0];
        bg30 = [CCSprite spriteWithFile:@"slice_0_0.jpg"];
        bg30.scale = scale;
        [bg30 setPosition:ccp(-3000,-530+bg.boundingBox.size.height+bg10.boundingBox.size.height+bg20.boundingBox.size.height+bg30.boundingBox.size.height/2)];
        [self addChild:bg30 z:0];
        bg31 = [CCSprite spriteWithFile:@"slice_0_0.jpg"];
        bg31.scale = scale;
        [bg31 setPosition:ccp(-2000,-530+bg.boundingBox.size.height+bg10.boundingBox.size.height+bg20.boundingBox.size.height+bg30.boundingBox.size.height/2)];
        [self addChild:bg31 z:0];
        
        
        
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
        [self addChild:_ball];
        // SHIELDS
        _boostshield = [CCSprite spriteWithFile:@"shield2.png"];
        _boostshield.position = ccp(100, 100);
        _boostshield.scale=1.1;
        [self addChild:_boostshield];
        _bonusshield = [CCSprite spriteWithFile:@"shield3.png"];
        _bonusshield.position = ccp(100, 100);
        [self addChild:_bonusshield];
        _bounceshield = [CCSprite spriteWithFile:@"shield4.png"];
        _bounceshield.position = ccp(100, 100);
        _boostshield.scale=.9;
        [self addChild:_bounceshield];
        _ballshield = [CCSprite spriteWithFile:@"shield1.png"];
        _ballshield.position = ccp(100, 100);
        _ballshield.scale=.8;
        [self addChild:_ballshield];
        
        // Create ainitWithGame world
        
        b2Vec2 gravity = b2Vec2(0.0f, [defaults2 floatForKey:@"gravity"]-6.0f);
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
        ballBodyDef.linearVelocity= b2Vec2(6,6);
        ballBodyDef.linearDamping=0;
        _body = world->CreateBody(&ballBodyDef);
        
        b2PolygonShape box;
        box.SetAsBox(.33, .33, b2Vec2(0, 0), .01);
        
        ballShapeDef.shape = &box;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.31f;
        ballShapeDef.restitution = 0.69f;
        _fixture = _body->CreateFixture(&ballShapeDef);
        
        if(fabs(_body->GetAngularVelocity())<.05)
            _body->SetAngularVelocity(.1);
        
        Boost *boostPow=[[Boost alloc] initSelf];
        [self addChild:boostPow z:0];
        boostPow.position=ccp(-1000,50);
        [powerups addObject:boostPow];
        
        Ride *ridePow=[[Ride alloc] initSelf];
        [self addChild:ridePow z:0];
        ridePow.position=ccp(-1000,50);
        [powerups addObject:ridePow];
        
        Quiz *quizPow=[[Quiz alloc] initSelf];
        [self addChild:quizPow z:0];
        quizPow.position=ccp(-1000,50);
        [powerups addObject:quizPow];
        
        Spin *spinPow=[[Spin alloc] initSelf];
        [self addChild:spinPow z:0];
        spinPow.position=ccp(-1000,50);
        [powerups addObject:spinPow];
        
        PCoin *coinPow=[[PCoin alloc] initSelf];
        [self addChild:coinPow z:0];
        coinPow.position=ccp(-1000,50);
        [powerups addObject:coinPow];
        
        _energy =[CCSprite spriteWithFile:@"lightning-icon.png"];
        _energy.scale=1;
        [self addChild:_energy z:0];
        _energy.position=ccp(-100,50);
        
        Bonus *bonusPow=[[Bonus alloc] initSelf];
        [self addChild:bonusPow z:0];
        bonusPow.position=ccp(-1000,50);
        [powerups addObject:bonusPow];
        
        Rocket *rocketPow=[[Rocket alloc] initSelf];
        [self addChild:rocketPow z:0];
        rocketPow.position=ccp(-1000,50);
        [powerups addObject:rocketPow];
        
        self.scale=.4;
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
            [[CCDirector sharedDirector] replaceScene:[GameScene initNode]];
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
        if(gameState.rocketTime==-1){
            //[self removeChild:_ball cleanup:NO];
            //_ball =[[CCSprite alloc] initWithFile:@"brain_grrr.png"];
            //[self addChild:_ball];
        }else{
            //[self removeChild:_ball cleanup:NO];
            //_ball =[[CCSprite alloc] initWithFile:@"brain_grrr.png"];
            //[self addChild:_ball];
        }
    }//ZEROGRAV
    if(gameState.zerograv>=0){
        gameState.zerograv--;
        if(gameState.zerograv==-1){
            world->SetGravity(b2Vec2(0.0f, [defaults2 floatForKey:@"gravity"]-6.0f));
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

-(void)shieldCalc{
    if(gameState.spinShield>0){
        _body->DestroyFixture(_fixture);
        b2CircleShape circle;
        circle.m_radius=50/PTM_RATIO;
        ballShapeDef.shape = &circle;
        ballShapeDef.friction = 0.11f;
    }else{
        _body->DestroyFixture(_fixture);
        b2PolygonShape box;
        box.SetAsBox(.33, .33, b2Vec2(0, 0), .01);
        
        ballShapeDef.shape = &box;
        ballShapeDef.friction = 0.31f;
    }
    ballShapeDef.density = 1.0f;
    if(gameState.bounceTime>0){
        ballShapeDef.restitution = 1.2f;
    }else{
        ballShapeDef.restitution = .69f;
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
                //ZOOM
                float xx = 15.0/(fabs(_body->GetLinearVelocity().x)+50.0);
                self.scale=xx>self.scale?self.scale+.002:self.scale-.002;

                [gameState setScale:self.scale];
                [self swtViewCenter:ccp(ballData.position.x+100*(.5/self.scale),ballData.position.y-150)];
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
                
                //check for enemy collision
            for (Powerup *pow in powerups) {
                if(CGRectIntersectsRect(ballData.boundingBox, pow.boundingBox)){
                    [pow collide: _body gameState:gameState];
                    [[self.parent getChildByTag:1] createCoins:2];
                    if(gameState.state==1){
                        QuizLayer *q = [[QuizLayer alloc] init];
                        [q setGameState:self.gameState];
                        [self.parent addChild:q z:10];
                    }
                }
            }
                
                //update positions
            for (Boost *pow in powerups) {
                if(ballData.position.x>pow.position.x+2000){
                    //NSLog(@"%f", _body->GetLinearVelocity().x);
                    pow.position=ccp(pow.position.x+[self calcFreq:4000 withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                }
            }

                //check for bg spawn
                float totalDist=[bg boundingBox].size.width+[bg1 boundingBox].size.width+[bg2 boundingBox].size.width+[bg3 boundingBox].size.width;
                if(ballData.position.x>bg.position.x+totalDist/2){
                        bg.position = ccp(bg3.position.x+bg3.boundingBox.size.width/2+bg.boundingBox.size.width/2-9,bg.position.y);
                }else if(ballData.position.x>bg1.position.x+totalDist/2){
                    bg1.position = ccp(bg.position.x+bg.boundingBox.size.width/2+bg1.boundingBox.size.width/2-9,bg1.position.y);
                }else if(ballData.position.x>bg2.position.x+totalDist/2){
                    bg2.position = ccp(bg1.position.x+bg1.boundingBox.size.width/2+bg2.boundingBox.size.width/2-9,bg2.position.y);
                }else if(ballData.position.x>bg3.position.x+totalDist/2){
                    bg3.position = ccp(bg2.position.x+bg2.boundingBox.size.width/2+bg3.boundingBox.size.width/2-9,bg3.position.y);
                }
            totalDist=bg10.boundingBox.size.width+bg11.boundingBox.size.width;
            if(ballData.position.x>bg10.position.x+totalDist/2){
                bg10.position = ccp(bg11.position.x+bg11.boundingBox.size.width/2+bg10.boundingBox.size.width/2-9,bg10.position.y);
            }else if(ballData.position.x>bg11.position.x+totalDist/2){
                bg11.position = ccp(bg10.position.x+bg10.boundingBox.size.width/2+bg11.boundingBox.size.width/2-9,bg11.position.y);
            }
            if(ballData.position.x>bg20.position.x+totalDist/2){
                bg20.position = ccp(bg21.position.x+bg21.boundingBox.size.width/2+bg20.boundingBox.size.width/2-9,bg20.position.y);
            }else if(ballData.position.x>bg21.position.x+totalDist/2){
                bg21.position = ccp(bg20.position.x+bg20.boundingBox.size.width/2+bg21.boundingBox.size.width/2-9,bg21.position.y);
            }
            if(ballData.position.x>bg30.position.x+totalDist/2){
                bg30.position = ccp(bg31.position.x+bg31.boundingBox.size.width/2+bg30.boundingBox.size.width/2-9,bg30.position.y);
            }else if(ballData.position.x>bg31.position.x+totalDist/2){
                bg31.position = ccp(bg30.position.x+bg30.boundingBox.size.width/2+bg31.boundingBox.size.width/2-9,bg31.position.y);
            }
            
                //update for distance
                _body->SetLinearDamping((ballData.position.x/100)/(40000.0+(ballData.position.x/100)));
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
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        lastTouch = [[CCDirector sharedDirector] convertToGL:location];
        float len=ccpDistance(firstTouch,lastTouch);
        
        if(fabs(_body->GetAngularVelocity())<.05)
            _body->SetAngularVelocity(.05);
        if(gameState.rocketTime>-1){
            if(firstTouch.x+60<lastTouch.x && len>80){
                _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+len/100,_body->GetLinearVelocity().y+len/200));
            }
        }else if(gameState.charge>0) {
            if(firstTouch.y>lastTouch.y+60 && len>80){
                if(_body->GetLinearVelocity().y>0){
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,-10.0));
                }else{
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,_body->GetLinearVelocity().y-10.0));
                }
                if(gameState.spinShield<7){gameState.spinShield=gameState.spinShield+6;}
                [self shieldCalc];
                [gameState setCharge:(gameState.charge-1)];
            }
            if(firstTouch.y+60<lastTouch.y && len>80){
                if(_body->GetLinearVelocity().y<0){
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,10.0));
                }else{
                    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,_body->GetLinearVelocity().y+10.0));
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
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
