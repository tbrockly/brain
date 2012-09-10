//
//  LoadoutScene.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadoutScene.h"
#import "GameScene.h"

@implementation LoadoutScene
@synthesize layer = _layer;

- (id)init {
    
	if ((self = [super init])) {
		self.layer = [LoadoutLayer node];
		[self addChild:_layer];
	}
	return self;
}

- (void)dealloc {
	[_layer release];
	_layer = nil;
	[super dealloc];
}

@end

@implementation LoadoutLayer
@synthesize readyButton;
CCSprite *airResistBtn, *enemyFreqBtn, *quizFreqBtn, *boostBtn;
CCSprite *gravityBtn, *frictonBtn, *enemyBoostBtn,*quizBoostBtn, *topSpeedBtn;
NSUserDefaults *defaults;
-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        defaults=[NSUserDefaults standardUserDefaults];
        //if([defaults integerForKey:@"airResist"]<1){
            [defaults setInteger:1 forKey:@"airResist"];
            [defaults setInteger:1 forKey:@"enemyFreq"];
            [defaults setInteger:1 forKey:@"quizFreq"];
            [defaults setInteger:1 forKey:@"enemyBoost"];
            [defaults setInteger:1 forKey:@"quizBoost"];
            [defaults setFloat:1 forKey:@"gravity"];
            [defaults setInteger:1 forKey:@"friction"];
            [defaults setInteger:1 forKey:@"quizDifficulty"];
            [defaults setInteger:1 forKey:@"topSpeed"];
        //}
        
		// Enable touch events
		self.isTouchEnabled = YES;
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		readyButton = [CCSprite spriteWithFile:@"FoodItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		readyButton.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:readyButton];
        CCLabelTTF *ready= [[CCLabelTTF alloc] initWithString:@"go" fontName:@"Arial" fontSize:16];
		ready.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:ready];
        airResistBtn = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		airResistBtn.position = ccp(50, 50);
		[self addChild:airResistBtn];
        CCLabelTTF *resist= [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[defaults integerForKey:@"airResist"]] fontName:@"Arial" fontSize:16];
		resist.position = ccp(50, 50);
		[self addChild:resist];
        enemyFreqBtn = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		enemyFreqBtn.position = ccp(50, winSize.height-50);
		[self addChild:enemyFreqBtn];
        CCLabelTTF *enemy= [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[defaults integerForKey:@"enemyFreq"]] fontName:@"Arial" fontSize:16];
		enemy.position = ccp(50, winSize.height-50);
		[self addChild:enemy];
        quizFreqBtn = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		quizFreqBtn.position = ccp(winSize.width-50, 50);
		[self addChild:quizFreqBtn];
        CCLabelTTF *quiz= [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[defaults integerForKey:@"quizFreq"]] fontName:@"Arial" fontSize:16];
		quiz.position = ccp(50, winSize.height-50);
		[self addChild:quiz];
        gravityBtn = [CCSprite spriteWithFile:@"HeadItemside.png" rect:CGRectMake(0, 0, 100, 100)];
		gravityBtn.position = ccp(winSize.width-50, winSize.height-50);
		[self addChild:gravityBtn];
        CCLabelTTF *grav= [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i",[defaults integerForKey:@"boost"]] fontName:@"Arial" fontSize:16];
		grav.position = ccp(winSize.width-50, winSize.height-50);
		[self addChild:grav];
	}	
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    if (CGRectContainsPoint(readyButton.boundingBox,location)) {
        [[CCDirector sharedDirector] replaceScene:[GameScene initNode]];
    }else if (CGRectContainsPoint(airResistBtn.boundingBox,location)) {
        [defaults setInteger:[defaults integerForKey:@"airResist"]+1 forKey:@"airResist"];
    }else if (CGRectContainsPoint(enemyFreqBtn.boundingBox,location)) {
        [defaults setInteger:[defaults integerForKey:@"enemyFreq"]+1 forKey:@"enemyFreq"];
    }else if (CGRectContainsPoint(quizFreqBtn.boundingBox,location)) {
        [defaults setInteger:[defaults integerForKey:@"quizFreq"]+1 forKey:@"quizFreq"];
    }
}
@end