
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "Character.h"
#import "QuizScene.h"
#import "GameScene.h"

// HelloWorld Layer
@interface Game : CCColorLayer
{
	NSMutableArray *_targets;
	NSMutableArray *_projectiles;
    NSMutableArray *_launchers;
    NSMutableArray *_weapons;
    NSMutableArray *_monsters;
    NSMutableArray *_eMonsters;
    NSMutableArray *_eWeapons;
    Character *character;
    b2World *world;
    GameScene *gameGlobal;
    
	int _projectilesDestroyed;
}
+(id)initNode:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
-(id)initWithMonsters:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
-(void)quizFire:(b2Body *)b;
@property (nonatomic, readonly) b2World * world;
@property (nonatomic, readonly) GameScene * gameGlobal;
@end