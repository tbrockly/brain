//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"
#import "PauseLayer.h"
#import "LaunchLayer.h"
#import "Achievement.h"
#import "QuizLayer.h"
#import "EndRunLayer.h"
#import "SimpleAudioEngine.h"
#import "CountdownLayer.h"
#import "LevelData.h"
#import "LevelScore.h"
#include <AudioToolbox/AudioToolbox.h>

@implementation HudLayer
@synthesize brain;


#define degreesToRadians(x) (M_PI * x /180.0)
int curTar=0;
int achieveShow=0;
int targetx=110,targety=150;
CCSprite * achieveSprite;
CGPoint targets[]={ccp(targetx,targety+100) ,ccp(targetx-70,targety+70),ccp(targetx-100,targety),ccp(targetx-70,targety-70),ccp(targetx,targety-100), ccp(targetx+70,targety-70),ccp(targetx+100,targety),ccp(targetx+70,targety+70)};
-(id) init:(GameState*)myGameState
{
	if( (self=[super init] )) {
		// Enable touch events
        gameState=myGameState;
		self.isTouchEnabled = YES;
        coins=[[NSMutableArray alloc] init];
        botBar=[[CCSprite alloc] initWithFile:@"botBar.png" rect:CGRectMake(0, 0, 480, 40)];
        botBar.scaleY=.5;
        botBar.position = ccp(240, 10);
        [self addChild:botBar z:20];
        speedLab=[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%i",(int)gameState.vx]
                                           fntFile:@"arial16.fnt"];
        [speedLab setColor:ccBLACK];
        [self addChild:speedLab z:20];
        speedLab.position=ccp(420,10);
        arrowV=[CCSprite spriteWithFile:@"arrow.png"];
        arrowV.scale=.5;
        arrowV.position=ccp(390,10);
        [self addChild:arrowV z:20];
        arrowVV=[CCSprite spriteWithFile:@"arrow.png"];
        arrowVV.scale=.5;
        arrowVV.position=ccp(380,10);
        [self addChild:arrowVV z:20];
        LevelScore *hiScore=[[gameState levelScores] objectAtIndex:[gameState currLevel]];
        highscore=hiScore.score;
		scoreLab=[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%i",gameState.score]
                                        fntFile:@"arial16.fnt"];
        [scoreLab setColor:ccBLACK];
        [self addChild:scoreLab z:20];
        scoreLab.position=ccp(300,10);
        coinIcon=[CCSprite spriteWithFile:@"super_mario_coin.png"];
        coinIcon.scale=.4;
        coinIcon.position=ccp(210,305);
        [self addChild:coinIcon];
        
        brainIcon=[CCSprite spriteWithFile:@"Icon.png"];
        brainIcon.scale=.4;
        brainIcon.position=ccp(380,305);
        [self addChild:brainIcon];
        
        xpLab=[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]]
                                        fntFile:@"arial16.fnt"];
        [xpLab setColor:ccBLACK];
        [self addChild:xpLab];
        xpLab.position=ccp(100,305);
        coinLab=[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]]
                                          fntFile:@"arial16.fnt"];
        [coinLab setColor:ccBLACK];
        [self addChild:coinLab];
        coinLab.position=ccp(250,305);
        brainLab=[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"brains"]]
                                           fntFile:@"arial16.fnt"];
        [brainLab setColor:ccBLACK];
        [self addChild:brainLab];
        brainLab.position=ccp(420,305);
        
        highScoreLab=[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"Record: %i",highscore]
                                           fntFile:@"arial16.fnt"];
        [highScoreLab setColor:ccWHITE];
        [self addChild:highScoreLab z:20];
        highScoreLab.position=ccp(410,30);
        
        chargeLab=[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%i",gameState.charge]
                                           fntFile:@"arial16.fnt"];
        [chargeLab setColor:ccBLACK];
        [self addChild:chargeLab z:20];
        chargeLab.position=ccp(100,10);
        eng=[CCSprite spriteWithFile:@"lightning-icon.png" ];
        eng.scale=.15;
        eng.position=ccp(80,10);
        [self addChild:eng z:20];
        arrowD=[CCSprite spriteWithFile:@"arrow.png"];
        arrowD.scale=.5;
        arrowD.position=ccp(260,10);
        [self addChild:arrowD z:20];
        arrow1=[CCSprite spriteWithFile:@"arrow.png"];
        arrow1.rotation=90;
        arrow1.position=ccp(20,300);
        arrow1.opacity=0;
        [self addChild:arrow1];
        arrow2=[CCSprite spriteWithFile:@"arrow.png"];
        arrow2.rotation=90;
        arrow2.position=ccp(50,300);
        arrow2.opacity=0;
        [self addChild:arrow2];
        arrow3=[CCSprite spriteWithFile:@"arrow.png"];
        arrow3.rotation=90;
        arrow3.position=ccp(80,300);
        arrow3.opacity=0;
        [self addChild:arrow3];
        arrow4=[CCSprite spriteWithFile:@"arrow.png"];
        arrow4.rotation=90;
        arrow4.position=ccp(110,300);
        arrow4.opacity=0;
        [self addChild:arrow4];
        [self schedule:@selector(calc:) interval:.01f];
        [self schedule:@selector(addCoin:) interval:.3f];
        achieveSprite=[CCSprite spriteWithFile:@"Kawaii-Popsicle.gif"];
        achieveSprite.scale=.5;
        [self addChild:achieveSprite];
        achieveLab=[[CCLabelBMFont alloc] initWithString:@"" fntFile:@"arial16.fnt"];
        [achieveLab setColor:ccWHITE];
        [self addChild:achieveLab];
        achieveLab.position=ccp(-200,-200);
        
        brains = [[NSMutableArray alloc] init];
        [brains addObject:[[CCTextureCache sharedTextureCache] addImage:@"brain_test.png"]];
        [brains addObject:[[CCTextureCache sharedTextureCache] addImage:@"brain_shock.png"]];
        [brains addObject:[[CCTextureCache sharedTextureCache] addImage:@"brain_grrr.png"]];
        [brains addObject:[[CCTextureCache sharedTextureCache] addImage:@"brain_squash01.png"]];
        brain = [CCSprite spriteWithTexture:[brains objectAtIndex:0]];
        brain.scale=.4;
        brain.position = ccp(160, 160);
        [self addChild:brain z:1];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"pause.png"];
        oneLevel.scale=.5;
		oneLevel.position = ccp(20, 20);
		[self addChild:oneLevel z:20];
        
        audioBtn = [CCSprite spriteWithFile:@"kawaii_cupcake.gif"];
        audioBtn.scale=.5;
		audioBtn.position = ccp(winSize.width-20, winSize.height-20);
		[self addChild:audioBtn];
        
        card = [CCSprite spriteWithFile:@"cardback.jpg"];
        card.scale=.5;
        card.position=ccp(240,480);
        [self addChild:card z:2];
        
        bronzeBar=[CCSprite spriteWithFile:@"BronzeBar.png"];
        bronzeBar.scaleY=5;
        bronzeBar.position = ccp(600, 160);
        [self addChild:bronzeBar z:1];
        silverBar=[CCSprite spriteWithFile:@"SilverBar.png"];
        silverBar.scaleY=5;
        silverBar.position = ccp(600, 160);
        [self addChild:silverBar z:1];
        goldBar=[CCSprite spriteWithFile:@"GoldBar.png"];
        goldBar.scaleY=5;
        goldBar.position = ccp(600, 160);
        [self addChild:goldBar z:1];
        //[gameState setState:2];
        [gameState setState:1];
        [self runAction:[CCCallFuncN actionWithTarget:self selector:@selector(pushCountdown)]];
