//
//  BrainShop.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import "BrainShop.h"
#import "MainTableView.h"
#import "iosVC.h"
#import "RootViewController.h"
#import "GlobalParam.h"
#import "BrainShopTable.h"

@implementation BrainShop
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
        NSMutableArray *tableItems=[[NSMutableArray alloc] init];
        for (GlobalParam *p in gameState.globalParams){
                int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.name];
                int i=1;
                while( i<11){
                    if(i>powLvl){
                        BrainShopRow *row=[BrainShopRow alloc];
                        row.iconName=p.imgName;
                        row.price=10*i*i;
                        row.level=i;
                        row.type=0;
                        row.name=p.name;
                        row.text=[NSString stringWithFormat:@"%@ - power level %i    Price: %i", p.name, i, row.price];
                        [tableItems addObject:row];
                    }
                    i++;
                }
        }
        
        myTable=[[BrainShopTable alloc] initWithFrame:CGRectMake(50, 100, 400, 250) gameState:gameState rowArray:tableItems];
        [[[[[CCDirector sharedDirector] openGLView] window] rootViewController].view addSubview:myTable];
        
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
