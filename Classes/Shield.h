//
//  Shield.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/19/13.
//
//

#import "CCSprite.h"
#import "Box2D.h"
#import "cocos2d.h"
#include <AudioToolbox/AudioToolbox.h>

@interface Shield : CCSprite{
    int power;
    int dur;
    int timer, triggerCombo;
    NSString *imgName;
    NSString *name;
    SystemSoundID mySound;
    NSString *powStr;
    NSString *durStr;
}

@property int power;
@property int dur, timer, triggerCombo;
@property (assign) NSString *imgName;
@property (assign) NSString *name;
@property SystemSoundID mySound;
@property (assign) NSString *powStr;
@property (assign) NSString *durStr;
-(id) initSelf;
-(void)collide:(b2Body*) body gameState:gameState;
- (int)calcFreq:(int)freq withMin:(int)min withDist:(int)dist;
-(void)updatePosition:(CGPoint)ballpos;
@end
