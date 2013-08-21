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
#define HEIGHTDIFF 500
#define HEIGHTDIFF2 1000

- (id) initSelf{
    self.powStr=@"coinLevel";
    self.name=@"Coin";
    self.collectable=true;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr];
    self.freq=2000-[[NSUserDefaults standardUserDefaults] integerForKey:powStr]*500;
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
    [self.parent addCoins:self.power*10*(gameState.currLevel/2+1)];
    self.position=ccp(self.position.x-2000, 0);
}

-(void)updatePosition:(GameState*)gs{
    
    self.height=fmax([self calcFreq:HEIGHTDIFF2 withMin:[gs dy]-(HEIGHTDIFF2/2) withDist:0], 80)+[gs vy]*.1;
    self.position=ccp(400+[self calcFreq:(freq/4) withMin:(freq/4) withDist:0], self.height);
}
@end
