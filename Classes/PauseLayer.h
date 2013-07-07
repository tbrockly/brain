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

@interface PauseLayer : CCColorLayer{
    CCSprite *oneLevel;
    //CCSprite *restart;
    @public GameState *gameState;
    int booster;
}
@end
