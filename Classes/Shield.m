//
//  Shield.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/19/13.
//
//

#import "Shield.h"

@implementation Shield

@synthesize power;
@synthesize dur;
@synthesize mySound;
@synthesize imgName;
@synthesize name;
@synthesize powStr;
@synthesize durStr;
@synthesize timer;

#define HEIGHTDIFF 1000
#define HEIGHTDIFF2 2000

- (int)calcFreq:(int)freq2 withMin:(int)min withDist:(int)dist {
    return (arc4random() % freq2+(dist/100)) + min;
}


@end
