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
    self.power=powerLevel*2;
    self.freq=10000-freqLevel*1000;
    [self initWithFile:@"tubey.png"];
    self.scale=.2;
    return self;
}

-(void)collide:(b2Body*) _body gameState:(GameState*) gameState{
    gameState.achEng.boost++;
    gameState.achEng.totboost++;
    float vx=_body->GetLinearVelocity().x;
    float vy=_body->GetLinearVelocity().y < 0.0 ?0.0:_body->GetLinearVelocity().y;
    _body->SetLinearVelocity(b2Vec2(vx+4,fabs(vy)+4));
    
    self.position=ccp(self.position.x+[self calcFreq:freq withMin:freq/2 withDist:self.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:self.position.y-HEIGHTDIFF withDist:0], 0));
}
@end
