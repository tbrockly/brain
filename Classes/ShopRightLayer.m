//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopRightLayer.h"
#import "GameScene.h"

@implementation ShopRightLayer
@synthesize pow;
@synthesize restart,plusPow,plusFreq;
@synthesize booster;
@synthesize shopLayer;
@synthesize powCost,powLevel,powDescrip,freqCost,freqLevel,freqDescrip;

#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init:(Powerup*)power
{
	if( (self=[super initWithColor:ccc4(155,155,155,100)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        self.pow=power;
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.restart = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		restart.position = ccp(winSize.width/1.33, winSize.height/6);
        [self addChild:restart];
        self.plusFreq = [CCSprite spriteWithFile:@"BodyItemside.png" rect:CGRectMake(0, 0, 100, 100)];
        plusFreq.position = ccp(430, 250);
        [self addChild:plusFreq];
        self.plusPow = [CCSprite spriteWithFile:@"BodyItemside.png" rect:CGRectMake(0, 0, 100, 100)];
        plusPow.position = ccp(430, 150);
        [self addChild:plusPow];
        freqLevel=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:self.pow.freqStr]]
                                           fontName:@"Futura"
                                           fontSize:30];
        [freqLevel setColor:ccWHITE];
        freqLevel.position = ccp(380, 250);
        [self addChild:freqLevel];
        powLevel=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:self.pow.powStr]]
                                            fontName:@"Futura"
                                            fontSize:30];
        [powLevel setColor:ccWHITE];
        powLevel.position = ccp(380, 150);
        [self addChild:powLevel];
	}
	return self;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [answer resignFirstResponder];
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        if (CGRectContainsPoint(restart.boundingBox,location)) {
            [self.parent removeChild:self cleanup:TRUE];
            [[CCDirector sharedDirector] resume];
        }
        if (CGRectContainsPoint(plusFreq.boundingBox,location)) {
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:self.pow.freqStr]+1 forKey:self.pow.freqStr];
            self.freqLevel.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:self.pow.freqStr]];
        }
        if (CGRectContainsPoint(plusPow.boundingBox,location)) {
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:self.pow.powStr]+1 forKey:self.pow.powStr];
            self.powLevel.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:self.pow.powStr]];
        }
}

@end

