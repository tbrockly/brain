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

@interface ShopRow : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel;
    UITextField *answer;
    GameState *gameState;
    CCColorLayer *parentLayer;
    CCLabelTTF *energy, *coin, *boost, *rocket, *ride, *spin;
    int booster;
}
@property (nonatomic, retain) CCSprite *oneLevel;
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) CCColorLayer *parentLayer;
@property (nonatomic, retain) CCLabelTTF *energy, *coin, *boost, *rocket, *ride, *spin;
@property int booster;
@end
