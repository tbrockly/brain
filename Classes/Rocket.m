//
//  Rocket.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Rocket.h"
#import "cocos2d.h"
#import "GameState.h"
#include <AudioToolbox/AudioToolbox.h>

@implementation Rocket
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000


- (id) initSelf{
    imgName=@"microscope.png";
    [self initWithFile:imgName];
    self.powStr=@"rocketLevel";
    self.freqStr=@"rocketFreq";
    self.name=@"Rocket";
    self.collectable=true;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:@"rocketLevel"];
    self.freq=20000-[[NSUserDefaults standardUserDefaults] integerForKey:@"rocketFreq"]*1000;
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"scifi012" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    self.scale=.8;
    return self;
}

-(void)collide:(b2Body*) _body gameState:(GameState*) gameState{
    AudioServicesPlaySystemSound(mySound);
    gameState.achEng.rocket++;
    gameState.achEng.totrocket++;
    _body->SetLinearVelocity(b2Vec2(fabs(_body->GetLinearVelocity().x)+fabs(_body->GetLinearVelocity().y)+power,0));
    gameState.rocketTime=10;
    _body->SetAngularVelocity(0);
    self.position=ccp(self.position.x-2000, 0);
}
@end
