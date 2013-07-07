//
//  CoinShop.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import "CoinShop.h"
#import "ShopContentLayer.h"
#import "MainTableView.h"
#import "iosVC.h"
#import "Powerup.h"
#import "RootViewController.h"
#import "CoinShopTable.h"

@implementation CoinShop
@synthesize parentLayer;


#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init:(GameState*)gs
{
	if( (self=[super initWithColor:ccc4(0,155,155,200)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        shopBG = [CCSprite spriteWithFile:@"lab.jpg"];
        shopBG.scale=.5;
        shopBG.position=ccp(winSize.width/2, winSize.height/2);
		[self addChild:shopBG];
		oneLevel = [CCSprite spriteWithFile:@"HeadItemside.png"];
        oneLevel.scale=.3;
		[self addChild:oneLevel];
        oneLevel.position = ccp( winSize.width/2 , 20);

        //CC
        gameState=gs;
        xpLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]]
                                        fontName:@"Futura"
                                        fontSize:15];
        [xpLab setColor:ccBLACK];
        [self addChild:xpLab];
        xpLab.position=ccp(100,305);
        coinLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]]
                                          fontName:@"Futura"
                                          fontSize:15];
        [coinLab setColor:ccBLACK];
        [self addChild:coinLab];
        coinLab.position=ccp(250,305);
        brainLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"brains"]]
                                           fontName:@"Futura"
                                           fontSize:15];
        [brainLab setColor:ccBLACK];
        [self addChild:brainLab];
        brainLab.position=ccp(420,305);
       
        shop=[[ShopContentLayer alloc] init:gameState];
        //shop.position=ccp(240*shop.pages,160);
        [self addChild:shop];
        currpage=1;
        
        left=[[CCSprite alloc] initWithFile:@"left.png"];
        left.position=ccp(20,20);
        left.scale=.4;
        [self addChild:left];
        right=[[CCSprite alloc] initWithFile:@"right.png"];
        right.position=ccp(460,20);
        right.scale=.4;
        [self addChild:right];
        
        //myTable=[[CoinShopTable alloc] initWithFrame:CGRectMake(50, 100, 400, 250) gameState:gameState rowArray:tableItems];
        //[[[[[CCDirector sharedDirector] openGLView] window] rootViewController].view addSubview:myTable];
        
        //CCScrollLayer *layer=[[CCScrollLayer alloc] initWithLayers:shop widthOffset:5];
        //[self addChild:layer];
        
        
        [self schedule:@selector(calc:) interval:.5f];
	}
	return self;
}

- (void)calc:(ccTime) dt {
    xpLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]];
    coinLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]];
    brainLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"brains"]];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (CGRectContainsPoint(oneLevel.boundingBox,location)) {
        //[gameState setState:-[gameState state]];
        parentLayer.isTouchEnabled=YES;
        [self.parent removeChild:self cleanup:TRUE];
        [[CCDirector sharedDirector] resume];
        //[self dealloc];
    }else if (CGRectContainsPoint(left.boundingBox,location) && currpage>1) {
        currpage--;
        [shop runAction:[CCSequence actions:[CCMoveTo actionWithDuration:.4 position:ccp(shop.position.x+480, shop.position.y)], nil, nil]];
    }else if (CGRectContainsPoint(right.boundingBox,location) && currpage<shop.pages) {
        currpage++;
        [shop runAction:[CCSequence actions:[CCMoveTo actionWithDuration:.4 position:ccp(shop.position.x-480, shop.position.y)], nil, nil]];
    }
    xpLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]];
    coinLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]];
    brainLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"brains"]];
}

- (void)dealloc
{
    [super dealloc];
}


@end
