//
//  CoinShield.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/19/13.
//
//

#import "CoinShield.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation CoinShield
- (id) initSelf{
    self.powStr=@"coinLevel";
    self.durStr=@"coinDuration";
    self.name=@"CoinShield";
    self.timer=0;
    self.triggerCombo=1000;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr];
    self.dur=10+[[NSUserDefaults standardUserDefaults] integerForKey:durStr];
    imgName=@"shield3.png";
    [self initWithFile:imgName];
    self.scale=.3;
    return self;
}

@end
