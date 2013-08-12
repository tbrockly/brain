//
//  QuizScene.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "SimpleAudioEngine.h"
#include <AudioToolbox/AudioToolbox.h>

@interface HudLayer : CCLayer <UITextFieldDelegate>{
    CCSprite *bronzeBar,*silverBar,*goldBar,*audioBtn,*card,*oneLevel,*botBar,*arrowA,*arrowD,*arrow1,*arrow2,*arrow3,*arrow4,*arrowV,*arrowVV,*brainIcon,*coinIcon,*eng;
    UITextField *answer;
    @public GameState *gameState;
    NSMutableArray *coins, *brains;
    CCLabelBMFont *scoreLab, *chargeLab,*achieveLab,*speedLab, *highScoreLab, *coinLab, *xpLab,*brainLab;
    AVAudioPlayer *hudplayer;
    CGPoint firstTouch;
    int brainimg;
    int highscore;
}
@property (nonatomic, retain) CCSprite * brain;

-(void)resumeGame;
-(void)drawArrows;
-(void)drawCard;
-(void)brainbounce;
-(void)braingrr;
-(void)brainsplat;
-(void)pushQuiz;
-(void)pushEnd;
-(id) init:(GameState*)myGameState;
-(void)addCoins:(int)coinVal;
-(void)addBrains:(int)brainVal;
-(void)addxp:(int)xVal;
@end
