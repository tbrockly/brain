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
    self.freqStr=@"cloudFreq";
    self.name=@"Cloun";
    self.collectable=false;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr];
    self.freq=6000;
    //10000-[[NSUserDefaults standardUserDefaults] integerForKey:freqStr]*1000;
    imgName=@"CL02.png";
    [self initWithFile:imgName];
    self.scale=1;
    return self;
}

-(void)collide:(b2Body*) _body gameState:(GameState*) gameState{

}

- (int)calcFreq:(int)freq2 withMin:(int)min withDist:(int)dist {
    return (arc4random() % freq2) + min;
}

-(void)updatePosition:(CGPoint)ballpos{
    self.position=ccp(ballpos.x+[self calcFreq:(freq/4) withMin:(freq/4) withDist:0], fmax([self calcFreq:HEIGHTDIFF2 withMin:ballpos.y-HEIGHTDIFF withDist:0], 1500));
}

@end
