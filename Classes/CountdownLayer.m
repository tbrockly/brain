//
//  EndRunLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 6/30/13.
//
//

#import "CountdownLayer.h"

@implementation CountdownLayer
-(id) init:(GameState*) gs
{
	if( (self=[super initWithColor:ccc4(0,0,0,100)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		//CGSize winSize = [[CCDirector sharedDirector] winSize];
        reds = [CCSprite spriteWithFile:@"HeadItemside.png"];
        reds.scale=.5;
        reds.position = ccp(240,160);
        [self addChild:reds];
		blues = [CCSprite spriteWithFile:@"BodyItemside.png"];
        blues.position = ccp(240,560);
        [self addChild:blues];
        greens = [CCSprite spriteWithFile:@"FoodItemside.png"];
        greens.scale=2;
        greens.position = ccp(240,560);
        [self addChild:greens];
        [self countdown];
	}
	return self;
}

- (void)countdown{
    [self runAction:[CCSequence actions:
                     [CCCallFuncN actionWithTarget:self selector:@selector(red)],
                     [CCDelayTime actionWithDuration:1],
                     [CCCallFuncN actionWithTarget:self selector:@selector(blue)],
                     [CCDelayTime actionWithDuration:1],
                     [CCCallFuncN actionWithTarget:self selector:@selector(green)],
                     [CCDelayTime actionWithDuration:1],
                     [CCCallFuncN actionWithTarget:self selector:@selector(poppy)],
                     nil]];
    
}

- (void)red{
    reds.position= ccp(240,160);
}
- (void)blue{
    blues.position= ccp(240,160);
}
- (void)green{
    greens.position= ccp(240,160);
}
- (void)poppy{
    [self.parent pushLaunch];
    [self.parent removeChild:self cleanup:YES];
}



@end
