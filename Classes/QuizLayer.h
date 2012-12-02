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

@interface QuizScene : CCScene {
}
- (id)init:(GameState*)gs;
@end

@interface QuizLayer : CCColorLayer {
    CCSprite *oneLevel,*n1,*n2,*n3,*n4,*n5,*nn1,*nn2,*nn3,*nn4,*p0,*p1,*p2,*p3,*p4,*p5,*p6,*p7,*p8,*p9,*s1,*s2,*s3,*s4,*s5,*bg,*bg2,*selected;
    UITextField *answer;
    @public GameState *gameState;
    int booster;
    int selectNum,ss1,ss2,ss3,ss4,ss5;
    int num1, num2, mathType,timer, popTimer;
    CCLabelTTF *num1l,*timeLab;
}
- (CCSprite*) getTagForInt:(int)i;
- (void)setNumPositions;
@end

