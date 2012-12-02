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

@interface HudLayer : CCLayer <UITextFieldDelegate>{
    CCSprite *card,*oneLevel,*botBar,*arrowA,*arrowD,*arrow1,*arrow2,*arrow3,*arrow4,*arrowV,*arrowVV,*coinIcon,*eng;
    UITextField *answer;
    @public GameState *gameState;
    NSMutableArray *coins;
    int score;
    CCLabelTTF *scoreLab, *chargeLab,*achieveLab,*speedLab;
}
-(void)resumeGame;
-(void)drawArrows;
-(void)drawCard;
-(void)pushQuiz;
@end
