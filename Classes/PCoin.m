//
//  PCoin.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCoin.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation PCoin
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.powStr=@"coinLevel";
    self.freqStr=@"coinFreq";
    self.name=@"Coin";
    self.collectable=true;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:@"coinLevel"];
    self.freq=10000-[[NSUserDefaults standardUserDefaults] integerForKey:@"coinFreq"]*1000;
    imgName=@"super_mario_coin.png";
    [[CCTextureCache sharedTextureCache] addImage:imgName];
    [self initWithFile:imgName];
    self.scale=1;
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon019" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    return self;
}

-(void)collide:(GameState*) gameState{
    AudioServicesPlaySystemSound(mySound);
    gameState.coins=gameState.coins+power;
    gameState.achEng.coins=gameState.achEng.coins+power;
    gameState.achEng.totcoins=gameState.achEng.totcoins+power;
    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]+power*10 forKey:@"gold"];
    self.position=ccp(self.position.x-2000, 0);
}
@end
