
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
- (void) quiz:(b2Body *)b;
-(void)pushQuiz;
@end

@interface GameScene : CCScene
{
    Game *lay;
    QuizLayer *_quizLayer;
    HudLayer *_hudLayer;
}

- (HudLayer*) getHud;
-(void)showGame;
-(void)hideGame;
+ (id) initNode:(GameState*) gs;
- (id) initWithMonsters:(GameState*) gs;
@end

