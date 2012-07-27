// Import the interfaces
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
#import "math.h"
#import "Box2D.h"
#import "cocos2d.h"
#import "CCActionInterval.h"
#import "Monster.h"
#import "Ball.h"
#import "QuizScene.h"

@implementation GameScene
@synthesize layer = _layer;
@synthesize quizLayer = _quizLayer;
BOOL runAI;
CGSize winSize;
CGPoint p1center, p2center;
#define PTM_RATIO 25.0

+ (id)initNode:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn {
	return [[[self alloc] initWithMonsters:monstersIn weapons:weaponsIn] autorelease];
}

- (id)initWithMonsters:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn {
    if ((self = [super init])) {
        GameState *gameState=[[GameState alloc] init];
        self.layer = [Game initNode];
        [self.layer setGameState:gameState];
        [self addChild:_layer z:1];
    }     
    return self;
}

- (void)dealloc {
    self.layer = nil;
    [super dealloc];
}

@end


// Game implementation
@implementation Game
@synthesize world;
@synthesize gameState;
CCSprite* bg, *bg1;
b2Body *_body, *_ebody;
CCSprite *_ball, *_enemy, *_quiz;
QuizLayer *_quizLayer;
b2BodyDef ballBodyDef;
b2FixtureDef ballShapeDef;
bool paused = false;

-(void)addTarget {
    
	CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = target.contentSize.height/2;
	int maxY = winSize.height - target.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	[self addChild:target];
	// Determine speed of the target
	int minDuration = 2.0;
	int maxDuration = 4.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	// Add to targets array
	target.tag = 1;
	[_targets addObject:target];
    
    
	
}

-(void)aiTurn:(ccTime)dt {
    
}

//fired every .1 sec
-(void)gameLogic:(ccTime)dt {
    
	
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
        bg = [CCSprite spriteWithFile:@"Mario-Land.jpg"];
        bg.scale = 2;
        [bg setPosition:ccp(0,-285+bg.boundingBox.size.height/2)];
        [self addChild:bg z:0];
        bg1 = [CCSprite spriteWithFile:@"Mario-Land.jpg"];
        bg1.scale = 2;
        [bg1 setPosition:ccp([bg boundingBox].size.width-1,-285+bg.boundingBox.size.height/2)];
        [self addChild:bg1 z:0];
		// Enable touch events
		self.isTouchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
        _launchers = [[NSMutableArray alloc] init];
        _weapons = [[NSMutableArray alloc] init];
        _monsters = [[NSMutableArray alloc] init];
        _eWeapons = [[NSMutableArray alloc] init];
        _eMonsters = [[NSMutableArray alloc] init];
        
		winSize = [[CCDirector sharedDirector] winSize];
        p1center = ccp(winSize.width/2,winSize.height/8);
        p2center = ccp(winSize.width/2,7*winSize.height/8);
        //character=[Character alloc];
        
		runAI = true;
        
        // Create sprite and add it to the layer
        _ball = [Character spriteWithFile:@"FoodItemside.png"];
        _ball.position = ccp(100, 100);
        [self addChild:_ball];
        
        // Create ainitWithGame world
        b2Vec2 gravity = b2Vec2(0.0f, -30.0f);
        world = new b2World(gravity);
        world->SetContinuousPhysics(true);
        //[self setWorld:world];
        
        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        b2Body *groundBody = world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        int myWidth=999999;
        int myHeight=bg.boundingBox.size.height-285;
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
        ballBodyDef.position.Set(100/PTM_RATIO, 100/PTM_RATIO);
        ballBodyDef.userData = _ball;
        ballBodyDef.linearVelocity= b2Vec2(25,25);
        ballBodyDef.linearDamping=.1;
        _body = world->CreateBody(&ballBodyDef);
        
        b2PolygonShape circle;
        circle.SetAsBox(2, 2, b2Vec2(0, 0), .01);
        
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.3f;
        ballShapeDef.restitution = 0.59f;
        _body->CreateFixture(&ballShapeDef);
        
        _enemy =[CCSprite spriteWithFile:@"BodyItemside.png"];
        [self addChild:_enemy z:0];
        _enemy.position=ccp(-1000,50);
        
        _quiz =[CCSprite spriteWithFile:@"HeadItemside.png"];
        [self addChild:_quiz z:0];
        _quiz.position=ccp(-100,50);
        
//        Ball *anBall = [[[Ball alloc] initWithMgr:ccp(160, 240)] autorelease];
//        [self addBallToGame:anBall];
//        CCSprite *BallSprite =[CCSprite spriteWithFile:@"FoodItemside.png"];
//        [self addChild:BallSprite z:0];
//        [anBall addCCNode:(CCSprite *)BallSprite];
        
        
        [self schedule:@selector(tick:)];
        
        
        //self.isAccelerometerEnabled = YES;
		
	}
	return self;
}

