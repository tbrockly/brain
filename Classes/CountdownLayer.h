//
//  CountdownLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/10/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"

@interface CountdownLayer : CCColorLayer{
    CCSprite *reds;
    CCSprite *blues;
    CCSprite *greens;
    GameState *gameState;
    int booster;
}
-(id) init:(GameState *) gs;
-(void) countdown;
@end
