//
//  TotalLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 12/2/12.
//
//

#import "TotalLayer.h"

@implementation TotalLayer

-(id) init:(GameState*)gs
{
	if( (self=[super init] )) {
		// Enable touch events
        
        back = [CCSprite spriteWithFile:@"FoodItemside.png"];
        back.scale=3;
		back.position = ccp(240, 160);
		[self addChild:back];
        gameState=gs;
        arrowV=[CCSprite spriteWithFile:@"arrow.png"];
        arrowV.scale=.5;
        arrowV.position=ccp(150,100);
        [self addChild:arrowV];
        arrowVV=[CCSprite spriteWithFile:@"arrow.png"];
        arrowVV.scale=.5;
        arrowVV.position=ccp(140,100);
        [self addChild:arrowVV];
        scoreRoll=0;
		scoreLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",scoreRoll]
                                           fontName:@"Futura"
                                           fontSize:15];
        [scoreLab setColor:ccWHITE];
        [self addChild:scoreLab];
        scoreLab.position=ccp(240,200);
        
        arrowD=[CCSprite spriteWithFile:@"arrow.png"];
        arrowD.scale=.5;
        arrowD.position=ccp(140,200);
        [self addChild:arrowD];
        [self schedule:@selector(calc:) interval:.001f];
        
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
		
	}
	return self;
}

- (void)calc:(ccTime) dt {
    if (scoreRoll<[gameState score]) {
        scoreRoll=scoreRoll+89;
        scoreLab.string=[NSString stringWithFormat:@"%i",scoreRoll];
    }else{
        scoreRoll=[gameState score];
        scoreLab.string=[NSString stringWithFormat:@"%i",scoreRoll];
    }
}

@end
