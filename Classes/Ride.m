//
//  Ride.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ride.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation Ride
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.powStr=@"rideLevel";
    self.name=@"ZeroGrav";
    self.collectable=true;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:@"rideLevel"];
    self.freq=20000-[[NSUserDefaults standardUserDefaults] integerForKey:powStr]*1000;
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon016" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    imgName=@"light.png";
    [[CCTextureCache sharedTextureCache] addImage:imgName];
    [self initWithFile:imgName];
    self.scale=.5;
    return self;
}

-(void)collide:(GameState*) gameState{
    AudioServicesPlaySystemSound(mySound);
    gameState.achEng.ride++;
    gameState.achEng.totride++;
    [gameState setVx:(gameState.vx+(fabs(gameState.vy)*.8))];
    [gameState setVy:(100)];
    //_body->SetLinearVelocity(b2Vec2(fabs(_body->GetLinearVelocity().x)+fabs(_body->GetLinearVelocity().y),0));
    gameState.zerograv=power+4;
    self.position=ccp(self.position.x-2000, 0);
}
@end
