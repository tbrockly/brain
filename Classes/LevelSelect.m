//
//  LevelSelect.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/7/13.
//
//

#import "LevelSelect.h"
#import "LevelData.h"
#import "LevelScore.h"
@implementation LevelSelect
@synthesize parentLayer;
#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init:(GameState*)gs
{
	if( (self=[super init] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        gameState=gs;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        ///shopBG = [CCSprite spriteWithFile:@"Shop.png"];
        //shopBG.scale=.5;
        //shopBG.position=ccp(winSize.width/2, winSize.height/2);
		//[self addChild:shopBG];
        levels = [[NSMutableArray alloc] init];
        for(int i=0;i<[gameState.levels count];i++){
            int y=320-((i/4)*110+50);
            CCSprite *sprite=[CCSprite spriteWithFile:@"HeadItemside.png"];
            [sprite setPosition:ccp(70+(i%4)*110,y)];
            [self addChild:sprite];
            [levels addObject:sprite];
            CCLabelTTF *lab=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",i+1] fontName:@"Verdana" fontSize:20];
            [lab setPosition:ccp(70+(i%4)*110,y+10)];
            [self addChild:lab];
            LevelScore *levelScore=[[gameState levelScores] objectAtIndex:i];
            LevelData *data=[[gameState levels] objectAtIndex:i];
            CCSprite *medal=[CCSprite alloc];
            int high = levelScore.score;
            
            if(high>data.gold){
                medal=[CCSprite spriteWithFile:@"medals3g.png"];
            }else if(high>data.silver){
                medal=[CCSprite spriteWithFile:@"medals2.png"];
            }else if(high>data.bronze){
                medal=[CCSprite spriteWithFile:@"medals1.png"];
            }else {
                medal=[CCSprite spriteWithFile:@"medals.png"];
                [medal setPosition:ccp(70+(i%4)*110,y-20)];
                [self addChild:medal];
               
                break;
            }
            [medal setPosition:ccp(70+(i%4)*110,y-20)];
            [self addChild:medal];
        }
        
	}
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //if([gameState state]==2){
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    for(int i=0;i<[levels count];i++){
        CCSprite *sprite=[levels objectAtIndex:i];
        if (CGRectContainsPoint(sprite.boundingBox,location)) {
            gameState.currLevel=i;
            if(gameState.currLevel==0){
                gameState.forceMathType=1;
                gameState.addDiff=10;
                gameState.startString=@"Level 1 - Easy Addition";
            }else if(gameState.currLevel==1){
                gameState.forceMathType=1;
                gameState.addDiff=100;
                gameState.startString=@"Level 2 - Medium Addition";
            }else if(gameState.currLevel==2){
                gameState.forceMathType=2;
                gameState.subDiff=20;
                gameState.startString=@"Level 3 - Easy Subtraction";
            }else if(gameState.currLevel==3){
                gameState.forceMathType=2;
                gameState.subDiff=200;
                gameState.startString=@"Level 4 - Medium Subtraction";
            }else if(gameState.currLevel==4){
                gameState.forceMathType=5;
                gameState.addDiff=100;
                gameState.subDiff=200;
                gameState.startString=@"Level 5 - Medium Addition and Subtraction";
            }else{
                gameState.forceMathType=0;
                gameState.addDiff=500;
                gameState.subDiff=500;
                gameState.multDiff=13;
                gameState.divDiff=13;
                gameState.startString=@"Level X - Time Lord";
            }
            [self.parent restart];
        }
        //[gameState setState:-[gameState state]];
        //parentLayer.isTouchEnabled=YES;
        //[self.parent removeChild:self cleanup:TRUE];
        //[myTable removeFromSuperview];
        //[[CCDirector sharedDirector] resume];
        //[self dealloc];
        
    }
    
    //}
}

- (void)dealloc
{
    [super dealloc];
}


@end
