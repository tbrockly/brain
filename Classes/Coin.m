//
//  GameTarget.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Coin.h"
#import "GameConfig.h"

@implementation Coin

@synthesize type, speed, target;

- (id)init
{
    self = [super init];
    if (self) {
        type=targetType;
    }
    return self;
}

@end
