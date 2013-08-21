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
    self.name=@"Spinner";
    self.collectable=true;
    self.power=40+[[NSUserDefaults standardUserDefaults] integerForKey:powStr]*2;
    self.freq=20000-[[NSUserDefaults standardUserDefaults] integerForKey:powStr]*1000;
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"cartoon025" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    imgName=@"thing_blue.png";
    [[CCTextureCache sharedTextureCache] addImage:imgName];
    [self initWithFile:imgName];
    self.scale=.8;
    return self;
}

-(void)collide:(GameState*) gs{
    AudioServicesPlaySystemSound(mySound);
    gs.achEng.spin++;
    gs.achEng.totspin++;
    [gs setSpinPower:8];
    self.position=ccp(self.position.x-2000, 0);
    //_body->SetAngularVelocity(-power);
}
@end
