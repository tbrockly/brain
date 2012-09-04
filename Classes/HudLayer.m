//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"
#import "Coin.h"

@implementation HudLayer
@synthesize oneLevel;
@synthesize gameState;
@synthesize score,coins;

#define degreesToRadians(x) (M_PI * x /180.0)
CCLabelTTF *scoreLab;
int curTar=0;
int coinCount=0;
CGPoint targets[]={ccp(175,125+100) ,ccp(175-70,125+70),ccp(175-100,125),ccp(175-70,125-70),ccp(175,125-100), ccp(175+70,125-70),ccp(175+100,125),ccp(175+70,125+70)};
-(id) init
{
	if( (self=[super init] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        coins=[[NSMutableArray alloc] init];
		scoreLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",gameState.score]
                                        fontName:@"Arial" 
                                        fontSize:30];
        [scoreLab setColor:ccBLACK];
        [self addChild:scoreLab];
        scoreLab.position=ccp(300,30);
        [self schedule:@selector(calc:) interval:.01f];
        [self schedule:@selector(addCoin:) interval:.2f];
	}	
	return self;
}

-(void) createCoins:(int) coinAdd{
    coinCount=coinCount+coinAdd;
}

- (void)addCoin:(ccTime) dt {
    if(coinCount>0){
        Coin* coin = [Coin spriteWithFile:@"Icon-Small.png"];
        coin.position=ccp(0,0);
        [coin setScale:.5];
        [coin setTarget:targets[curTar]];
        if(curTar++ >6){ curTar=0;}
        [self addChild:coin z:100];
        [coins addObject:coin];
        coinCount--;
    }
}

- (void)calc:(ccTime) dt {
    int remObj=-1;
    for(Coin *coin in coins){
        coin.speed=coin.speed+.5;
        if(remObj == -1 &&  coin.position.x==coin.target.x &&coin.position.y==coin.target.y){
            if(coin.position.x==175 && coin.position.y==125){
                [self removeChild:coin cleanup:true];
                remObj=[coins indexOfObject:coin];
            }else{
                coin.target=ccp(175,125);
                coin.speed=-20;
            }
        }
        if(coin.speed>0){
            float xtrans=coin.target.x-coin.position.x;
            xtrans=xtrans>0?MIN(coin.speed,xtrans):MAX(-coin.speed,xtrans);
            float ytrans=coin.target.y-coin.position.y;
            ytrans=ytrans>0?MIN(coin.speed,ytrans):MAX(-coin.speed,ytrans);
            coin.position = ccp(coin.position.x+xtrans,coin.position.y+ytrans);
        }
    }
    if(remObj >-1){
        [coins removeObjectAtIndex:remObj];
    }
    
    scoreLab.string=[NSString stringWithFormat:@"%i",gameState.score];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [answer resignFirstResponder];
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
