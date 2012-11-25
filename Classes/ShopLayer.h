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

@interface ShopLayer : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel;
    GameState *gameState;
    CCColorLayer *parentLayer;
    int booster;
}

-(id)init:(GameState*)gs;

@end
