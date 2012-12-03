//
//  TotalLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 12/2/12.
//
//

#import "cocos2d.h"
#import "GameState.h"

@interface TotalLayer : CCLayer{
    GameState *gameState;
    CCSprite *back, *arrowV, *arrowVV, *arrowD, *arrowA;
    CCLabelTTF *scoreLab;
    int scoreRoll;
}
-(id) init:(GameState*)gs;
@end