//        [self runAction:[CCSequence actions:
//                         ,
//                         [CCDelayTime actionWithDuration:1],
//                         [CCDelayTime actionWithDuration:1.2],
//                         [CCCallFuncN actionWithTarget:self.parent selector:@selector(showGame)],
//                         
//                         //[CCCallFuncN actionWithTarget:self selector:@selector(resumeGame)],
//                         nil]];
        [self schedule:@selector(tick:)];
        float pos=160+[gameState vy]/100;
        if([gameState dy] <240 && pos > 50+[gameState dy]*.5){
            brain.position=ccp(160,50+[gameState dy]*.5);
        }else{
            brain.position=ccp(160,pos);
        }
        brainimg=0;
        
	}	
	return self;
}

- (void)brainbounce {
    brain.texture=[brains objectAtIndex:arc4random()%3];
}

- (void)braingrr {
    brain.texture=[brains objectAtIndex:2];
}

- (void)brainsplat {
    brain.rotation=0;
    gameState.rot=0;
    gameState.vrot=0;
    brain.texture=[brains objectAtIndex:3];
}

- (void)tick:(ccTime) dt {
    if([gameState state]==0){
        brain.rotation=[gameState rot];
        float pos=160+[gameState vy]/100;
        if([gameState dy] <120 && pos > 60+[gameState dy]){
            brain.position=ccp(160,60+[gameState dy]);
        }else{
            brain.position=ccp(160,pos);
        }
        LevelData *data=[[gameState levels] objectAtIndex:[gameState currLevel]];
        
        if([gameState score]<data.gold+500 && [gameState score]>data.gold-500){
            goldBar.position=ccp((data.gold-[gameState score])+160,160);
        }else if([gameState score]<data.silver+500 && [gameState score]>data.silver-500){
            silverBar.position=ccp((data.silver-[gameState score])+160,160);
        }else if([gameState score]<data.bronze+500 && [gameState score]>data.bronze-500){
            bronzeBar.position=ccp((data.bronze-[gameState score])+160,160);
        }

    }
}

