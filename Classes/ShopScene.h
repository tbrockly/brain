//
//  ShopScene.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShopLayer : CCColorLayer {
}
@end

@interface ShopScene : CCScene {
    ShopLayer *_layer;
}

@property (nonatomic, retain) ShopLayer *layer;

@end
