//
//  Powerup.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "Box2D.h"

@interface Powerup : CCSprite{
    short freqLevel;
    short powerLevel;
    int power;
    int freq;
}

@property short freqLevel;
@property short powerLevel;
@property int power;
@property int freq;
-(id) initSelf;
-(void)collide:(b2Body*) body gameState:gameState;
- (int)calcFreq:(int)freq withMin:(int)min withDist:(int)dist;
@end