-(void)addCoins:(int)coinVal{
    CCLabelTTF* tempCoin=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"+%i",coinVal] fontName:@"FontStuck Extended" fontSize:64];
    [tempCoin setColor:ccYELLOW];
    tempCoin.position =brain.position;
    [self addChild:tempCoin z:0];
    [tempCoin runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:.4 position:ccp(240,160)],
                     [CCDelayTime actionWithDuration:.5],
                     [CCCallFuncN actionWithTarget:self selector:@selector(scalePoints:)],
                     [CCCallFuncN actionWithTarget:self selector:@selector(moveCoins:)],
                     [CCDelayTime actionWithDuration:.5],
                     [CCCallBlock actionWithBlock:^(){
                        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]+(coinVal) forKey:@"gold"];
                    }],
                     [CCCallFuncN actionWithTarget:self selector:@selector(popSelf:)],
                     nil]];
}
-(void)popSelf: (id) sender{
    [sender removeFromParentAndCleanup:YES];
}
-(void)scalePoints: (id) sender{
    [sender runAction:[CCScaleTo actionWithDuration:.5 scale:.1]];
}
-(void)moveCoins: (id) sender{
    [sender runAction:[CCMoveTo actionWithDuration:.5 position:coinLab.position]];
}

-(void)addBrains:(int)brainVal{
        CCLabelTTF* tempBrain=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"+%i",brainVal] fontName:@"FontStuck Extended" fontSize:64];
        [tempBrain setColor:ccBLUE];
        tempBrain.position =brain.position;
        [self addChild:tempBrain z:0];
        [tempBrain runAction:[CCSequence actions:
                             [CCMoveTo actionWithDuration:.4 position:ccp(240,160)],
                             [CCDelayTime actionWithDuration:1.5],
                             [CCCallFuncN actionWithTarget:self selector:@selector(scalePoints:)],
                             [CCCallFuncN actionWithTarget:self selector:@selector(moveBrains:)],
                             [CCDelayTime actionWithDuration:.5],
                              [CCCallBlock actionWithBlock:^(){
                                    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"brains"]+(brainVal) forKey:@"brains"];
                                }],
                             [CCCallFuncN actionWithTarget:self selector:@selector(popSelf:)],
                             nil]];
}
-(void)moveBrains: (id) sender{
    [sender runAction:[CCMoveTo actionWithDuration:.5 position:brainLab.position]];
}

