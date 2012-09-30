// Import the interfaces
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
#import "math.h"
#import "Box2D.h"
#import "cocos2d.h"
#import "CCActionInterval.h"
#import "Monster.h"

@implementation GameScene
//@synthesize layer = _layer;
@synthesize quizLayer = _quizLayer;
BOOL runAI;
CGSize winSize;
CGPoint firstTouch, lastTouch ;
#define PTM_RATIO 150.0
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

+ (id)initNode {
	return [[[self alloc] initWithMonsters] autorelease];
}

- (id)initWithMonsters{
    if ((self = [super init])) {
        GameState *gameState=[[GameState alloc] init];
        //self.layer = [Game initNode];
        //[self.layer setGameState:gameState];
        Game *lay = [Game initNode];
        [lay setGameState:gameState];
        HudLayer *lay2 = [[HudLayer alloc] init];;
        [lay2 setGameState:gameState];
        [self addChild:lay z:0 tag:0];
        [self addChild:lay2 z:1 tag:1];
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
CCSprite* bg, *bg1, *bg2, *bg3;
b2Body *_body, *_ebody;
CCSprite *_ball, *_enemy, *_quiz, *_ride, *_spin, *_target;
CCSprite *_bonusshield,*_ballshield,*_bounceshield,*_boostshield;
QuizLayer *_quizLayer;
b2BodyDef ballBodyDef;
b2FixtureDef ballShapeDef;
b2Fixture *_fixture;
NSUserDefaults *defaults2;
NSMutableArray *coins;
int zerograv,timeout,balltimeout,boosttimeout,bonustimeout,bouncetimeout,comboTimer,comboVal;
float enemyFreq, quizFreq, airResist, speedBoost, friction;
bool paused = false;

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
	if( (self=[super init] )) {
        defaults2=[NSUserDefaults standardUserDefaults];
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
        //[defaults2 integerForKey:@"airResist"]+1
        coins=[NSMutableArray arrayWithObjects: nil];
        [coins retain];
        enemyFreq=10;
        quizFreq=50;
        zerograv=-1;
        balltimeout=-1;
        _target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)]; 
        bg = [CCSprite spriteWithFile:@"BG1.jpg"];
        bg.scale = 2;
        [bg setPosition:ccp(0,-500+bg.boundingBox.size.height/2)];
        [self addChild:bg z:0];
        bg1 = [CCSprite spriteWithFile:@"BG2.jpg"];
        bg1.scale = 2;
        [bg1 setPosition:ccp([bg boundingBox].size.width/2+[bg1 boundingBox].size.width/2,-500+bg1.boundingBox.size.height/2)];
        [self addChild:bg1 z:0];
        bg2 = [CCSprite spriteWithFile:@"BG3.jpg"];
        bg2.scale = 2;
        //bg2.color=ccc3(10, 10, 200);
        [bg2 setPosition:ccp([bg boundingBox].size.width/2+[bg1 boundingBox].size.width+[bg2 boundingBox].size.width/2,-500+bg2.boundingBox.size.height/2)];
        [self addChild:bg2 z:0];
        bg3 = [CCSprite spriteWithFile:@"BG4.jpg"];
        bg3.scale = 2;
        [bg3 setPosition:ccp([bg boundingBox].size.width/2+[bg1 boundingBox].size.width+[bg2 boundingBox].size.width+[bg3 boundingBox].size.width/2,-500+bg3.boundingBox.size.height/2)];
        [self addChild:bg3 z:0];
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
        ballBodyDef.linearVelocity= b2Vec2(4,4);
        ballBodyDef.linearDamping=0;
        _body = world->CreateBody(&ballBodyDef);
        
        b2PolygonShape box;
        box.SetAsBox(.33, .33, b2Vec2(0, 0), .01);
        
        ballShapeDef.shape = &box;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.21f;
        ballShapeDef.restitution = 0.69f;
        _fixture = _body->CreateFixture(&ballShapeDef);
        
        if(fabs(_body->GetAngularVelocity())<.05)
            _body->SetAngularVelocity(.1);
        
        _enemy =[CCSprite spriteWithFile:@"BodyItemside.png"];
        [self addChild:_enemy z:0];
        _enemy.position=ccp(-1000,50);
        
        _quiz =[CCSprite spriteWithFile:@"HeadItemside.png"];
        [self addChild:_quiz z:0];
        _quiz.position=ccp(-100,50);
        
        _ride =[CCSprite spriteWithFile:@"FoodItemside.png"];
        [self addChild:_ride z:0];
        _ride.position=ccp(-100,50);
        
        _spin =[CCSprite spriteWithFile:@"Projectile.png"];
        [self addChild:_spin z:0];
        _spin.position=ccp(-100,50);
        
//        Ball *anBall = [[[Ball alloc] initWithMgr:ccp(160, 240)] autorelease];
//        [self addBallToGame:anBall];
//        CCSprite *BallSprite =[CCSprite spriteWithFile:@"FoodItemside.png"];
//        [self addChild:BallSprite z:0];
//        [anBall addCCNode:(CCSprite *)BallSprite];
        
        
        [self schedule:@selector(tick:)];
        [self schedule:@selector(calc:) interval:.5f];
        [gameState setCharge:4];
        //self.isAccelerometerEnabled = YES;
		
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
    comboTimer++;
    if(comboTimer>2){
        comboVal=1;
    }
    //count 
    if(_body->GetLinearVelocity().x ==0){
        timeout++;  
        if(timeout>3){
            [[CCDirector sharedDirector] replaceScene:[GameScene initNode]];
        }
    }else{
        timeout=0;
    }
    //ZEROGRAV
    if(zerograv>=0){
        zerograv--;
        if(zerograv==-1){
            world->SetGravity(b2Vec2(0.0f, [defaults2 floatForKey:@"gravity"]-6.0f));
        }else{
            world->SetGravity(b2Vec2(0.0f,0.0f));
        }
    }//BALLTIMEOUT
    if(balltimeout>=0){
        balltimeout--;
        if(balltimeout==-1){
            [self shieldCalc];
            _ballshield.position=ccp(0,0);
        }
    }//BOUNCETIMEOUT
    if(bouncetimeout>=0){
        bouncetimeout--;
        if(bouncetimeout==-1){
            [self shieldCalc];
            _bounceshield.position=ccp(0,0);
        }
    }//BONUSTIMEOUT
    if(bonustimeout>=0){
        bonustimeout--;
        if(bonustimeout==-1){
            [self shieldCalc];
            _bonusshield.position=ccp(0,0);
        }
    }//BOOSTTIMEOUT
    if(boosttimeout>=0){
        boosttimeout--;
        if(boosttimeout==-1){
            [self shieldCalc];
            _boostshield.position=ccp(0,0);
        }
    }
}

