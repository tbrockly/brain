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
    CCSprite *oneLevel;
    UITextField *answer;
    GameState *gameState;
    NSMutableArray *coins;
    int score;
}
@property (nonatomic, retain) CCSprite *oneLevel;
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) NSMutableArray *coins;
@property int score;
@end
