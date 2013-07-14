//
//  EndRunLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 6/30/13.
//
//

#import "EndRunLayer.h"

@implementation EndRunLayer
-(id) init:(GameState*) gs
{
	if( (self=[super initWithColor:ccc4(0,0,0,100)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		//CGSize winSize = [[CCDirector sharedDirector] winSize];
        goodRun = [[CCLabelTTF alloc] initWithString:@"GOOD RUN!" fontName:@"Verdana" fontSize:30];
        goodRun.position=ccp(240,280);
        [self addChild:goodRun];
        girl = [CCSprite spriteWithFile:@"girl.png"];
        girl.scale=.5;
        girl.position = ccp(400,160);
        [self addChild:girl];
		shop = [CCSprite spriteWithFile:@"ShopB.png"];
        shop.position = ccp(300,100);
        [self addChild:shop];
        restart = [CCSprite spriteWithFile:@"RetryB.png"];
        restart.position = ccp(200, 100);
        [self addChild:restart];
        back = [CCSprite spriteWithFile:@"BackButton.png"];
        back.position = ccp(100, 100);
        [self addChild:back];
	}
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //if([gameState state]==98){
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        if (CGRectContainsPoint(shop.boundingBox,location)) {
            [gameState setState:0];
            [self.parent.parent goToShop];
            
            [self.parent removeChild:self cleanup:TRUE];
        }
        if (CGRectContainsPoint(restart.boundingBox,location)) {
            [gameState setState:0];
            //[self.parent removeChild:self cleanup:TRUE];
            [self.parent.parent restart];
            [self.parent removeChild:self cleanup:TRUE];
            //[[CCDirector sharedDirector] popScene];
        }
        if (CGRectContainsPoint(back.boundingBox,location)) {
            [gameState setState:0];
            //[self.parent removeChild:self cleanup:TRUE];
            [self.parent.parent goToLevelSelect];
            [self.parent removeChild:self cleanup:TRUE];
            //[[CCDirector sharedDirector] popScene];
        }
    //}
}

@end
