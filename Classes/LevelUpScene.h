//
//  LevelUpScene.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelUpLayer : CCColorLayer {
}
@end

@interface LevelUpScene : CCScene {
    LevelUpLayer *_layer;
}

@property (nonatomic, retain) LevelUpLayer *layer;

@end
