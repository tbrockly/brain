//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "QuizLayer.h"

@implementation QuizLayer
#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init
{
	if( (self=[super initWithColor:ccc4(155,155,155,100)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        timer=30;
        timeLab=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",timer]
                                           fontName:@"Arial" 
                                           fontSize:40];
        timeLab.position = ccp(winSize.width/2, winSize.height -30);
        [self addChild:timeLab];
		bg = [CCSprite spriteWithFile:@"quizBG.png"];
        bg.position=ccp(240,200);
		[self addChild:bg];
        s1 = [CCSprite spriteWithFile:@"b.png"];
        s1.position=ccp(130,130);
		[self addChild:s1];
        s2 = [CCSprite spriteWithFile:@"b.png"];
        s2.position=ccp(190,130);
		[self addChild:s2];
        s3 = [CCSprite spriteWithFile:@"b.png"];
        s3.position=ccp(250,130);
		[self addChild:s3];
        s4 = [CCSprite spriteWithFile:@"b.png"];
        s4.position=ccp(310,130);
		[self addChild:s4];
        s5 = [CCSprite spriteWithFile:@"b.png"];
        s5.position=ccp(370,130);
		[self addChild:s5];
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
		oneLevel = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		[self addChild:oneLevel];
        oneLevel.position = ccp(430, 270);
        mathType=1+arc4random() %4;
        if(mathType==1){
            num1=1+arc4random() %500;
            num2=1+arc4random() %500;
            num1l=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i + %i =",num1,num2] 
                                            fontName:@"Arial" 
                                            fontSize:30];
        }else if(mathType ==2){
            num1=1+arc4random() %500;
            num2=1+arc4random() %(num1-1);
            num1l=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i - %i =",num1,num2] 
                                            fontName:@"Arial" 
                                            fontSize:30];
        }else if(mathType==3){
            num1=2+arc4random() %12;
            num2=2+arc4random() %12;
            num1l=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i * %i =",num1,num2] 
                                            fontName:@"Arial" 
                                            fontSize:30];
        }else if(mathType==4){
            num1=2+arc4random() %12;
            num2=num1*(2+arc4random() %12);
            num1l=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i / %i =",num2,num1] 
                                            fontName:@"Arial" 
                                            fontSize:30];
        }
        
        [self addChild:num1l];
        num1l.position=ccp(100,200);
        
        answer=[[UITextField alloc] initWithFrame:CGRectMake(150, 200, 100, 30)];
        [answer setText:@""];
        [answer setTextColor:[UIColor whiteColor]];
        [answer setKeyboardType:UIKeyboardTypeDecimalPad];
        [answer setFont:[UIFont fontWithName:@"Arial" size:30]];
        answer.transform = CGAffineTransformConcat(answer.transform, CGAffineTransformMakeRotation(degreesToRadians(90)));
        //[[[[CCDirector sharedDirector] openGLView] window] addSubview:answer];
        [answer becomeFirstResponder];
        [self schedule:@selector(calc:) interval:1.0f];
	}	
	return self;
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
}

- (void)calc:(ccTime) dt {
    timer--;
    timeLab.string=[NSString stringWithFormat:@"%i",timer];
    if(timer==0){
        [gameState setState:0];
        [answer endEditing:YES];
        [answer removeFromSuperview];
        [self.parent removeChild:self cleanup:TRUE];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [answer resignFirstResponder];
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
        else if (CGRectContainsPoint(oneLevel.boundingBox,location)) {
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
            }
            else if(mathType==3){
                if(result == num1*num2){
                    [gameState setBoost:timer/2+2];
                }
            }
            else if(mathType==4){
                if(result == num2/num1){
                    [gameState setBoost:timer/2+2];
                }
            }
            [gameState setState:0];
            [answer endEditing:YES];
            [answer removeFromSuperview];
            [self.parent removeChild:self cleanup:TRUE];
        }
    }
}

@end
