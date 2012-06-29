//
//  TitleScene.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface TitleLayer : CCColorLayer {
    CCSprite *onePlayer;
}
@property (nonatomic, retain) CCSprite *onePlayer;
@end

@interface TitleScene : CCScene {
    TitleLayer *_layer;
}

@property (nonatomic, retain) TitleLayer *layer;

@end
