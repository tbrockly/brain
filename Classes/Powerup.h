//
//  Powerup.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "Box2D.h"
#import "cocos2d.h"
#include <AudioToolbox/AudioToolbox.h>

@interface Powerup : CCSprite{
    int power;
    int freq;
    NSString *imgName;
    NSString *name;
    SystemSoundID mySound;
    NSString *powStr;
    NSString *freqStr;
}

@property int power;
@property int freq;
@property (assign) NSString *imgName;
@property (assign) NSString *name;
@property SystemSoundID mySound;
@property (assign) NSString *powStr;
@property (assign) NSString *freqStr;
-(id) initSelf;
-(void)collide:(b2Body*) body gameState:gameState;
- (int)calcFreq:(int)freq withMin:(int)min withDist:(int)dist;
-(void)updatePosition:(CGPoint)ballpos;
@end
