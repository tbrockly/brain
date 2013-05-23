//
//  Boost.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Boost.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation Boost
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.powStr=@"boostLevel";
    self.freqStr=@"boostFreq";
    self.name=@"Booster";
    self.collectable=true;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr]*2;
    self.freq=20000-[[NSUserDefaults standardUserDefaults] integerForKey:freqStr]*1000;
    imgName=@"tubey.png";
    [self initWithFile:imgName];
    self.scale=.8;
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon008" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    return self;
}

-(void)collide:(b2Body*) _body gameState:(GameState*) gameState{
    AudioServicesPlaySystemSound(mySound);
    gameState.achEng.boost++;
    gameState.achEng.totboost++;
    float vx=_body->GetLinearVelocity().x;
    float vy=_body->GetLinearVelocity().y < 0.0 ?0.0:_body->GetLinearVelocity().y;
    _body->SetLinearVelocity(b2Vec2(vx+power+2,fabs(vy)+power+2));
    
    self.position=ccp(self.position.x-2000, 0);
}
@end
