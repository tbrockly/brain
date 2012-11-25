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
    self.powStr=@"quizLevel";
    self.freqStr=@"quizFreq";
    self.name=@"Quiz";
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:@"quizLevel"]*2;
    self.freq=20000-[[NSUserDefaults standardUserDefaults] integerForKey:@"quizFreq"]*1000;
    imgName=@"light.png";
    [self initWithFile:imgName];
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon004" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    self.scale=.8;
    return self;
}

-(void)collide:(b2Body*) _body gameState:(GameState*) gameState{
    AudioServicesPlaySystemSound(mySound);
    gameState.achEng.quiz++;
    gameState.achEng.totquiz++;
    [gameState setState:1];
    self.position=ccp(self.position.x-2000, 0);
}
@end
