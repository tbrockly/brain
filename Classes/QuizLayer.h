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

@interface QuizLayer : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel,*p1,*p2,*p3,*p4,*p5,*p6,*p7,*p8,*p9;
    UITextField *answer;
    GameState *gameState;
    int booster;
}
@property (nonatomic, retain) CCSprite *oneLevel,*p1,*p2,*p3,*p4,*p5,*p6,*p7,*p8,*p9;
@property (nonatomic, retain) GameState *gameState;
@property int booster;
@end
