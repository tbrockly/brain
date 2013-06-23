//
//  Energy.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Energy.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation Energy
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.powStr=@"energyLevel";
    self.freqStr=@"energyFreq";
    self.name=@"Energy";
    self.collectable=true;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:@"energyLevel"];
    self.freq=20000-[[NSUserDefaults standardUserDefaults] integerForKey:@"energyFreq"]*1000;
    imgName=@"lightning-icon.png";
    [self initWithFile:imgName];
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon019" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    self.scale=.5;
    return self;
}

-(void)collide:(GameState*) gameState{
    AudioServicesPlaySystemSound(mySound);
    gameState.achEng.energy=gameState.achEng.energy+power;
    gameState.achEng.totenergy=gameState.achEng.totenergy+power;
    gameState.charge=gameState.charge+power;
    //_body->SetLinearVelocity(b2Vec2(fabs(_body->GetLinearVelocity().x)+1.0,fabs(_body->GetLinearVelocity().y)+1.0));
    self.position=ccp(self.position.x-2000, 0);
}
@end
