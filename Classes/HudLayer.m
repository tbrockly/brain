//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"
#import "PauseLayer.h"
#import "Coin.h"
#import "Achievement.h"

@implementation HudLayer
@synthesize oneLevel;
@synthesize gameState;
@synthesize score;

#define degreesToRadians(x) (M_PI * x /180.0)
CCLabelTTF *scoreLab, *chargeLab,*achieveLab;
int curTar=0;
int achieveShow=0;
int targetx=135,targety=175;
CCSprite * achieveSprite;
CGPoint targets[]={ccp(targetx,targety+100) ,ccp(targetx-70,targety+70),ccp(targetx-100,targety),ccp(targetx-70,targety-70),ccp(targetx,targety-100), ccp(targetx+70,targety-70),ccp(targetx+100,targety),ccp(targetx+70,targety+70)};
-(id) init
{
	if( (self=[super init] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        coins=[[NSMutableArray alloc] init];
		scoreLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",gameState.score]
                                        fontName:@"Futura" 
                                        fontSize:30];
        [scoreLab setColor:ccWHITE];
        [self addChild:scoreLab];
        scoreLab.position=ccp(300,30);
        chargeLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",gameState.charge]
                                           fontName:@"Futura" 
                                           fontSize:30];
        [chargeLab setColor:ccWHITE];
        [self addChild:chargeLab];
        chargeLab.position=ccp(30,240);
        [self schedule:@selector(calc:) interval:.01f];
        [self schedule:@selector(addCoin:) interval:.3f];
        achieveSprite=[CCSprite spriteWithFile:@"Kawaii-Popsicle.gif"];
        achieveSprite.scale=2;
        [self addChild:achieveSprite];
        achieveLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"huigyfucvk",gameState.charge]
    fontName:@"Futura" 
    fontSize:30];
        [achieveLab setColor:ccWHITE];
        [self addChild:achieveLab];
        achieveLab.position=ccp(-200,-200);
        
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 40, 40)];
		oneLevel.position = ccp(20, 20);
		[self addChild:oneLevel];
	}	
	return self;
}

- (void)addCoin:(ccTime) dt {
    [gameState calcAchieves];
    [self showAchieves];
    if([gameState coins]>0){
        Coin* coin = [Coin spriteWithFile:@"super_mario_coin.png"];
        coin.position=ccp(0,0);
        [coin setScale:.5];
        [coin setTarget:targets[curTar]];
        if(curTar++ >6){ curTar=0;}
        [self addChild:coin z:100];
        [coins addObject:coin];
        gameState.coins=gameState.coins-1;
    }if(achieveShow>0){
        achieveSprite.position=ccp(200,200);
        achieveLab.position=ccp(200,200);
    }else{
        achieveSprite.position=ccp(-250,-250);
        achieveLab.position=ccp(-250,-250);
    }
    if(achieveShow>0){
        achieveShow--;
    }
    
}

-(void) showAchieves{
    if (achieveShow==0 && [gameState displayAchieves].count>0){
        achieveShow=5;
        Achievement *a = [[gameState displayAchieves] lastObject];
        NSString *s=a.title;

        [achieveLab setString:s];
        [[gameState displayAchieves] removeLastObject];
    }
}

- (void)calc:(ccTime) dt {
    int remObj=-1;
    for(Coin *coin in coins){
        coin.speed=coin.speed+.5;
        if(remObj == -1 &&  coin.position.x==coin.target.x &&coin.position.y==coin.target.y){
            if(coin.position.x==targetx && coin.position.y==targety){
                [self removeChild:coin cleanup:true];
                remObj=[coins indexOfObject:coin];
            }else{
                coin.target=ccp(targetx,targety);
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
    chargeLab.string=[NSString stringWithFormat:@"%i",gameState.charge];
    scoreLab.string=[NSString stringWithFormat:@"%i",gameState.score];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [answer resignFirstResponder];
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Choose one of the touches to work with
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGRect rect=oneLevel.boundingBox;
    if (CGRectContainsPoint(rect,location)) {
        [gameState setState:2];
        PauseLayer *q = [[PauseLayer alloc] init];
        [q setGameState:self.gameState];
        [self.parent addChild:q z:10];
        [[CCDirector sharedDirector] pause];
    }
}

@end
