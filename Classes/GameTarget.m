//
//  GameTarget.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTarget.h"
#import "GameConfig.h"

@implementation GameTarget

@synthesize type;

- (id)init
{
    self = [super init];
    if (self) {
        type=targetType;
    }
    return self;
}

@end
