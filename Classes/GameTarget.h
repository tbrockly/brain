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

@interface GameTarget : CCSprite {
	int type;
}

@property int type;

@end