-(void)shieldCalc{
    if(balltimeout>0){
        _body->DestroyFixture(_fixture);
        b2CircleShape circle;
        circle.m_radius=100/PTM_RATIO;
        ballShapeDef.shape = &circle;
    }else{
        _body->DestroyFixture(_fixture);
        b2PolygonShape box;
        box.SetAsBox(.33, .33, b2Vec2(0, 0), .01);
        ballShapeDef.shape = &box;
    }
    ballShapeDef.density = 1.0f;
    if(bouncetimeout>0){
        ballShapeDef.friction = 0.21f;
        ballShapeDef.restitution = 1.0f;
    }else{
        ballShapeDef.friction = 0.21f;
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
                if(fabs(self.scale-xx)>.4){
                    self.scale=xx>self.scale?self.scale+.01:self.scale-.01;
                }else{
                    self.scale=xx>self.scale?self.scale+.005:self.scale-.005;
                }
                [gameState setScale:self.scale];
                [self swtViewCenter:ccp(ballData.position.x+100*(.5/self.scale),ballData.position.y-150)];
                //SHIELD
                if(boosttimeout>0)
                    _boostshield.position=_ball.position;
                if(balltimeout>0)
                    _ballshield.position=_ball.position;
                if(bouncetimeout>0)
                    _bounceshield.position=_ball.position;
                if(bonustimeout>0)
                    _bonusshield.position=_ball.position;
                //BOOST
                if([gameState boost]>0){
                    float vx=_body->GetLinearVelocity().x;
                    float vy=_body->GetLinearVelocity().y < 0.0 ?0.0:_body->GetLinearVelocity().y;
                    _body->SetLinearVelocity(b2Vec2(vx+[gameState boost],vy+[gameState boost]*.8));
                    [gameState setBoost:0];
                }
                [gameState setScore:_ball.position.x];
                
                //check for enemy collision
                if(CGRectIntersectsRect(ballData.boundingBox, _enemy.boundingBox)){
                    float vx=_body->GetLinearVelocity().x;
                    float vy=_body->GetLinearVelocity().y < 0.0 ?0.0:_body->GetLinearVelocity().y;
                    _body->SetLinearVelocity(b2Vec2(vx+5,fabs(vy)+8));
//                    CCParticleExplosion* parc= [CCParticleExplosion node];
//                    parc.texture=[_enemy texture];
//                    [parc setLife:1];
//                    parc.startSize=5.0f;
//                    parc.endSize=10.0f;
//                    parc.duration=2.0f;
//                    parc.speed=900.0f;
//                    [parc setTotalParticles:500];
//                    [parc setGravity:ccp(ballData.position.x - _enemy.position.x,ballData.position.y - _enemy.position.y)];
//                    //parc.anchorPoint=ccp(.5,.5);
//                    parc.position=_enemy.position;
//                    parc.autoRemoveOnFinish=YES;
//                    [self addChild:parc];
                    
                    [[self.parent getChildByTag:1] createCoins:5];
                    
                    _enemy.position=ccp(_enemy.position.x+[self calcFreq:enemyFreq withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                }
                
                //check for quiz collision
                if(CGRectIntersectsRect(ballData.boundingBox, _quiz.boundingBox)){
                    _quiz.position=ccp(_quiz.position.x+[self calcFreq:quizFreq withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                    [gameState setState:1];
                    QuizLayer *q = [[QuizLayer alloc] init];
                    [q setGameState:self.gameState];
                    [self.parent addChild:q z:10];
                }
                
                //check for ride collision
                if(CGRectIntersectsRect(ballData.boundingBox, _ride.boundingBox)){
                    _ride.position=ccp(_ride.position.x+[self calcFreq:quizFreq withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                    _body->SetLinearVelocity(b2Vec2(fabs(_body->GetLinearVelocity().x)+fabs(_body->GetLinearVelocity().y)+6.0,0));
                    zerograv=10;
                }
                
                //check for spin collision
                if(CGRectIntersectsRect(ballData.boundingBox, _spin.boundingBox)){
                    _spin.position=ccp(_spin.position.x+[self calcFreq:900 withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                    _body->SetAngularVelocity(-50);
                    balltimeout=30;
                    [self shieldCalc];
                }
                
                //update positions
                
                if(ballData.position.x>_enemy.position.x+2000){
                    _enemy.position=ccp(_enemy.position.x+[self calcFreq:enemyFreq withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                }
                if(ballData.position.x>_quiz.position.x+2000){
                    _quiz.position=ccp(_quiz.position.x+[self calcFreq:quizFreq withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                }
                if(ballData.position.x>_ride.position.x+2000){
                    _ride.position=ccp(_ride.position.x+[self calcFreq:quizFreq withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                }
                if(ballData.position.x>_spin.position.x+2000){
                    _spin.position=ccp(_spin.position.x+[self calcFreq:900 withMin:4000 withDist:ballData.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballData.position.y-HEIGHTDIFF withDist:0], 0));
                }
                //check for bg spawn
                float totalDist=[bg boundingBox].size.width+[bg1 boundingBox].size.width+[bg2 boundingBox].size.width+[bg3 boundingBox].size.width;
                if(ballData.position.x>bg.position.x+totalDist/2){
                        bg.position = ccp(bg.position.x+totalDist,bg.position.y);
                }else if(ballData.position.x>bg1.position.x+totalDist/2){
                    bg1.position = ccp(bg1.position.x+totalDist,bg1.position.y);
                }else if(ballData.position.x>bg2.position.x+totalDist/2){
                    bg2.position = ccp(bg2.position.x+totalDist,bg2.position.y);
                }else if(ballData.position.x>bg3.position.x+totalDist/2){
                    bg3.position = ccp(bg3.position.x+totalDist,bg3.position.y);
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
//    if(min<0){
//        NSLog(@"%i",((arc4random() % (freq+dist/10)) + min));
//    }
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
            _body->SetAngularVelocity(.1);
        if(firstTouch.y>lastTouch.y+60 && len>80){
            if(_body->GetLinearVelocity().y>0){
                _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,-10.0));
            }else{
                _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,_body->GetLinearVelocity().y-10.0));
            }
            [gameState setCharge:(gameState.charge-1)];
        }
        if(firstTouch.y+60<lastTouch.y && len>80){
            if(_body->GetLinearVelocity().y<0){
                _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,10.0));
            }else{
                _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x+2.0,_body->GetLinearVelocity().y+10.0));
            }
            [gameState setCharge:(gameState.charge-1)];
        }
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
               
-(void)fireShield{
    if(comboVal==1010){
        balltimeout=balltimeout+30;
    }else if(comboVal==1101){
        bouncetimeout=bouncetimeout+30;
    }else if(comboVal==1110){
        boosttimeout=boosttimeout+30;
    }else if(comboVal==1001){
        bonustimeout=bonustimeout+30;
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
