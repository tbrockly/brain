//
//  Achievements.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AchievementEngine.h"

@implementation AchievementEngine

@synthesize distance,height,totdistance,totheight;
@synthesize powerups,totpowerups;
@synthesize coins,totcoins;
@synthesize math,totmath;
@synthesize energy,totenergy;
@synthesize spin,totspin;
@synthesize boost,totboost;
@synthesize rocket,totrocket;
@synthesize ride,totride;
@synthesize bonus,totbonus;
@synthesize bonusval,totbonusval;
@synthesize quiz,totquiz;
@synthesize speed;
@synthesize score,totscore;

-(id) init:(NSUserDefaults*) defaults{
    [self init];
    distance=0;
    height=0;
    totdistance=0;
    totheight=0;
    powerups=0;
    totpowerups=0;
    coins=0;
    totcoins=0;
    math=0;
    totmath=0;
    energy=0;
    totenergy=0;
    spin=0;
    totspin=0;
    boost=0;
    totboost=0;
    rocket=0;
    totrocket=0;
    ride=0;
    totride=0;
    bonus=0;
    totbonus=0;
    bonusval=0;
    totbonusval=0;
    speed=0;
    score=0;
    totscore=0;
    return self;
}

-(void)calcAchievements{
    
}

- (void)encodeWithCoder:(NSCoder*)encoder{
    [encoder encodeInt:self.totdistance forKey:@"totdistance"];
    [encoder encodeInt:self.totheight forKey:@"totheight"];
    [encoder encodeInt:self.powerups forKey:@"powerups"];
    [encoder encodeInt:self.totpowerups forKey:@"totpowerups"];
    [encoder encodeInt:self.totcoins forKey:@"totcoins"];
    [encoder encodeInt:self.totmath forKey:@"totmath"];
    [encoder encodeInt:self.totenergy forKey:@"totenergy"];
    [encoder encodeInt:self.totspin forKey:@"totspin"];
    [encoder encodeInt:self.totboost forKey:@"totboost"];
    [encoder encodeInt:self.totrocket forKey:@"totrocket"];
    [encoder encodeInt:self.totride forKey:@"totride"];
    [encoder encodeInt:self.totbonus forKey:@"totbonus"];
    [encoder encodeInt:self.totbonusval forKey:@"totbonusval"];
    [encoder encodeInt:self.speed forKey:@"speed"];
    [encoder encodeInt:self.totscore forKey:@"totscore"];
}
-(id)initWithCoder:(NSCoder *)decoder{
    if(self= [super init]){
        self.totdistance = [decoder decodeIntForKey:@"totdistance"];
        self.totheight = [decoder decodeIntForKey:@"totheight"];
        self.powerups = [decoder decodeIntForKey:@"powerups"];
        self.totpowerups = [decoder decodeIntForKey:@"totpowerups"];
        self.totcoins = [decoder decodeIntForKey:@"totcoins"];
        self.totmath = [decoder decodeIntForKey:@"totmath"];
        self.totenergy = [decoder decodeIntForKey:@"totenergy"];
        self.totspin = [decoder decodeIntForKey:@"totspin"];
        self.totboost = [decoder decodeIntForKey:@"totboost"];
        self.totrocket = [decoder decodeIntForKey:@"totrocket"];
        self.totride = [decoder decodeIntForKey:@"totride"];
        self.totbonus = [decoder decodeIntForKey:@"totbonus"];
        self.totbonusval = [decoder decodeIntForKey:@"totbonusval"];
        self.speed = [decoder decodeIntForKey:@"speed"];
        self.totscore = [decoder decodeIntForKey:@"totscore"];
    }
    return self;
}

@end
