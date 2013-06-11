//
//  GravityParam.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/27/13.
//
//

#import "GravityParam.h"

@implementation GravityParam

- (id) initSelf{
    self.name=@"WorldGravity";
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:name];
    self.value=-2.5f+power*.1f;
    imgName=@"shield4.png";
    [self initWithFile:imgName];
    self.scale=.3;
    return self;
}

@end
