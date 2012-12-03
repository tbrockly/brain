
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "Character.h"
#import "GameTarget.h"
#import "Coin.h"
#import "QuizLayer.h"
#import "HudLayer.h"
#import "GameState.h"
#import "TotalLayer.h"


// HelloWorld Layer
@interface Game : CCColorLayer
{
	NSMutableArray *_targets;
    b2World *world;
    GameState *gameState;
	int _projectilesDestroyed;
}

-(void) popMe;
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
    TotalLayer *_totalLayer;
}

- (HudLayer*) getHud;
-(void)addTotal;
-(void)showGame;
-(void)hideGame;
+ (id) initNode:(GameState*) gs;
- (id) initWithMonsters:(GameState*) gs;
@end

