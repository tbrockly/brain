
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
#import "Level1.h"
#import "SimpleAudioEngine.h"
#include <AudioToolbox/AudioToolbox.h>


//// HelloWorld Layer
//@interface Game : CCColorLayer
//{
//	NSMutableArray *_targets, *shields;
//    b2World *world;
//    GameState *gameState;
//	int _projectilesDestroyed;
//    CCSprite* bg, *bg1, *bg2, *bg3, *bg10,*bg11,*bg20,*bg21,*bg30,*bg31,*card, *bg70, *bg71,*bg80, *bg81,*bg90, *bg91;
//    CCColorLayer* gg1, *gg2;
//    b2Body *_body;
//    CCSprite *_ball;
//    CCSprite *fireback,*arrow;
//    QuizLayer *_quizLayer;
//    b2BodyDef ballBodyDef;
//    b2FixtureDef ballShapeDef;
//    b2Fixture *_fixture;
//    b2CircleShape _circle;
//    b2PolygonShape _box;
//}
//
//-(void) popMe;
//+ (id) initNode:(GameState*)gs;
//- (id) initWithMonsters;
//- (void) quizFire:(b2Body *)b;
//- (void) quiz:(b2Body *)b;
//-(void)pushQuiz;
//@end

@interface GameScene : CCScene
{
    Level1 *lay;
    QuizLayer *_quizLayer;
    HudLayer *_hudLayer;
    TotalLayer *_totalLayer;
    BOOL runAI;
    CGSize winSize;
    GameState *gameState;
    AVAudioPlayer *player;
}
@property int state, comboTimer,comboVal;
@property int boost,score,charge;
@property int rocketTime,quizTime,zerograv;
@property int topSpeed, coins;
@property float scale,speed;
@property (retain) AchievementEngine * achEng;
@property (retain) NSMutableArray *shields, *powerups, *achieves,*displayAchieves, *completeAchieves;
- (HudLayer*) getHud;
-(void)startLvl2:(GameState*) gs;
-(void)addTotal;
-(void)showGame;
-(void)hideGame;
+ (id) initNode:(GameState*) gs;
- (id) initWithMonsters:(GameState*) gs;
@end

