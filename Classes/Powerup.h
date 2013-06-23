//
//  Powerup.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "GameState.h"
#include <AudioToolbox/AudioToolbox.h>

@interface Powerup : CCSprite{
    int power;
    int freq;
    NSString *imgName;
    NSString *name;
    SystemSoundID mySound;
    NSString *powStr;
    NSString *freqStr;
    bool collectable;
}

@property int power, height;
@property int freq;
@property bool collectable;
@property (nonatomic, retain) NSString *imgName;
@property (nonatomic, retain) NSString *name;
@property SystemSoundID mySound;
@property (nonatomic, retain) NSString *powStr;
@property (nonatomic, retain) NSString *freqStr;
-(id) initSelf;
- (int)calcFreq:(int)freq withMin:(int)min withDist:(int)dist;
-(void)updatePosition:(CGPoint)ballpos;
-(void)collide:(GameState*)gs;
@end