// this starts the magic of adding the game piece
- (void)addBallToGame:(Ball *)aBall {
    if(aBall) {
        [aBall setGame:self];
        [aBall addBall];
    }
}

- (void)swtViewCenter:(CGPoint)point{
    CGPoint centerPoint =ccp([self boundingBox].size.width/2,[self boundingBox].size.height/2);
    CGPoint viewPoint = ccpSub(centerPoint, point);
    self.position=(ccp(viewPoint.x*self.scaleX,viewPoint.y*self.scaleY));
    
}
int i=0;

- (void)tick:(ccTime) dt {
    if([gameState state]==0){
    world->Step(dt, 10, 10);
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            if([ballData isKindOfClass:[Character class]]){
                //ZOOM
                float xx = 40.0/(fabs(b->GetLinearVelocity().x)+60.0);
                if(fabs(self.scale-xx)>.4){
                    self.scale=xx>self.scale?self.scale+.01:self.scale-.01;
                }else{
                    self.scale=xx>self.scale?self.scale+.005:self.scale-.005;
                }
                ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                        b->GetPosition().y * PTM_RATIO);
                [self swtViewCenter:ballData.position];
                //BOOST
                if([gameState boost]>0){
                    float vx=b->GetLinearVelocity().x;
                    float vy=b->GetLinearVelocity().y < 0.0 ?0.0:b->GetLinearVelocity().y;
                    b->SetLinearVelocity(b2Vec2(vx+[gameState boost],vy+[gameState boost]));
                    [gameState setBoost:0];
                }
                
                //check for enemy collision
                if(CGRectIntersectsRect(ballData.boundingBox, _enemy.boundingBox)){
                    float vx=b->GetLinearVelocity().x;
                    float vy=b->GetLinearVelocity().y < 0.0 ?0.0:b->GetLinearVelocity().y;
                    b->SetLinearVelocity(b2Vec2(vx+20,vy+50));
                    CCParticleExplosion* parc= [CCParticleExplosion node];
                    parc.texture=[_enemy texture];
                    [parc setLife:1];
                    parc.startSize=5.0f;
                    parc.endSize=10.0f;
                    parc.duration=1.0f;
                    parc.speed=90.0f;
                    [parc setTotalParticles:500];
                    [parc setGravity:ccp(0,-60)];
                    //parc.anchorPoint=ccp(.5,.5);
                    parc.position=_enemy.position;
                    parc.autoRemoveOnFinish=YES;
                    [self addChild:parc];
                    _enemy.position=ccp(_enemy.position.x+3000, _enemy.position.y);
                    
                }
                if(ballData.position.x>_enemy.position.x+900){
                    _enemy.position=ccp(_enemy.position.x+3000, _enemy.position.y);
                }
                //check for quiz collision
                if(CGRectIntersectsRect(ballData.boundingBox, _quiz.boundingBox)){
                    _quiz.position=ccp(_quiz.position.x+3000, _quiz.position.y);
                    [gameState setState:1];
                    QuizLayer *q = [[QuizLayer alloc] init];
                    [q setGameState:self.gameState];
                    [self.parent addChild:q z:10];
                }
                if(ballData.position.x>_quiz.position.x+900){
                    _quiz.position=ccp(_quiz.position.x+3000, _quiz.position.y);
                }
                //check for bg spawn
                if(ballData.position.x>bg1.position.x && ballData.position.x >bg.position.x){
                    if(bg1.position.x > bg.position.x){
                        bg.position = ccp(bg1.position.x+bg1.boundingBox.size.width-8,bg.position.y);
                        printf("2");
                    }else{
                        bg1.position = ccp(bg.position.x+bg.boundingBox.size.width-8,bg1.position.y);
                        printf("3");
                    }
                }
                //update for distance
                _body->SetLinearDamping(ballData.position.x/(4000.0+ballData.position.x));
                int i =  ballData.position.x;
                NSLog(@"%i", i);
                ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            }
        }
    }
    }
}

- (void)quizFire:(b2Body*)b {
    
    
}

- (void)update:(ccTime)dt {
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([gameState state]==0){
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {    
            if (b->GetUserData() != NULL) {
                CCSprite *ballData = (CCSprite *)b->GetUserData();
                if(location.x>240){
                    b->SetLinearVelocity(b2Vec2(b->GetLinearVelocity().x+10,b->GetLinearVelocity().y+10));
                }else{
                    b->SetLinearVelocity(b2Vec2(b->GetLinearVelocity().x-10,b->GetLinearVelocity().y+10));
                }
                if(fabs(b->GetAngularVelocity())<.05)
                    b->SetAngularVelocity(.1);
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
	location = [[CCDirector sharedDirector] convertToGL:location];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[_targets release];
	_targets = nil;
	[_projectiles release];
	_projectiles = nil;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
