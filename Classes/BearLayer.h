//
//  BearLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 6/22/13.
//
//

#import "cocos2d.h"
#import "GameState.h"
#import "SimpleAudioEngine.h"
#include <AudioToolbox/AudioToolbox.h>

@interface BearLayer : CCLayer{
    GameState *gameState;
    CCSprite *brain, *bear;
    CCLabelTTF *scoreLab;
    int scoreRoll;
    AVAudioPlayer *bearPlayer;
    CCAction *walkAction;
    CCAction *moveAction;
}
-(id) init:(GameState*)gs;
@end
