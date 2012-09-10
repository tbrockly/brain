//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Shoplayer.h"

@implementation ShopLayer
@synthesize oneLevel;
@synthesize booster;
@synthesize gameState;
#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init
{
	if( (self=[super initWithColor:ccc4(155,155,155,100)] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		//CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		[self addChild:oneLevel];
        oneLevel.position = ccp(430, 270);
        
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
            [self.parent removeChild:self cleanup:TRUE];
        }
    }
}

@end
