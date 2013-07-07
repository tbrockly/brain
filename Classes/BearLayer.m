//
//  BearLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 6/22/13.
//
//

#import "BearLayer.h"
#import "EndRunLayer.h"

@implementation BearLayer
-(id) init:(GameState*)gs
{
	if( (self=[super init] )) {
		brain = [CCSprite spriteWithFile:@"brain_grrr.png"];
        brain.scale=.4;
        brain.position = ccp(240, 350);
        self.isTouchEnabled= true;
        [self addChild:brain z:1];
        scoreLab.string=[NSString stringWithFormat:@"%i",[gameState score]];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"bearsssss.plist"];
        
        
                CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bearsssss.png"];
                [self addChild:spriteSheet];
                NSMutableArray *walkAnimFrames = [NSMutableArray array];
                for (int i=3; i<=8; i++) {
                    [walkAnimFrames addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                      [NSString stringWithFormat:@"bear%d.png",i]]];
                }
                CCAnimation *walkAnim = [CCAnimation
                                         animationWithFrames:walkAnimFrames delay:0.1f];
                bear = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
                bear.scale=.3;
                bear.position = ccp(240, 100);
                walkAction = [CCRepeatForever actionWithAction:
                                   [CCAnimate actionWithAnimation:walkAnim]];
                [bear runAction:walkAction];
                [spriteSheet addChild:bear];
		[brain runAction:[CCSequence actions:
                         [CCCallFuncN actionWithTarget:self selector:@selector(playtunes)],
                         [CCDelayTime actionWithDuration:1],
                         [CCMoveTo actionWithDuration:2 position:ccp(240,120)],
                         [CCCallFuncN actionWithTarget:self selector:@selector(hidebrain)],
                         [CCCallFuncN actionWithTarget:self selector:@selector(beardance)],
                         [CCDelayTime actionWithDuration:3],
                         [CCCallFuncN actionWithTarget:self selector:@selector(endRun)],
                         nil]];
	}
	return self;
}

- (void)playtunes{
    SystemSoundID mySound;
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"bearscut" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
    bearPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
    bearPlayer.numberOfLoops=0;
    bearPlayer.volume=.5;
    [bearPlayer play];
}
- (void)hidebrain{
    brain.visible=false;
}

- (void)endRun{
    if(addEndLayer==false){
        addEndLayer=true;
        EndRunLayer *lol=[[EndRunLayer alloc] init:gameState];
        [self addChild: lol z:10];
    }
}

- (void)beardance{
    [bear runAction: [CCRepeatForever actionWithAction:[CCSequence actions:[CCFlipX actionWithFlipX:true],
                                                        [CCDelayTime actionWithDuration:.3],
                                                        [CCFlipX actionWithFlipX:false],
                                                        [CCDelayTime actionWithDuration:.3],
                                                        nil]]];
}

- (void)stopMusic{
    [bearPlayer stop];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self stopMusic];
    [self endRun];
}

- (void)dealloc
{
    [bearPlayer dealloc];
    [super dealloc];
}

@end
