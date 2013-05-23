//
//  CoinShop.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import "CoinShop.h"
#import "ShopRow.h"
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
        shopBG = [CCSprite spriteWithFile:@"Shop2.png"];
        shopBG.scale=.5;
        shopBG.position=ccp(winSize.width/2, winSize.height/2);
		[self addChild:shopBG];
		oneLevel = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(20, 20, 40, 40)];
		[self addChild:oneLevel];
        oneLevel.position = ccp(20, winSize.height/2);

        //CC
        gameState=gs;
        NSMutableArray *tableItems=[[NSMutableArray alloc] init];
        for (Powerup *p in gameState.powerups){
            if(p.collectable){
                int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.powStr];
                int freqLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.freqStr];
                int i=1;
                while( i<11){
                    if(i>powLvl){
                        CoinShopRow *row=[CoinShopRow alloc];
                        row.iconName=p.imgName;
                        row.price=100*i*i;
                        row.level=i;
                        row.type=0;
                        row.name=p.name;
                        row.text=[NSString stringWithFormat:@"%@ - power level %i    Price: %i", p.name, i, row.price];
                        [tableItems addObject:row];
                    }
                    if(i>freqLvl){
                        CoinShopRow *row=[CoinShopRow alloc];
                        row.iconName=p.imgName;
                        row.price=100*i*i;
                        row.level=i;
                        row.type=1;
                        row.name=p.name;
                        row.text=[NSString stringWithFormat:@"%@ - frequency level %i    Price: %i", p.name, i, row.price];
                        [tableItems addObject:row];
                    }
                    i++;
                }
            }
        }
        
        myTable=[[CoinShopTable alloc] initWithFrame:CGRectMake(50, 100, 400, 250) gameState:gameState rowArray:tableItems];
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
