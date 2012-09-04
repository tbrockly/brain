//
//  GameTarget.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@interface Coin : CCSprite {
	int type;
    float speed;
    CGPoint target;
}

@property int type;
@property float speed;
@property CGPoint target;

@end
