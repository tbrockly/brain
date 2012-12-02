//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "QuizLayer.h"

@implementation QuizScene


- (id)init:(GameState*)gs{
    if ((self = [super init])) {
        QuizLayer *lay = [[QuizLayer alloc] init];
        lay->gameState=gs;
        //[self addChild:[CCColorLayer layerWithColor:ccc4(124,106,128,255)]];
        [self addChild:lay z:2 tag:0];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

@implementation QuizLayer
#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init
{
	if( (self=[super initWithColor:ccc4(155,155,155,100)] )) {
		// Enable touch events
        popTimer=-1;
        [gameState setState:1];
		self.isTouchEnabled = YES;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        timer=30;
        bg2 = [CCSprite spriteWithFile:@"quizBG.png"];
        bg2.position=ccp(240,280);
        bg2.scale=.5;
		[self addChild:bg2];
		bg = [CCSprite spriteWithFile:@"quizBG.png"];
        bg.position=ccp(240,180);
		[self addChild:bg];
        
        s1 = [CCSprite spriteWithFile:@"0.png"];
		[self addChild:s1];
        s2 = [CCSprite spriteWithFile:@"0.png"];
		[self addChild:s2];
        s3 = [CCSprite spriteWithFile:@"0.png"];
		[self addChild:s3];
        s4 = [CCSprite spriteWithFile:@"0.png"];
		[self addChild:s4];
        s5 = [CCSprite spriteWithFile:@"0.png"];
		[self addChild:s5];
        p0 = [CCSprite spriteWithFile:@"0.png"];
        p0.visible=0;
        [self addChild:p0];
        p1 = [CCSprite spriteWithFile:@"1.png"];
		[self addChild:p1];
        p2 = [CCSprite spriteWithFile:@"2.png"];
		[self addChild:p2];
        p3 = [CCSprite spriteWithFile:@"3.png"];
		[self addChild:p3];
        p4 = [CCSprite spriteWithFile:@"4.png"];
		[self addChild:p4];
        p5 = [CCSprite spriteWithFile:@"5.png"];
		[self addChild:p5];
        p6 = [CCSprite spriteWithFile:@"6.png"];
		[self addChild:p6];
        p7 = [CCSprite spriteWithFile:@"7.png"];
		[self addChild:p7];
        p8 = [CCSprite spriteWithFile:@"8.png"];
		[self addChild:p8];
        p9 = [CCSprite spriteWithFile:@"9.png"];
		[self addChild:p9];
        [self setNumPositions];
		oneLevel = [CCSprite spriteWithFile:@"ok.png"];
        oneLevel.scale=.2;
		[self addChild:oneLevel];
        oneLevel.position = ccp(440, 260);
        mathType=1+arc4random() %4;
        if(mathType==1){
            num1=1+arc4random() %500;
            num2=1+arc4random() %500;
            num1l=[[CCLabelTTF alloc] initWithString:@"+"
                                            fontName:@"Arial" 
                                            fontSize:40];
        }else if(mathType ==2){
            num1=1+arc4random() %500;
            num2=1+arc4random() %(num1-1);
            num1l=[[CCLabelTTF alloc] initWithString:@"-"
                                            fontName:@"Arial" 
                                            fontSize:40];
        }else if(mathType==3){
            num1=2+arc4random() %12;
            num2=2+arc4random() %12;
            num1l=[[CCLabelTTF alloc] initWithString:@"x" 
                                            fontName:@"Arial" 
                                            fontSize:40];
        }else if(mathType==4){
            num2=2+arc4random() %12;
            num1=num2*(2+arc4random() %12);
            num1l=[[CCLabelTTF alloc] initWithString:@"÷"
                                            fontName:@"Arial" 
                                            fontSize:40];
        }
        [num1l setColor:ccBLACK];
        [self addChild:num1l];
        num1l.position=ccp(120,180);
        int temp=num1;
        n4 = [self getTagForInt:temp%10];
		[self addChild:n4];
        temp=temp/10;
        if(temp>=1){
        n3 = [self getTagForInt:temp%10];
		[self addChild:n3];
        temp=temp/10;
        }
        if(temp>=1){
        n2 = [self getTagForInt:temp%10];
		[self addChild:n2];
        temp=temp/10;
        }if(temp>=1){
        n1 = [self getTagForInt:temp%10];
		[self addChild:n1];
        }
        temp=num2;
        nn4 = [self getTagForInt:temp%10];
		[self addChild:nn4];
        temp=temp/10;
        if(temp>=1){
        nn3 = [self getTagForInt:temp%10];
		[self addChild:nn3];
        temp=temp/10;
        }if(temp>=1){
        nn2 = [self getTagForInt:temp%10];
		[self addChild:nn2];
        temp=temp/10;
        }if(temp>=1){
        nn1 = [self getTagForInt:temp%10];
		[self addChild:nn1];
        }
        int y1=240;
        int y2=180;
        n1.position=ccp(190,y1);
        n2.position=ccp(250,y1);
        n3.position=ccp(310,y1);
        n4.position=ccp(370,y1);
        nn1.position=ccp(190,y2);
        nn2.position=ccp(250,y2);
        nn3.position=ccp(310,y2);
        nn4.position=ccp(370,y2);
        
        timeLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",timer]
                                          fontName:@"Arial"
                                          fontSize:30];
        timeLab.position = ccp(winSize.width/2, winSize.height -15);
        [timeLab setColor:ccBLACK];
        [self addChild:timeLab];
        
        [self schedule:@selector(calc:) interval:1.0f];
	}	
	return self;
}

-(CCSprite*) getTagForInt:(int) i{
    NSLog(@"%i.png",i);
    return [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i.png",i]];
}

- (void)setNumPositions{
    p1.position=ccp(20,50);
    p2.position=ccp(75,50);
    p3.position=ccp(130,50);
    p4.position=ccp(185,50);
    p5.position=ccp(240,50);
    p6.position=ccp(295,50);
    p7.position=ccp(350,50);
    p8.position=ccp(405,50);
    p9.position=ccp(460,50);
    int y1=110;
    s1.position=ccp(130,y1);
    s2.position=ccp(190,y1);
    s3.position=ccp(250,y1);
    s4.position=ccp(310,y1);
    s5.position=ccp(370,y1);
}

- (void)calc:(ccTime) dt {
    timer--;
    
    timeLab.string=[NSString stringWithFormat:@"%i",timer];
    if(timer==0){
        [[CCDirector sharedDirector] popScene];
        [self.parent removeChild:self cleanup:TRUE];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (CGRectContainsPoint(p1.boundingBox,location)) {
        selected=p1;
        selectNum=1;
    }else if (CGRectContainsPoint(p2.boundingBox,location)) {
        selected=p2;
        selectNum=2;
    }else if (CGRectContainsPoint(p3.boundingBox,location)) {
        selected=p3;
        selectNum=3;
    }else if (CGRectContainsPoint(p4.boundingBox,location)) {
        selected=p4;
        selectNum=4;
    }else if (CGRectContainsPoint(p5.boundingBox,location)) {
        selected=p5;
        selectNum=5;
    }else if (CGRectContainsPoint(p6.boundingBox,location)) {
        selected=p6;
        selectNum=6;
    }else if (CGRectContainsPoint(p7.boundingBox,location)) {
        selected=p7;
        selectNum=7;
    }else if (CGRectContainsPoint(p8.boundingBox,location)) {
        selected=p8;
        selectNum=8;
    }else if (CGRectContainsPoint(p9.boundingBox,location)) {
        selected=p9;
        selectNum=9;
    }else if (CGRectContainsPoint(s1.boundingBox,location)) {
        selected=s1;
    }else if (CGRectContainsPoint(s2.boundingBox,location)) {
        selected=s2;
    }else if (CGRectContainsPoint(s3.boundingBox,location)) {
        selected=s3;
    }else if (CGRectContainsPoint(s4.boundingBox,location)) {
        selected=s4;
    }else if (CGRectContainsPoint(s5.boundingBox,location)) {
        selected=s5;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(selected != NULL){
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        selected.position = [[CCDirector sharedDirector] convertToGL:location];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([gameState state]==1){
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        if(selected != NULL){
            if(selected==s1){
                ss1=0;
                s1.texture=p0.texture;
            }else if(selected==s2){
                ss2=0;
                s2.texture=p0.texture;
            }else if(selected==s3){
                ss3=0;
                s3.texture=p0.texture;
            }else if(selected==s4){
                ss4=0;
                s4.texture=p0.texture;
            }else if(selected==s5){
                ss5=0;
                s5.texture=p0.texture;
            }
            if (CGRectContainsPoint(s1.boundingBox,location)) {
                s1.texture=selected.texture;
                ss1=selectNum;
            }else if (CGRectContainsPoint(s2.boundingBox,location)) {
                s2.texture=selected.texture;
                ss2=selectNum;
            }else if (CGRectContainsPoint(s3.boundingBox,location)) {
                ss3=selectNum;
                s3.texture=selected.texture;
            }else if (CGRectContainsPoint(s4.boundingBox,location)) {
                ss4=selectNum;
                s4.texture=selected.texture;
            }else if (CGRectContainsPoint(s5.boundingBox,location)) {
                ss5=selectNum;
                s5.texture=selected.texture;
            }
            [self setNumPositions];
        }
        if (CGRectContainsPoint(oneLevel.boundingBox,location)) {
            int result=ss5+ss4*10+ss3*100+ss2*1000+ss1*10000;
            if(mathType==1){
                if(result == num1+num2){
                    [gameState setBoost:timer/2+2];
                }
            }
            else if(mathType==2){
                if(result == num1-num2){
                    [gameState setBoost:timer/2+2];
                }
            }else if(mathType==3){
                if(result == num1*num2){
                    [gameState setBoost:timer/2+2];
                }
            }else if(mathType==4){
                if(result == num1/num2){
                    [gameState setBoost:timer/2+2];
                }
            }
            //[self.parent runAction:[CCSequence actions:[CCMoveTo actionWithDuration:2 position:ccp(-,0)],
            //                 [CCCallFuncN actionWithTarget:self selector:@selector(popMe)],
            //                 nil]];
            [self popMe];
            //[self.parent removeChild:self cleanup:TRUE];
        }
    }
}
-(void) popMe{
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFlipAngular class] duration:2];
}

@end
