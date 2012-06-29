// Import the interfaces
#import "BearScene.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
#import "math.h"

@implementation BearScene
@synthesize layer = _layer;
BOOL runAI;
CGSize winSize;
CGPoint p1center, p2center;

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
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        
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
        
        
		runAI = true;
		
	}
	return self;
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
	for (Launcher *myLauncher in _launchers) {
        if(myLauncher.launching ==1){
            // Determine where we wish to shoot the projectile to
            int realX = [[myLauncher weapon] sprite].position.x+myLauncher.power*(myLauncher.sprite.position.x-location.x);
            long wepHalfWidth = myLauncher.weapon.sprite.contentSize.width/2;
            long wepHalfHeight = myLauncher.weapon.sprite.contentSize.height/2;
            if(realX>winSize.width-wepHalfWidth){
                realX=winSize.width-wepHalfWidth;
            }else if(realX<0+wepHalfWidth){
                realX=wepHalfWidth;
            }
            int realY = [[myLauncher weapon] sprite].position.y+myLauncher.power*(myLauncher.sprite.position.y-location.y);
            if(realY>winSize.height-wepHalfHeight){
                realY=winSize.height-wepHalfHeight;
            }else if(realY<0+wepHalfHeight){
                realY=wepHalfHeight;
            }
            CGPoint realDest = ccp(realX, realY);
            
            // Determine the length of how far we're shooting
            int offRealX = realX - location.x;
            int offRealY = realY - location.y;
            float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
            float velocity = 480/1; // 480pixels/1sec
            float realMoveDuration = length/velocity;
            
            myLauncher.weapon.midair=1;
            [[[myLauncher weapon] sprite] runAction:[CCSequence actions:
                                                     [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                                                     [CCCallFunc actionWithTarget:[myLauncher weapon] selector:@selector(land)],
                                                     nil]];
            [_weapons addObject:[myLauncher weapon]];
            myLauncher.weapon=NULL;
            myLauncher.launching=0;
        }
    }
    for(Weapon *equipWeapon in _eWeapons){
        CGRect weaponRect = CGRectMake(equipWeapon.sprite.position.x - (equipWeapon.sprite.contentSize.width/2), 
                                       equipWeapon.sprite.position.y - (equipWeapon.sprite.contentSize.height/2), 
                                       equipWeapon.sprite.contentSize.width, 
                                       equipWeapon.sprite.contentSize.height);
        if(CGRectContainsPoint(weaponRect,location)){
            for (Launcher *myLauncher in _launchers) {
                Weapon *newWeapon=[equipWeapon copy];
                [self removeChild:myLauncher.weapon.sprite cleanup:YES];
                [myLauncher setWeapon:newWeapon];
                [[myLauncher weapon] sprite].positionInPixels=myLauncher.sprite.positionInPixels;
                [self addChild:[[myLauncher weapon] sprite]];
                myLauncher.launching=0;
                [newWeapon release];
            }
        }
    }
}

- (void)setLauncherWeapon:(Weapon *)myWep{
    for (Launcher *myLauncher in _launchers) {
        [[[myLauncher weapon] sprite] removeFromParentAndCleanup:true];
        [myLauncher setWeapon:myWep];
        myLauncher.weapon.sprite.positionInPixels=myLauncher.sprite.positionInPixels;
        [self addChild:[[myLauncher weapon] sprite]];
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (Launcher *myLauncher in _launchers) {
        if(myLauncher.launching ==1){
            [myLauncher.weapon sprite].position=location;
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (Launcher *myLauncher in _launchers) {
        if(myLauncher.weapon){
            CCSprite *launcherSprite=[myLauncher.weapon sprite];
            CGRect launcherRect = CGRectMake(launcherSprite.position.x - (launcherSprite.contentSize.width/2), 
                                             launcherSprite.position.y - (launcherSprite.contentSize.height/2), 
                                             launcherSprite.contentSize.width, 
                                             launcherSprite.contentSize.height);
            if (CGRectContainsPoint(launcherRect,location)) {
                myLauncher.launching=1;
            }
        }
    }
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
