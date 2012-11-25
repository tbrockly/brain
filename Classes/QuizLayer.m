//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "QuizLayer.h"

@implementation QuizLayer
@synthesize oneLevel;
@synthesize booster;
@synthesize gameState;
int num1, num2, mathType,timer;
CCLabelTTF *num1l, *timeLab;
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
		
        p1 = [CCSprite spriteWithFile:@"1.png"];
        p1.position=ccp(20,20);
		[self addChild:p1];
        p2 = [CCSprite spriteWithFile:@"2.png"];
        p2.position=ccp(70,20);
		[self addChild:p2];
        p3 = [CCSprite spriteWithFile:@"3.png"];
        p3.position=ccp(120,20);
		[self addChild:p3];
        p4 = [CCSprite spriteWithFile:@"4.png"];
        p4.position=ccp(170,20);
		[self addChild:p4];
        p5 = [CCSprite spriteWithFile:@"5.png"];
        p5.position=ccp(220,20);
		[self addChild:p5];
        p6 = [CCSprite spriteWithFile:@"6.png"];
        p6.position=ccp(270,20);
		[self addChild:p6];
        p7 = [CCSprite spriteWithFile:@"7.png"];
        p7.position=ccp(320,20);
		[self addChild:p7];
        p8 = [CCSprite spriteWithFile:@"8.png"];
        p8.position=ccp(370,20);
		[self addChild:p8];
        p9 = [CCSprite spriteWithFile:@"9.png"];
        p9.position=ccp(420,20);
		[self addChild:p9];
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
        [answer setDelegate:self];
        [answer setText:@""];
        [answer setTextColor:[UIColor whiteColor]];
        [answer setKeyboardType:UIKeyboardTypeDecimalPad];
        [answer setFont:[UIFont fontWithName:@"Arial" size:30]];
        answer.transform = CGAffineTransformConcat(answer.transform, CGAffineTransformMakeRotation(degreesToRadians(90)));
        //[[[[CCDirector sharedDirector] openGLView] window] addSubview:answer];
        //[answer becomeFirstResponder];
        [self schedule:@selector(calc:) interval:1.0f];
	}	
	return self;
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

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([gameState state]==1){
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        CGRect rect=oneLevel.boundingBox;
        if (CGRectContainsPoint(rect,location)) {
            NSString *result=answer.text;
            if(mathType==1){
                if(result.integerValue == num1+num2){
                    [gameState setBoost:timer/2+2];
                }
            }
            else if(mathType==2){
                if(result.integerValue == num1-num2){
                    [gameState setBoost:timer/2+2];
                }
            }
            else if(mathType==3){
                if(result.integerValue == num1*num2){
                    [gameState setBoost:timer/2+2];
                }
            }
            else if(mathType==4){
                if(result.integerValue == num2/num1){
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
