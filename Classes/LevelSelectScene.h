//
//  LevelSelectScene.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelSelectLayer : CCColorLayer {
    CCSprite *oneLevel;
}
@property (nonatomic, retain) CCSprite *oneLevel;
@end

@interface LevelSelectScene : CCScene {
    LevelSelectLayer *_layer;
}

@property (nonatomic, retain) LevelSelectLayer *layer;

@end
