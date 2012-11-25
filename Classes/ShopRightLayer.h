//
//  QuizScene.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Powerup.h"
#import "ShopLayer.h"
#import "GameState.h"

@interface ShopRightLayer : CCColorLayer <UITextFieldDelegate>{
    Powerup *pow;
    CCSprite *restart,*plusPow,*plusFreq;
    CCLabelTTF *powCost,*powLevel,*powDescrip,*freqCost,*freqLevel,*freqDescrip;
    UITextField *answer;
    ShopLayer *shopLayer;
    int booster;
}
-(id)init:(Powerup *) powerup;
@end