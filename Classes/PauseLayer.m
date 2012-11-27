//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"
#import "GameScene.h"

@implementation PauseLayer

#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init
{
	if( (self=[super initWithColor:ccc4(155,155,155,100)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"ok.png"];
        oneLevel.scale=.2;
		[self addChild:oneLevel];
        oneLevel.position = ccp(winSize.width/2, winSize.height/2);
        restart = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(20, 20, 40, 40)];
		[self addChild:restart];
        restart.position = ccp(winSize.width/2, winSize.height/4);
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
    if([gameState state]==2){
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        if (CGRectContainsPoint(oneLevel.boundingBox,location)) {
            [gameState setState:0];
            [answer endEditing:YES];
            [answer removeFromSuperview];
            [self.parent removeChild:self cleanup:TRUE];
            [[CCDirector sharedDirector] resume];
        }
        if (CGRectContainsPoint(restart.boundingBox,location)) {
            [gameState setState:10];
            //[self.parent removeChild:self cleanup:TRUE];
            [self.parent removeAllChildrenWithCleanup:TRUE];
            [[CCDirector sharedDirector] resume];
            [[CCDirector sharedDirector] popScene];
        }
    }
}

@end
