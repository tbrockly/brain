
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Character.h"

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
	int _projectilesDestroyed;
}
- (void)pauseGame;
+(id)initNode:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
-(id)initWithMonsters:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
@end

@interface GameScene : CCScene
{
    Game *_layer;
    
}
@property (nonatomic, retain) Game *layer;
+(id)initNode:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
-(id)initWithMonsters:(NSMutableArray *)monstersIn weapons:(NSMutableArray *)weaponsIn;
@end

