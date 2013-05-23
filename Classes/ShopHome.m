//
//  ShopHome.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import "ShopHome.h"
#import "ShopRow.h"
#import "MainTableView.h"
#import "iosVC.h"
#import "RootViewController.h"
#import "XPShop.h"
#import "CoinShop.h"
#import "BrainShop.h"

@implementation ShopHome
@synthesize parentLayer;


#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init:(GameState*)gs
{
	if( (self=[super initWithColor:ccc4(0,155,155,200)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        shopBG = [CCSprite spriteWithFile:@"Shop.png"];
        shopBG.scale=.5;
        shopBG.position=ccp(winSize.width/2, winSize.height/2);
		[self addChild:shopBG];
        but1=[CCColorLayer layerWithColor:ccc4(200, 100, 100, 0) width:100 height:100];
        [but1 setPosition:ccp(40,170)];
        [self addChild:but1];
        but2=[CCColorLayer layerWithColor:ccc4(200, 100, 100, 0) width:100 height:100];
        [but2 setPosition:ccp(190,170)];
        [self addChild:but2];
        but3=[CCColorLayer layerWithColor:ccc4(200, 100, 100, 0) width:100 height:100];
        [but3 setPosition:ccp(340,170)];
        [self addChild:but3];
		oneLevel = [CCSprite spriteWithFile:@"HeadItemside.png"];
        oneLevel.scale=.5;
		[self addChild:oneLevel];
        oneLevel.position = ccp(20, 20);

        gameState=gs;
        
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
    if (CGRectContainsPoint(but1.boundingBox,location)) {
        XPShop *q = [[XPShop alloc] init:gameState];
        self.isTouchEnabled=NO;
        [q setParentLayer:self];
        [self.parent addChild:q z:10];
    }
    if (CGRectContainsPoint(but2.boundingBox,location)) {
        CoinShop *q = [[CoinShop alloc] init:gameState];
        self.isTouchEnabled=NO;
        [q setParentLayer:self];
        [self.parent addChild:q z:10];
    }
    if (CGRectContainsPoint(but3.boundingBox,location)) {
        BrainShop *q = [[BrainShop alloc] init:gameState];
        self.isTouchEnabled=NO;
        [q setParentLayer:self];
        [self.parent addChild:q z:10];
    }
    //}
}

- (void)dealloc
{
    [super dealloc];
}


@end
