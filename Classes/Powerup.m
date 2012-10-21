//
//  Powerup.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Powerup.h"

@implementation Powerup

@synthesize freqLevel;
@synthesize powerLevel;
@synthesize power;
@synthesize freq;

- (int)calcFreq:(int)freq2 withMin:(int)min withDist:(int)dist {
    return (arc4random() % freq2+(dist/10)) + min;
}
@end
