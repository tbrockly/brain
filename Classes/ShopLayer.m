//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Shoplayer.h"
#import "ShopRow.h"
#import "MainTableView.h"
#import "iosVC.h"
#import "RootViewController.h"

@implementation ShopLayer
MainTableView *myTable;

#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init:(GameState*)gs
{
	if( (self=[super initWithColor:ccc4(0,155,155,200)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(20, 20, 40, 40)];
		[self addChild:oneLevel];
        oneLevel.position = ccp(20, winSize.height/2);
        //CC
        gameState=gs;
        
        myTable=[[MainTableView alloc] initWithFrame:CGRectMake(100, 0, 200, 320) gameState:gameState];
        [[[[[CCDirector sharedDirector] openGLView] window] rootViewController].view addSubview:myTable];
        
        //CCScrollLayer *layer=[[CCScrollLayer alloc] initWithLayers:shop widthOffset:5];
        //[self addChild:layer];

        
	}	
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //if([gameState state]==2){
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        if (CGRectContainsPoint(oneLevel.boundingBox,location)) {
            //[gameState setState:-[gameState state]];
            parentLayer.isTouchEnabled=YES;
            [self.parent removeChild:self cleanup:TRUE];
            [myTable removeFromSuperview];
            [[CCDirector sharedDirector] resume];
            //[self dealloc];
        }
    //}
}

- (void)dealloc
{
    [super dealloc];
}


@end
