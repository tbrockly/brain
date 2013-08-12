//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LaunchLayer.h"

@implementation LaunchLayer
#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init:(GameState*) gs
{
	if( (self=[super initWithColor:ccc4(0,0,0,150)] )) {
		// Enable touch events
        popTimer=-1;
        gameState=gs;
        [gameState setState:1];
		self.isTouchEnabled = YES;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        timer=30;
        
		
        if([gameState forceMathType]==5){
            mathType=1+arc4random() %2;
        }else if([gameState forceMathType]>0){
            mathType=0;
        }else{
            mathType=1+arc4random() %4;
        }
        if(mathType==1 || [gameState forceMathType]==1){
            num1=2+arc4random() %[gameState addDiff];
            num2=2+arc4random() %[gameState addDiff];
            num1l=[[CCLabelTTF alloc] initWithString:@"+"
                                            fontName:@"Arial"
                                            fontSize:40];
            answer=num1+num2;
        }else if(mathType ==2 || [gameState forceMathType]==2){
            num1=5+arc4random() %[gameState subDiff];
            num2=1+arc4random() %(num1-1);
            num1l=[[CCLabelTTF alloc] initWithString:@"-"
                                            fontName:@"Arial"
                                            fontSize:40];
            answer=num1-num2;
        }else if(mathType==3 || [gameState forceMathType]==3){
            num1=2+arc4random() %[gameState multDiff];
            num2=2+arc4random() %[gameState multDiff];
            num1l=[[CCLabelTTF alloc] initWithString:@"x"
                                            fontName:@"Arial"
                                            fontSize:40];
            answer=num1*num2;
        }else if(mathType==4 || [gameState forceMathType]==4){
            num2=2+arc4random() %[gameState divDiff];
            num1=num2*(2+arc4random() %[gameState divDiff]);
            num1l=[[CCLabelTTF alloc] initWithString:@"÷"
                                            fontName:@"Arial"
                                            fontSize:40];
            answer=num1/num2;
        }
        correctNum=arc4random() %4;
        for(int i=0;i<4;i++){
            if(i==correctNum){
                answers[i]=answer;
            }else{
                if(arc4random() %2){
                    answers[i]=answer+(1+(arc4random()%(answer/2)));
                }else{
                    answers[i]=answer-(1+(arc4random()%(answer/2)));
                }
            }
        }
        
        btn1=[[CCSprite alloc] initWithFile:@"MultipleButton.png"];
        btn2=[[CCSprite alloc] initWithFile:@"MultipleButton.png"];
        btn3=[[CCSprite alloc] initWithFile:@"MultipleButton.png"];
        btn4=[[CCSprite alloc] initWithFile:@"MultipleButton.png"];
        lol1=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", answers[0]] fontName:@"Verdana" fontSize:20];
        lol2=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", answers[1]] fontName:@"Verdana" fontSize:20];
        lol3=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", answers[2]] fontName:@"Verdana" fontSize:20];
        lol4=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", answers[3]] fontName:@"Verdana" fontSize:20];
        btn1.position=ccp(160,120);
        lol1.position=ccp(160,120);
        btn2.position=ccp(320,120);
        lol2.position=ccp(320,120);
        btn3.position=ccp(160,55);
        lol3.position=ccp(160,55);
        btn4.position=ccp(320,55);
        lol4.position=ccp(320,55);
        [self addChild:btn1];
        [self addChild:lol1];
        [self addChild:btn2];
        [self addChild:lol2];
        [self addChild:btn3];
        [self addChild:lol3];
        [self addChild:btn4];
        [self addChild:lol4];
        
       
        
        
        //[num1l setColor:ccBLACK];
        [self addChild:num1l];
        num1l.position=ccp(130,180);
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
        timeLab.position = ccp(winSize.width/2, winSize.height -30);
        //[timeLab setColor:ccBLACK];
        [self addChild:timeLab];
        correct =[[CCSprite alloc] initWithFile:@"ok.png"];
        correct.position=ccp(240,450);
        [self addChild:correct];
        wrong =[[CCSprite alloc] initWithFile:@"brain_grrr.png"];
        wrong.position=ccp(240,450);
        [self addChild:wrong];
        
        [self schedule:@selector(calc:) interval:1.0f];
	}
	return self;
}

-(CCSprite*) getTagForInt:(int) i{
    NSLog(@"%i.png",i);
    return [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i.png",i]];
}

- (void)calc:(ccTime) dt {
    timer--;
    
    timeLab.string=[NSString stringWithFormat:@"%i",timer];
    if(timer==0){
        [self popWrong];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(selected != NULL){
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        selected.position = [[CCDirector sharedDirector] convertToGL:location];
    }
}
- (void)addBrains:(int)i{
    [self.parent addBrains:i];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([gameState state]==1){
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if (CGRectContainsPoint(btn1.boundingBox,location)) {
            if(correctNum == 0){
                [self popCorrect];
            }else{
                [self popWrong];
            }
        }
        if (CGRectContainsPoint(btn2.boundingBox,location)) {
            if(correctNum == 1){
                [self popCorrect];
            }else{
                [self popWrong];
            }
        }
        if (CGRectContainsPoint(btn3.boundingBox,location)) {
            if(correctNum == 2){
                [self popCorrect];
            }else{
                [self popWrong];
            }
        }
        if (CGRectContainsPoint(btn4.boundingBox,location)) {
            if(correctNum == 3){
                [self popCorrect];
            }else{
                [self popWrong];
            }
            
        }
        
    }
}
-(void) popWrong{
    [wrong runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:.5 position:ccp(240,160)],
                     [CCDelayTime actionWithDuration:1],
                     [CCCallFuncN actionWithTarget:self selector:@selector(popMe)],
                     
                     nil]];
    
}
-(void) popCorrect{
    [gameState setBoost:timer/4+2];
    [self addBrains:timer];
    [correct runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:.5 position:ccp(240,160)],
                     [CCDelayTime actionWithDuration:1],
                     [CCCallFuncN actionWithTarget:self selector:@selector(popMe)],
                     nil]];
}

-(void) popMe{
    [gameState setState:0];
    [self.parent removeChild:self cleanup:TRUE];
}

@end
