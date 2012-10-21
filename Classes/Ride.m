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
    self.power=powerLevel*2;
    self.freq=10000-freqLevel*1000;
    [self initWithFile:@"light.png"];
    self.scale=.2;
    return self;
}

-(void)collide:(b2Body*) _body gameState:(GameState*) gameState{
    gameState.achEng.ride++;
    gameState.achEng.totride++;
    _body->SetLinearVelocity(b2Vec2(fabs(_body->GetLinearVelocity().x)+fabs(_body->GetLinearVelocity().y)+3.0,0));
    gameState.zerograv=10;
    self.position=ccp(self.position.x+[self calcFreq:freq withMin:freq/2 withDist:self.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:self.position.y-HEIGHTDIFF withDist:0], 0));
}
@end
