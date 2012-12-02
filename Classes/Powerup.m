//
//  Powerup.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Powerup.h"

@implementation Powerup

@synthesize power;
@synthesize freq;
@synthesize mySound;
@synthesize imgName;
@synthesize name;
@synthesize powStr;
@synthesize freqStr;

#define HEIGHTDIFF 1000
#define HEIGHTDIFF2 2000

- (int)calcFreq:(int)freq2 withMin:(int)min withDist:(int)dist {
    return (arc4random() % freq2+(dist/100)) + min;
}

-(void)updatePosition:(CGPoint)ballpos{
    self.position=ccp(ballpos.x+[self calcFreq:(freq/4) withMin:(freq/4) withDist:0], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballpos.y-HEIGHTDIFF withDist:0], 100));
}
@end
