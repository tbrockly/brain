//
//  GameState.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AchievementEngine.h"

@interface GameState: NSObject{

}
@property int state, comboTimer,comboVal;
@property int boost,score,charge;
@property int rocketTime,quizTime,zerograv;
@property int topSpeed, coins;
@property float scale,speed;
@property (retain) AchievementEngine * achEng;
@property (retain) NSMutableArray *shields, *powerups, *achieves,*displayAchieves, *completeAchieves;

-(void)calcAchieves;

@end
