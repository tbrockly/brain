
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "Character.h"
#import "GameTarget.h"
#import "Coin.h"
#import "QuizLayer.h"
#import "HudLayer.h"
#import "GameState.h"

// HelloWorld Layer
@interface Game : CCColorLayer
{
	NSMutableArray *_targets;
    b2World *world;
    GameState *gameState;
	int _projectilesDestroyed;
}

+ (id) initNode:(GameState*)gs;
- (id) initWithMonsters;
- (void) quizFire:(b2Body *)b;
-(void)popScene;
@end

@interface GameScene : CCScene
{
    //Game *_layer;
    QuizLayer *_quizLayer;
    HudLayer *_hudLayer;
}
+ (id) initNode:(GameState*) gs;
- (id) initWithMonsters:(GameState*) gs;
- (int) calcFreq:(int)freq withMin:(int)min withDist:(int)dist;
@end

