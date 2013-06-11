//
//  FrictionParam.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/27/13.
//
//

#import "FrictionParam.h"

@implementation FrictionParam

- (id) initSelf{
    self.name=@"WorldFriction";
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:name];
    self.value=.6f-power*.04f;
    imgName=@"shield4.png";
    [self initWithFile:imgName];
    self.scale=.3;
    return self;
}

@end
