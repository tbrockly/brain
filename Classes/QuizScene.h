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

@interface QuizLayer : CCColorLayer {
    CCSprite *oneLevel;
    GameState *gameState;
    int booster;
}
@property (nonatomic, retain) CCSprite *oneLevel;
@property (nonatomic, retain) GameState *gameState;
@property int booster;
@end

@interface QuizScene : CCScene {
    QuizLayer *_layer;
}

@property (nonatomic, retain) QuizLayer *layer;
@end
