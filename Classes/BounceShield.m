//
//  BounceShield.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/19/13.
//
//

#import "BounceShield.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation BounceShield
- (id) initSelf{
    self.powStr=@"bounceLevel";
    self.durStr=@"bounceDuration";
    self.name=@"BounceShield";
    self.timer=0;
    self.triggerCombo=1010;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr];
    self.dur=10+[[NSUserDefaults standardUserDefaults] integerForKey:durStr];
    imgName=@"shield4.png";
    [self initWithFile:imgName];
    self.scale=.3;
    return self;
}

@end
