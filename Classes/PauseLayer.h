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

@interface PauseLayer : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel;
    CCSprite *restart;
    UITextField *answer;
    GameState *gameState;
    int booster;
}
@property (nonatomic, retain) CCSprite *oneLevel;
@property (nonatomic, retain) CCSprite *restart;
@property (nonatomic, retain) GameState *gameState;
@property int booster;
@end
