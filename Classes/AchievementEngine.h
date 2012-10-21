//
//  Achievements.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AchievementEngine : NSObject{
    int distance,height,totdistance,totheight;
    int powerups,totpowerups;
    int coins,totcoins;
    int math,totmath;
    int energy,totenergy;
    int spin,totspin;
    int boost,totboost;
    int rocket,totrocket;
    int ride,totride;
    int bonus,totbonus;
    int bonusval,totbonusval;
    int quiz,totquiz;
    int speed;
    int score,totscore;
}

@property int distance,height,totdistance,totheight;
@property int powerups,totpowerups;
@property int coins,totcoins;
@property int math,totmath;
@property int energy,totenergy;
@property int spin,totspin;
@property int boost,totboost;
@property int rocket,totrocket;
@property int ride,totride;
@property int bonus,totbonus;
@property int bonusval,totbonusval;
@property int quiz,totquiz;
@property int speed;
@property int score,totscore;

-(id) init:(NSUserDefaults*) defaults;
-(void)calcAchievements;
@end
