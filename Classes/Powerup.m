//
//  Powerup.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Powerup.h"

@implementation Powerup

@synthesize power, height;
@synthesize freq;
@synthesize mySound;
@synthesize imgName;
@synthesize name;
@synthesize powStr;
@synthesize freqStr;
@synthesize collectable;

#define HEIGHTDIFF2 4000

- (int)calcFreq:(int)freq2 withMin:(int)min withDist:(int)dist {
    if(min<0){
        min=0;
    }
    return (arc4random() % freq2+(dist/100)) + min;
}

-(void)updatePosition:(GameState*)gs{
    
    self.height=80;//fmax([self calcFreq:HEIGHTDIFF2 withMin:ballpos.y-(HEIGHTDIFF2/2) withDist:0], 100);
    self.position=ccp(300+[self calcFreq:(freq/4) withMin:(freq/4) withDist:0], self.height);
}
@end
