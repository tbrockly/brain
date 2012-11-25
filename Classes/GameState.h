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
    int state;
    int boost;
    int score,charge;
    int rocketTime,boostTime,bounceTime,bonusTime,quizTime,zerograv;
    int spinShield, topSpeed,coins;
    float scale;
    AchievementEngine * achEng;
    NSMutableArray *powerups, *achieves, *displayAchieves, *completeAchieves;
}
@property int state;
@property int boost,score,charge;
@property int rocketTime,boostTime,bounceTime,bonusTime,quizTime,zerograv;
@property int spinShield, topSpeed, coins;
@property float scale;
@property (retain) AchievementEngine * achEng;
@property (retain) NSMutableArray *powerups, *achieves,*displayAchieves, *completeAchieves;

-(void)calcAchieves;

@end