-(void)addxp:(int)xVal{
    CCLabelTTF* tempBrain=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"+%i",xVal] fontName:@"FontStuck Extended" fontSize:64];
    [tempBrain setColor:ccGREEN];
    tempBrain.position =brain.position;
    [self addChild:tempBrain z:0];
    [tempBrain runAction:[CCSequence actions:
                          [CCMoveTo actionWithDuration:.4 position:ccp(240,160)],
                          [CCDelayTime actionWithDuration:.5],
                          [CCCallFuncN actionWithTarget:self selector:@selector(scalePoints:)],
                          [CCCallFuncN actionWithTarget:self selector:@selector(movex:)],
                          [CCDelayTime actionWithDuration:.5],
                          [CCCallBlock actionWithBlock:^(){
                            [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]+(xVal) forKey:@"xp"];
                            }],
                          [CCCallFuncN actionWithTarget:self selector:@selector(popSelf:)],
                          nil]];
}
-(void)movex: (id) sender{
    [sender runAction:[CCMoveTo actionWithDuration:.5 position:xpLab.position]];
}


-(void) drawCard{
    
    //card.position=ccp(240,160);
    //[self addChild:[[CCColorLayer alloc] initWithColor:ccc4(0, 0, 0, 255)] z:199];
    [gameState setState:1];
    [self runAction:[CCSequence actions:
                     [CCCallFuncN actionWithTarget:self selector:@selector(pushLaunch)],
                     [CCDelayTime actionWithDuration:1],
                     [CCDelayTime actionWithDuration:1.2],
                     [CCCallFuncN actionWithTarget:self.parent selector:@selector(showGame)],
                     
                     //[CCCallFuncN actionWithTarget:self selector:@selector(resumeGame)],
                     nil]];
    
//    [card runAction:[CCSequence actions:[CCMoveTo actionWithDuration:.6 position:ccp(240,160)],
//                     [CCCallFuncN actionWithTarget:self selector:@selector(pushQuiz)],
//                     [CCDelayTime actionWithDuration:1],
//                     [CCDelayTime actionWithDuration:1.2],
//                     [CCCallFuncN actionWithTarget:self.parent selector:@selector(showGame)],
//                     [CCMoveTo actionWithDuration:.6 position:ccp(240,480)],
//                     [CCCallFuncN actionWithTarget:self selector:@selector(resumeGame)],
//                     nil]];
}
-(void)resumeGame{
    [gameState setState:0];
}

-(void)pushCountdown{
    CountdownLayer *lol=[[CountdownLayer alloc] init:gameState];
    [self addChild: lol z:10];
}

-(void)pushEnd{
    LevelScore *hiScore=[[gameState levelScores] objectAtIndex:[gameState currLevel]];
    if(hiScore.score<[gameState score]){
        [hiScore setScore:[gameState score]];
    }
    EndRunLayer *lol=[[EndRunLayer alloc] init:gameState];
    [self addChild: lol z:10];
}

-(void)pushLaunch{
    //[self.parent hideGame];
    //[[CCDirector sharedDirector] pause];
    LaunchLayer *lol=[[LaunchLayer alloc] init:gameState];
    [self addChild: lol z:10];
    //QuizScene *q = [[QuizScene alloc] init:gameState];
    //CCTransitionFlipAngular *cctf = [CCTransitionFlipAngular transitionWithDuration:1 scene:q];
    //[[CCDirector sharedDirector] pushScene:cctf];
}

-(void)restart{
    [self.parent restart];
}

-(void)pushQuiz{
    
    [self.parent hideGame];
    QuizScene *q = [[QuizScene alloc] init:gameState];
    CCTransitionFlipAngular *cctf = [CCTransitionFlipAngular transitionWithDuration:1 scene:q];
    [[CCDirector sharedDirector] pushScene:cctf];
}

