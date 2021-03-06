//
//  Cloud.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 11/26/12.
//
//

#import "Cloud.h"
#import "cocos2d.h"
#import "GameState.h"

@implementation Cloud
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.powStr=@"cloudLevel";
    self.name=@"Cloun";
    self.collectable=false;
    self.power=1;
    self.freq=6000;
    //10000-[[NSUserDefaults standardUserDefaults] integerForKey:freqStr]*1000;
    imgName=@"CL02.png";
    [[CCTextureCache sharedTextureCache] addImage:imgName];
    [self initWithFile:imgName];
    self.scale=1;
    return self;
}

-(void)collide:(GameState*) gameState{

}

- (int)calcFreq:(int)freq2 withMin:(int)min withDist:(int)dist {
    return (arc4random() % freq2) + min;
}

-(void)updatePosition:(GameState*)gs{
    
    self.height=fmax([self calcFreq:HEIGHTDIFF2 withMin:160-HEIGHTDIFF withDist:0], 1500);
    self.position=ccp(400+[self calcFreq:(freq/4) withMin:(freq/4) withDist:0], self.height);
}

@end
