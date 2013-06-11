//
//  XPShop.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import "XPShop.h"
#import "XPShopTable.h"
#import "MainTableView.h"
#import "iosVC.h"
#import "RootViewController.h"
#import "Shield.h"

@implementation XPShop
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
        //Table info generation
        
        NSMutableArray *tableItems=[[NSMutableArray alloc] init];
        for (Shield *s in gameState.shields){
            int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:s.powStr];
            int durLvl=[[NSUserDefaults standardUserDefaults] integerForKey:s.durStr];
            int i=1;
            while( i<11){
                if(i>powLvl){
                    XPShopRow *row=[XPShopRow alloc];
                    row.iconName=s.imgName;
                    row.price=10*i*i;
                    row.level=i;
                    row.type=0;
                    row.name=s.name;
                    row.text=[NSString stringWithFormat:@"%@ - power level %i    Price: %i", s.name, i, row.price];
                    [tableItems addObject:row];
                }
                i++;
            }
            i=1;
            while( i<11){
                if(i>durLvl){
                    XPShopRow *row=[XPShopRow alloc];
                    row.iconName=s.imgName;
                    row.price=10*i*i;
                    row.level=i;
                    row.type=1;
                    row.name=s.name;
                    row.text=[NSString stringWithFormat:@"%@ - duration level %i    Price: %i", s.name, i, row.price];
                    [tableItems addObject:row];
                }
                i++;
            }
        }
        
        myTable=[[XPShopTable alloc] initWithFrame:CGRectMake(50, 100, 400, 250) gameState:gameState rowArray:tableItems];
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
    xpLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]];
    coinLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]];
    brainLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"brains"]];
}

- (void)dealloc
{
    [super dealloc];
}


@end
