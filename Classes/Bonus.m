//
//  Bonus.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bonus.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation Bonus
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.powStr=@"bonusLevel";
    self.freqStr=@"bonusFreq";
    self.name=@"Bonus";
    self.collectable=true;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:@"bonusLevel"];
    self.freq=20000-[[NSUserDefaults standardUserDefaults] integerForKey:@"bonusFreq"]*1000;
    imgName=@"Kawaii-Popsicle.gif";
    [self initWithFile:imgName];
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon015" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    self.scale=1;
    return self;
}

-(void)collide:(GameState*) gameState{
    AudioServicesPlaySystemSound(mySound);
    gameState.coins=gameState.coins+power+5;
    gameState.achEng.bonus++;
    gameState.achEng.totbonus++;
    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]+power*10 forKey:@"gold"];
    self.position=ccp(self.position.x-2000, 0);
}
@end
