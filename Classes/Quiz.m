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
    self.name=@"Quiz";
    self.collectable=true;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr];
    self.freq=10000-[[NSUserDefaults standardUserDefaults] integerForKey:powStr]*1000;
    imgName=@"light.png";
    [[CCTextureCache sharedTextureCache] addImage:imgName];
    [self initWithFile:imgName];
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon004" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    self.scale=.5;
    return self;
}

-(void)collide:(GameState*) gameState{
    AudioServicesPlaySystemSound(mySound);
    gameState.achEng.quiz++;
    gameState.achEng.totquiz++;
    [gameState setState:1];
    self.position=ccp(self.position.x-2000, 0);
}
@end
