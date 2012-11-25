//
//  LevelSelectScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopRow.h"
#import "CCScrollLayer.h"

@implementation ShopRow
@synthesize oneLevel;
@synthesize booster;
@synthesize gameState,parentLayer;
@synthesize energy, coin, boost, rocket, ride, spin;

#define degreesToRadians(x) (M_PI * x /180.0)
-(id) init
{
	if( (self=[super initWithColor:ccc4(55,55,155,100) width:300 height:120] )) {
		// Enable touch events
		self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		oneLevel = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(20, 20, 40, 40)];
		[self addChild:oneLevel];
        oneLevel.position = ccp(winSize.width/2, winSize.height/2);
        
        energy=[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"E-FREQ %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"energyFreq"]]
                                         fontName:@"Futura"
                                         fontSize:30];
        energy.position=ccp(50,50);
        [energy setColor:ccWHITE];
        [self addChild:energy];
        
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
    //if([gameState state]==2){
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (CGRectContainsPoint(oneLevel.boundingBox,location)) {
        //[gameState setState:-[gameState state]];
        [answer endEditing:YES];
        [answer removeFromSuperview];
        parentLayer.isTouchEnabled=YES;
        [self.parent removeChild:self cleanup:TRUE];
        [[CCDirector sharedDirector] resume];
    }
    if (CGRectContainsPoint(energy.boundingBox,location)) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setInteger:[def integerForKey:@"energyFreq"]+1 forKey:@"energyFreq"];
        energy.string=[NSString stringWithFormat:@"E-FREQ %i",[def integerForKey:@"energyFreq"]];
        
    }
    //}
}


@end
