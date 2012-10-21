//
//  Quiz.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Quiz.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation Quiz
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
    gameState.achEng.quiz++;
    gameState.achEng.totquiz++;
    [gameState setState:1];
    self.position=ccp(self.position.x+[self calcFreq:freq withMin:freq/2 withDist:self.position.x], fmax([self calcFreq:HEIGHTDIFF2 withMin:self.position.y-HEIGHTDIFF withDist:0], 0));
}
@end
