//
//  BoostShield.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/19/13.
//
//

#import "BoostShield.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation BoostShield
- (id) initSelf{
    self.powStr=@"boostLevel";
    self.durStr=@"boostDuration";
    self.name=@"BoostShield";
    self.timer=0;
    self.triggerCombo=1111;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr];
    self.dur=10+[[NSUserDefaults standardUserDefaults] integerForKey:durStr];
    imgName=@"shield2.png";
    [self initWithFile:imgName];
    self.scale=.3;
    return self;
}

@end
