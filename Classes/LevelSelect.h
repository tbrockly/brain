//
//  LevelSelect.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/7/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"

@interface LevelSelect : CCLayer{
CCSprite *oneLevel;
GameState *gameState;
CCColorLayer *parentLayer, *xpBar;
int booster;
//CCLabelTTF *coinLab, *xpLab,*brainLab, *lvlLab;
    NSMutableArray *levels;
}

@property (nonatomic, retain) CCColorLayer *parentLayer;

-(id)init:(GameState*)gs;

@end
