//
//  EndRunLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 6/30/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"

@interface EndRunLayer : CCColorLayer{
    CCSprite *shop;
    CCSprite *restart;
    CCSprite *girl;
    CCLabelTTF *goodRun;
    GameState *gameState;
    int booster;
}
-(id) init:(GameState *) gs;
@end
