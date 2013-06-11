//
//  Level1.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/26/13.
//
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Character.h"
#import "GameTarget.h"
#import "Coin.h"
#import "QuizLayer.h"
#import "HudLayer.h"
#import "GameState.h"
#import "TotalLayer.h"
#import "Rocket.h"

@interface Level1 : CCColorLayer
{
	NSMutableArray *_targets, *shields;
    b2World *world;
    GameState *gameState;
	int _projectilesDestroyed;
    CCSprite *bg, *bg1, *bg2, *bg3, *bg10,*bg11,*bg20,*bg21,*bg30,*bg31,*card, *bg70, *bg71,*bg80, *bg81,*bg90, *bg91;
    CCColorLayer* gg1, *gg2;
    b2Body *_body;
    CCSprite *_ball;
    CCSprite *fireback,*arrow;
    Rocket *myRocket;
    QuizLayer *_quizLayer;
    b2BodyDef ballBodyDef;
    b2FixtureDef ballShapeDef;
    b2Fixture *_fixture;
    b2CircleShape _circle;
    b2PolygonShape _box;
    CGPoint firstTouch, lastTouch;
    NSUserDefaults *defaults2;
    
    float fireOffset;
    AchievementEngine *achEngine;
    bool paused;
    bool flattened;
    bool rocketing;
    b2Vec2 launchSpeed;
    float restitution;
    float friction;
    float gravity;
}

-(void) popMe;
+ (id) initNode:(GameState*)gs;
- (id) initWithMonsters;
- (void) quizFire:(b2Body *)b;
- (void) quiz:(b2Body *)b;
-(void)pushQuiz;

@end
