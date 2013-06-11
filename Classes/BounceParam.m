//
//  BounceParam.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/27/13.
//
//

#import "BounceParam.h"

@implementation BounceParam

- (id) initSelf{
    self.name=@"WorldBounce";
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:name];
    self.value=.3f+power*.05f;
    imgName=@"shield4.png";
    [self initWithFile:imgName];
    self.scale=.3;
    return self;
}

@end
