// Import the interfaces
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
#import "math.h"
#import "Box2D.h"

@implementation GameScene
@synthesize layer = _layer;
BOOL runAI;
CGSize winSize;
CGPoint p1center, p2center;
#define PTM_RATIO 32.0

+ (id)initNode:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn {
	return [[[self alloc] initWithMonsters:monstersIn weapons:weaponsIn] autorelease];
}

- (id)initWithMonsters:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn {
    if ((self = [super init])) {
        self.layer = [Game initNode:monstersIn weapons:weaponsIn];
        [self addChild:_layer];
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

b2World *_world;
b2Body *_body;
CCSprite *_ball;

+ (id)initNode:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn {
	return [[[self alloc] initWithMonsters:monstersIn weapons:weaponsIn] autorelease];
}

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
    //[character 
//        for(Weapon *wep in weaponsToDelete){
//            [_weapons removeObject:wep];
//            [self removeChild:wep.sprite cleanup:YES];
//        }
//        [weaponsToDelete removeAllObjects];
//        [weaponsToDelete release];
	
}

// on "init" you need to initialize your instance
- (id)initWithMonsters:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn 
{
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(200,200,200,200)] )) {
        
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
        character=[Character alloc];
        
		runAI = true;
        
        // Create sprite and add it to the layer
        _ball = [CCSprite spriteWithFile:@"Projectile.png" rect:CGRectMake(0, 0, 20, 20)];
        _ball.position = ccp(100, 100);
        [self addChild:_ball];
        
        // Create a world
        b2Vec2 gravity = b2Vec2(0.0f, -30.0f);
        _world = new b2World(gravity);
        
        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        b2Body *groundBody = _world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        groundEdge.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(0, winSize.height/PTM_RATIO), 
                       b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(winSize.width/PTM_RATIO, 
                              winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        // Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(100/PTM_RATIO, 100/PTM_RATIO);
        ballBodyDef.userData = _ball;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        ballShapeDef.restitution = 0.8f;
        _body->CreateFixture(&ballShapeDef);
        
        [self schedule:@selector(tick:)];
        
        self.isAccelerometerEnabled = YES;
		
	}
	return self;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // Landscape left values
    b2Vec2 gravity(-acceleration.y * 15, acceleration.x *15);
    _world->SetGravity(gravity);
    
}

- (void)swtViewCenter:(CGPoint)point{
    CGPoint centerPoint =ccp(240,160);
    CGPoint viewPoint = ccpSub(centerPoint, point);
    self.position=viewPoint;
    
}

- (void)tick:(ccTime) dt {
    
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {    
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                    b->GetPosition().y * PTM_RATIO);
            [self swtViewCenter:ballData.position];
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }        
    }
    
}

- (void)update:(ccTime)dt {
    
}

- (void)pauseGame {
    NSLog(@"Paused!");
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
}

- (void)setLauncherWeapon{//(Weapon *)myWep{
//    for (Launcher *myLauncher in _launchers) {
//        [[[myLauncher weapon] sprite] removeFromParentAndCleanup:true];
//        [myLauncher setWeapon:myWep];
//        myLauncher.weapon.sprite.positionInPixels=myLauncher.sprite.positionInPixels;
//        [self addChild:[[myLauncher weapon] sprite]];
//    }
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
    
	//CGPoint point = [touch locationInView:self];
	//UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(point.x , point.y,50 ,70)];
	//bg.image = [UIImage imageNamed:@"bear.png"];
	//[self addSubview:bg];
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
