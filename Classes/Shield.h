//
//  Shield.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/19/13.
//
//

#import "CCSprite.h"
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
@property (nonatomic, retain) NSString *imgName;
@property (nonatomic, retain) NSString *name;
@property SystemSoundID mySound;
@property (nonatomic, retain) NSString *powStr;
@property (nonatomic, retain) NSString *durStr;
-(id) initSelf;
-(void)updatePosition:(CGPoint)ballpos;
@end
