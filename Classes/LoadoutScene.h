//
//  LoadoutScene.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadoutLayer : CCColorLayer {
    CCSprite *readyButton;
}
@property (nonatomic, retain) CCSprite *readyButton;
@end

@interface LoadoutScene : CCScene {
    LoadoutLayer *_layer;
}

@property (nonatomic, retain) LoadoutLayer *layer;

@end
