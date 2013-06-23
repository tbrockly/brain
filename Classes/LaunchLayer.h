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

@interface LaunchScene : CCScene {
}
- (id)init:(GameState*)gs;
@end

@interface LaunchLayer : CCColorLayer {
    CCSprite *n1,*n2,*n3,*n4,*n5,*nn1,*nn2,*nn3,*nn4,*selected;
    CCSprite *btn1,*btn2,*btn3,*btn4;
@public GameState *gameState;
    int booster;
    int selectNum,ss1,ss2,ss3,ss4,ss5;
    int num1, num2, answer, answers[4], correctNum, mathType,timer, popTimer;
    CCLabelTTF *num1l,*timeLab;
    CCLabelTTF *lol1,*lol2,*lol3,*lol4;
}
- (CCSprite*) getTagForInt:(int)i;
- (void)setNumPositions;
-(id) init:(GameState *) gs;
@end

