// Import the interfaces
#import "GameScene.h"
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
#import "Level1.h"
#import "Level2.h"
#import "Achievement.h"

#define PTM_RATIO 150.0

#define pi 3.14

@implementation GameScene
@synthesize state,comboTimer,comboVal;
@synthesize boost,score,charge;
@synthesize scale;
@synthesize rocketTime, zerograv, speed;

//@synthesize layer = _layer;

+ (id)initNode:(GameState*) gameState {
	return [[[self alloc] initWithMonsters:gameState] autorelease];
}

- (id)initWithMonsters:(GameState*) gs{
    if ((self = [super init])) {
        gameState=gs;
        gameState.state=0;
        gameState.charge=20;
        gameState.topSpeed=40;
        //SystemSoundID mySound;
        //NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"ggs" ofType:@"mp3"];
        //AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
        //player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        //player.numberOfLoops=-1;
        //player.volume=.2;
        //[player play];
        //self.layer = [Game initNode];
        //[self.layer setGameState:gameState];
        //lay = [Level1 initNode:gameState];
        //_hudLayer = [[HudLayer alloc] init:gameState];
        //[self addChild:[CCColorLayer layerWithColor:ccc4(124,106,128,255)] z:1];
        [self goToLevelSelect];


        gameState.achieves=[[NSMutableArray alloc] init];
        gameState.completeAchieves=[[NSMutableArray alloc] init];
        gameState.displayAchieves=[[NSMutableArray alloc] init];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"score 25k" xp:9001 icon:1 var1:@"score" val1:25000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"score 50k" xp:9001 icon:1 var1:@"score" val1:50000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"score 100k" xp:9001 icon:1 var1:@"score" val1:100000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"dist 25k" xp:9001 icon:1 var1:@"dist" val1:25000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"dist 50k" xp:9001 icon:1 var1:@"dist" val1:50000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"dist 100k" xp:9001 icon:1 var1:@"dist" val1:100000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totdist 100k" xp:9001 icon:1 var1:@"totdist" val1:100000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totdist 500k" xp:9001 icon:1 var1:@"totdist" val1:500000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totdist 1M" xp:9001 icon:1 var1:@"totdist" val1:1000000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totcoins 100" xp:9001 icon:1 var1:@"totcoins" val1:100]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totcoins 500" xp:9001 icon:1 var1:@"totcoins" val1:500]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totcoins 1000" xp:9001 icon:1 var1:@"totcoins" val1:1000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totcoins 5000" xp:9001 icon:1 var1:@"totcoins" val1:5000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totheight 1000" xp:9001 icon:1 var1:@"totheight" val1:1000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totheight 5000" xp:9001 icon:1 var1:@"totheight" val1:5000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totheight 10000" xp:9001 icon:1 var1:@"totheight" val1:10000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totheight 50000" xp:9001 icon:1 var1:@"totheight" val1:50000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totspin 100" xp:9001 icon:1 var1:@"totspin" val1:100]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totspin 500" xp:9001 icon:1 var1:@"totspin" val1:500]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totspin 1000" xp:9001 icon:1 var1:@"totspin" val1:1000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totspin 5000" xp:9001 icon:1 var1:@"totspin" val1:5000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totboost 100" xp:9001 icon:1 var1:@"totboost" val1:100]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totboost 500" xp:9001 icon:1 var1:@"totboost" val1:500]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totboost 1000" xp:9001 icon:1 var1:@"totboost" val1:1000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totboost 5000" xp:9001 icon:1 var1:@"totboost" val1:5000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totrocket 100" xp:9001 icon:1 var1:@"totrocket" val1:100]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totrocket 500" xp:9001 icon:1 var1:@"totrocket" val1:500]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totrocket 1000" xp:9001 icon:1 var1:@"totrocket" val1:1000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totrocket 5000" xp:9001 icon:1 var1:@"totrocket" val1:5000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totride 100" xp:9001 icon:1 var1:@"totride" val1:100]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totride 500" xp:9001 icon:1 var1:@"totride" val1:500]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totride 1000" xp:9001 icon:1 var1:@"totride" val1:1000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totride 5000" xp:9001 icon:1 var1:@"totride" val1:5000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totbonus 100" xp:9001 icon:1 var1:@"totbonus" val1:100]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totbonus 500" xp:9001 icon:1 var1:@"totbonus" val1:500]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totbonus 1000" xp:9001 icon:1 var1:@"totbonus" val1:1000]];
        [gameState.achieves addObject:[[Achievement alloc] initWithTitle:@"totbonus 5000" xp:9001 icon:1 var1:@"totbonus" val1:5000]];
    }
    return self;
}

-(void)calcAchieves{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"score"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(Achievement *a in gameState.achieves){
        if([[NSUserDefaults standardUserDefaults] integerForKey:a.var1] > a.val1){
            [gameState.displayAchieves addObject:a];
            [temp addObject:a];
        }
    }
    for(Achievement *a in temp){
        [gameState.achieves removeObject:a];
    }
}

- (HudLayer*)getHud{
    return _hudLayer;
}

- (void)stopBearMusic{
    return [bearLayer stopMusic];
}

-(void)addTotal{
    //TotalLayer* tt = [[TotalLayer alloc] init:gameState];
    lay.visible=0;
    _hudLayer.visible=0;
    bearLayer = [[BearLayer alloc] init:gameState];
    [self addChild:bearLayer z:10];
}

- (void)restart{
    [self removeChild:lay cleanup:YES];
    [self removeChild:levelSelect cleanup:YES];
    [self removeChild:_hudLayer cleanup:YES];
    [self removeChild:shopHome cleanup:YES];
    [self removeChild:bearLayer cleanup:YES];
    lay = [Level1 initNode:gameState];
    _hudLayer = [[HudLayer alloc] init:gameState];
    [self addChild:lay z:5];
    [self addChild:_hudLayer z:9];
}

- (void)goToLevelSelect{
    [self removeChild:lay cleanup:YES];
    [self removeChild:levelSelect cleanup:YES];
    [self removeChild:_hudLayer cleanup:YES];
    [self removeChild:shopHome cleanup:YES];
    [self removeChild:bearLayer cleanup:YES];
    levelSelect = [[LevelSelect alloc] init:gameState];
    
    [self addChild:levelSelect z:10];
}


- (void)goToShop{
    [self removeChild:lay cleanup:YES];
    [self removeChild:levelSelect cleanup:YES];
    [self removeChild:_hudLayer cleanup:YES];
    [self removeChild:shopHome cleanup:YES];
    [self removeChild:bearLayer cleanup:YES];
    shopHome = [[CoinShop alloc] init:gameState];

    [self addChild:shopHome z:10];
}

- (void)startLvl2:(GameState *)gs{
    [self removeChild:levelSelect cleanup:YES];
    [self removeChild:lay cleanup:YES];
    gameState=gs;
    lay = [Level2 initNode:gs];
    [self addChild:lay z:5];
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
