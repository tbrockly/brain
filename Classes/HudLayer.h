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
    CCSprite *oneLevel,*botBar,*arrowA,*arrowD,*arrowV,*arrowVV,*coinIcon,*eng;
    UITextField *answer;
    @public GameState *gameState;
    NSMutableArray *coins;
    int score;
    CCLabelTTF *scoreLab, *chargeLab,*achieveLab,*speedLab;
}
@end
