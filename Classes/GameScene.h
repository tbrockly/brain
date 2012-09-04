
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
+(id)initNode:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
-(id)initWithMonsters:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
-(void)quizFire:(b2Body *)b;
@property (nonatomic, readonly) b2World * world;
@property (nonatomic, retain) GameState * gameState;
@end

@interface GameScene : CCScene
{
    //Game *_layer;
    QuizLayer *_quizLayer;
    
}
//@property (nonatomic, retain) Game *layer;
@property (nonatomic, retain) QuizLayer *quizLayer;
+(id)initNode:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
-(id)initWithMonsters:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
@end