- (void)addCoin:(ccTime) dt {
    [gameState calcAchieves];
    [self showAchieves];
    if([gameState coins]>0){
//        Coin* coin = [Coin spriteWithFile:@"super_mario_coin.png"];
//        coin.position=ccp(0,0);
//        [coin setScale:.5];
//        [coin setTarget:targets[curTar]];
//        if(curTar++ >6){ curTar=0;}
//        [self addChild:coin z:100];
//        [coins addObject:coin];
//        gameState.coins=gameState.coins-1;
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
//    for(Coin *coin in coins){
//        coin.speed=coin.speed+.5;
//        if(remObj == -1 &&  coin.position.x==coin.target.x &&coin.position.y==coin.target.y){
//            if(coin.position.x==targetx && coin.position.y==targety){
//                [self removeChild:coin cleanup:true];
//                remObj=[coins indexOfObject:coin];
//            }else{
//                coin.target=ccp(targetx,targety);
//                coin.speed=-20;
//            }
//        }
//        if(coin.speed>0){
//            float xtrans=coin.target.x-coin.position.x;
//            xtrans=xtrans>0?MIN(coin.speed,xtrans):MAX(-coin.speed,xtrans);
//            float ytrans=coin.target.y-coin.position.y;
//            ytrans=ytrans>0?MIN(coin.speed,ytrans):MAX(-coin.speed,ytrans);
//            coin.position = ccp(coin.position.x+xtrans,coin.position.y+ytrans);
//        }
//    }
    if(remObj >-1){
        [coins removeObjectAtIndex:remObj];
    }
    if([gameState comboTimer]<3) {
        int temp = [gameState comboVal];
        int count=1;
        CCSprite* myArrow= arrow1;
        while(temp>1){
            if(temp%10==1){
                myArrow.rotation=0;
            }else{
                myArrow.rotation=180;
            }
            myArrow.opacity=255-[gameState comboTimer]*75;
            count++;
            if(count==2){myArrow=arrow2;}
            else if (count==3){myArrow=arrow3;}
            else if (count==4){myArrow=arrow4;}
            temp=temp/10;
        }}else{
            arrow1.opacity=0;
            arrow2.opacity=0;
            arrow3.opacity=0;
            arrow4.opacity=0;
        }
    chargeLab.string=[NSString stringWithFormat:@"%i",gameState.charge];
    scoreLab.string=[NSString stringWithFormat:@"%i",gameState.score];
    LevelData *currLvl=[gameState.levels objectAtIndex:[gameState currLevel]];
    speedLab.string=[NSString stringWithFormat:@"%.1f",[gameState vx]];
    xpLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"xp"]];
    coinLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"gold"]];
    brainLab.string=[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"brains"]];
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
    if([gameState state]==0){
        if(gameState.charge>0 ) {
            if(firstTouch.y-location.y>100){
                [gameState setVx:[gameState vx]+100];
                [gameState setDy:(fabs([gameState dy])-20)];
                [gameState setVy:-(fabs([gameState vy])+200)];
                [gameState setCharge:(gameState.charge-1)];
            }
            if(firstTouch.y-location.y<-100){
                [gameState setVx:[gameState vx]+100];
                [gameState setDy:(fabs([gameState dy])+20)];
                [gameState setVy:(fabs([gameState vy])+200)];
                [gameState setCharge:(gameState.charge-1)];
            }
        }
        
        CGRect rect=oneLevel.boundingBox;
        if (CGRectContainsPoint(rect,location)) {
            [gameState setState:2];
            PauseLayer *q = [[PauseLayer alloc] init];
            q->gameState=gameState;
            [self.parent addChild:q z:10];
            [[CCDirector sharedDirector] pause];
        }
        if (CGRectContainsPoint(audioBtn.boundingBox,location)) {
            if(hudplayer == NULL){
            SystemSoundID mySound;
            NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"JohnHughes" ofType:@"mp3"];
            AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath],&mySound );
            hudplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
            hudplayer.numberOfLoops=-1;
            hudplayer.volume=.3;
            [hudplayer play];
            }else if (hudplayer.playing){
                [hudplayer stop];
            } else{
                [hudplayer play];
            }
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	firstTouch = [[CCDirector sharedDirector] convertToGL:location];
}

-(void)dropBrain{
    LevelScore *hiScore=[[gameState levelScores] objectAtIndex:[gameState currLevel]];
    if(hiScore.score<[gameState score]){
        [hiScore setScore:[gameState score]];
    }
    [gameState setState:99];
    [brain runAction:[CCSequence actions:
                      [CCMoveTo actionWithDuration:2 position:ccp(brain.position.x, -30)],
                      [CCCallFuncN actionWithTarget:self.parent selector:@selector(addTotal)],
                      nil]];
}

-(void)dealloc{
    [self.parent showGame];
    [super dealloc];
}

@end
