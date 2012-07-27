//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "QuizScene.h"

@implementation QuizLayer
@synthesize oneLevel;
@synthesize booster;
@synthesize gameState;
CCParticleExplosion* parc;
int num1, num2;
CCLabelTTF *num1l;
#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init
{
	if( (self=[super initWithColor:ccc4(155,155,155,255)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		//CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		[self addChild:oneLevel];
        oneLevel.position = ccp(430, 270);
        num1=1+arc4random() %900;
        num2=1+arc4random() %900;
        num1l=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i + %i =",num1,num2] 
                                                 fontName:@"Arial" 
                                                 fontSize:30];
        [self addChild:num1l];
        num1l.position=ccp(100,200);
        
        answer=[[UITextField alloc] initWithFrame:CGRectMake(150, 250, 100, 30)];
        [answer setDelegate:self];
        [answer setText:@""];
        [answer setTextColor:[UIColor whiteColor]];
        [answer setKeyboardType:UIKeyboardTypeDecimalPad];
        [answer setFont:[UIFont fontWithName:@"Arial" size:30]];
        answer.transform = CGAffineTransformConcat(answer.transform, CGAffineTransformMakeRotation(degreesToRadians(90)));
        [[[CCDirector sharedDirector] openGLView] addSubview:answer];
        [answer becomeFirstResponder];
	}	
	return self;
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
            if(result.integerValue == num1+num2){
                [gameState setBoost:60];
            }
            [gameState setState:0];
            [answer endEditing:YES];
            [answer removeFromSuperview];
            [self.parent removeChild:self cleanup:TRUE];
        }
    }
}

@end
