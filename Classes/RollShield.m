//
//  RollShield.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/19/13.
//
//

#import "RollShield.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation RollShield
- (id) initSelf{
    self.powStr=@"rollLevel";
    self.durStr=@"rollDuration";
    self.name=@"RollShield";
    self.timer=0;
    self.triggerCombo=1011;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr];
    self.dur=30+[[NSUserDefaults standardUserDefaults] integerForKey:durStr];
    imgName=@"shield1.png";
    [self initWithFile:imgName];
    self.scale=.3;
    return self;
}

@end
