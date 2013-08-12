//
//  Level1.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/26/13.
//
//

#import "cocos2d.h"

#import "QuizLayer.h"
#import "HudLayer.h"
#import "GameState.h"
#import "TotalLayer.h"
#import "Rocket.h"
#include <AudioToolbox/AudioToolbox.h>

@interface Level1 : CCLayer
{
	NSMutableArray *_targets, *shields;
    GameState *gameState;
	int _projectilesDestroyed;
    
    //CCSprite *bg, *bg1, *bg2, *bg3, *bg10,*bg11,*bg20,*bg21,*bg30,*bg31, *bg70, *bg71,*bg80, *bg81,*bg90, *bg91, *bg92
    CCLayer *bgLayer;
    CCColorLayer* gg1, *gg2, *skyLayer;
    CCSprite *bg, *bg1, *bg2, *fireback,*arrow,*card;
    Rocket *myRocket;
    QuizLayer *_quizLayer;
    //CGPoint firstTouch, lastTouch;
    NSUserDefaults *defaults2;
    SystemSoundID mySound;
    
    
    float fireOffset;
    AchievementEngine *achEngine;
    bool paused;
    bool flattened;
    bool rocketing;
    int brainimg;
    float restitution;
    float friction;
    float gravity;
}

-(void) popMe;
+ (id) initNode:(GameState*)gs;
- (id) initWithMonsters;
-(void)pushQuiz;
-(void)restart;
-(void)addCoins:(int)coinVal;
-(void)addBrains:(int)brainVal;
-(void)addxp:(int)xVal;

@end
