//
//  ShopHome.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import "ShopHome.h"
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
		oneLevel = [CCSprite spriteWithFile:@"RetryB.png"];
		[self addChild:oneLevel];
        oneLevel.position = ccp(150, 30);
        back = [CCSprite spriteWithFile:@"BackButton.png"];
		[self addChild:back];
        back.position = ccp(50, 30);
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
        
        lvlLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"level"]]
                                           fontName:@"Futura"
                                           fontSize:60];
        [lvlLab setColor:ccBLACK];
        [self addChild:lvlLab];
        lvlLab.position=ccp(420,65);
        
        float tonext=[[NSUserDefaults standardUserDefaults] integerForKey:@"tonext"];
        float curxp=[[NSUserDefaults standardUserDefaults] integerForKey:@"curxp"];
        float widLol=300.0f*((float)curxp/(float)tonext);
        xpBar=[CCColorLayer layerWithColor:ccc4(250, 250, 50, 255) width:widLol height:50];
        [xpBar setPosition:ccp(40,85)];
        [self addChild:xpBar];
        
        
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
    //if([gameState state]==2){
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (CGRectContainsPoint(oneLevel.boundingBox,location)) {
        
        //[gameState setState:-[gameState state]];
        //parentLayer.isTouchEnabled=YES;
        //[self.parent removeChild:self cleanup:TRUE];
        //[myTable removeFromSuperview];
        //[[CCDirector sharedDirector] resume];
        //[self dealloc];
        [self.parent restart];
    }
    if (CGRectContainsPoint(back.boundingBox,location)) {
        [self.parent goToLevelSelect];
        [self.parent removeChild:self cleanup:TRUE];
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
