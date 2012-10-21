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

@implementation Rocket
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.power=powerLevel*2;
    self.freq=10000-freqLevel*1000;
    [self initWithFile:@"microscope.png"];
    self.scale=.2;
    return self;
}

-(void)collide:(b2Body*) _body gameState:(GameState*) gameState{
    gameState.achEng.rocket++;
    gameState.achEng.totrocket++;
    _body->SetLinearVelocity(b2Vec2(fabs(_body->GetLinearVelocity().x)+fabs(_body->GetLinearVelocity().y)+3.0,0));
    gameState.rocketTime=10;
    _body->SetAngularVelocity(0);
    self.position=ccp(self.position.x+[self calcFreq:freq withMin:freq/2 withDist:self.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:self.position.y-HEIGHTDIFF withDist:0], 0));
}
@end
