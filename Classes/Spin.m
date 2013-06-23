//
//  Spin.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Spin.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation Spin
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.powStr=@"spinLevel";
    self.freqStr=@"spinFreq";
    self.name=@"Spinner";
    self.collectable=true;
    self.power=40+[[NSUserDefaults standardUserDefaults] integerForKey:@"spinLevel"]*2;
    self.freq=10000-[[NSUserDefaults standardUserDefaults] integerForKey:@"spinFreq"]*1000;
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon025" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    imgName=@"thing_blue.png";
    [self initWithFile:imgName];
    self.scale=.8;
    return self;
}

-(void)collide:(GameState*) gs{
    AudioServicesPlaySystemSound(mySound);
    gs.achEng.spin++;
    gs.achEng.totspin++;
    [gs setSpinPower:5];
    self.position=ccp(self.position.x-2000, 0);
    //_body->SetAngularVelocity(-power);
}
@end
