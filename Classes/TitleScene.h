//
//  TitleScene.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameState.h"

@interface TitleLayer : CCColorLayer {
    CCSprite *onePlayer;
    CCSprite *shopSprite;
    GameState *gameState;
}
@property (nonatomic, retain) CCSprite *onePlayer;
@property (nonatomic, retain) CCSprite *shopSprite;
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, strong) CCSprite *bear;
@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *moveAction;
@end

@interface TitleScene : CCScene {
    TitleLayer *_layer;
}

@property (nonatomic, retain) TitleLayer *layer;

@end
