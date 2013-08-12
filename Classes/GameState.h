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
@property int forceMathType, addDiff,subDiff,multDiff,divDiff;
@property int state, comboTimer,comboVal;
@property int boost,score,charge;
@property int rocketTime,quizTime,zerograv,spinPower;
@property int topSpeed, coins, currLevel;
@property float scale,speed,vx,vy,dx,dy,ax,ay,rot,vrot;
@property (nonatomic,retain) NSString * startString;
@property (nonatomic,retain) AchievementEngine * achEng;
@property (nonatomic,retain) NSMutableArray *shields, *powerups, *achieves, *levels, *levelScores, *displayAchieves, *completeAchieves, *globalParams;

-(void)calcAchieves;

@end
