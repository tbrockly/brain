//
//  Hole.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 6/24/13.
//
//

#import "Hole.h"

@implementation Hole
#define HEIGHTDIFF 2000
#define HEIGHTDIFF2 4000

- (id) initSelf{
    self.powStr=@"holeLevel";
    self.freqStr=@"holeFreq";
    self.name=@"Hole";
    self.collectable=false;
    self.power=[[NSUserDefaults standardUserDefaults] integerForKey:powStr];
    self.freq=20000;
    //10000-[[NSUserDefaults standardUserDefaults] integerForKey:freqStr]*1000;
    imgName=@"MultipleBox.png";
    [[CCTextureCache sharedTextureCache] addImage:imgName];
    [self initWithFile:imgName];
    self.scale=.5;
    return self;
}

-(void)collide:(GameState*) gameState{
    [gameState setState:98];
    [[self.parent.parent getHud] braingrr];
    [self runAction: [CCCallFuncN actionWithTarget:self.parent selector:@selector(dropBrain)]
                     ];
    
    
}

- (int)calcFreq:(int)freq2 withMin:(int)min withDist:(int)dist {
    return (arc4random() % freq2) + min;
}

-(void)updatePosition:(GameState*)gs{
    
    self.height=26;
    self.position=ccp(300+[self calcFreq:(freq/4) withMin:(freq/4) withDist:0], self.height);
}

@end
