//
//  GameState.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "Achievement.h"

@implementation GameState
@synthesize state;
@synthesize boost,score,charge;
@synthesize scale;
@synthesize rocketTime,boostTime,bounceTime,bonusTime,quizTime, zerograv, speed;
@synthesize spinShield;
@synthesize achEng, topSpeed, coins, achieves, displayAchieves, completeAchieves;
@synthesize powerups;

- (id)init
{
    self = [super init];
    if (self) {
        achieves=[[NSMutableArray alloc] init];
        completeAchieves=[[NSMutableArray alloc] init];
        displayAchieves=[[NSMutableArray alloc] init];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"score 25k" xp:9001 icon:1 var1:@"score" val1:25000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"score 50k" xp:9001 icon:1 var1:@"score" val1:50000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"score 100k" xp:9001 icon:1 var1:@"score" val1:100000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"dist 25k" xp:9001 icon:1 var1:@"dist" val1:25000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"dist 50k" xp:9001 icon:1 var1:@"dist" val1:50000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"dist 100k" xp:9001 icon:1 var1:@"dist" val1:100000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totdist 100k" xp:9001 icon:1 var1:@"totdist" val1:100000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totdist 500k" xp:9001 icon:1 var1:@"totdist" val1:500000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totdist 1M" xp:9001 icon:1 var1:@"totdist" val1:1000000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totcoins 100" xp:9001 icon:1 var1:@"totcoins" val1:100]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totcoins 500" xp:9001 icon:1 var1:@"totcoins" val1:500]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totcoins 1000" xp:9001 icon:1 var1:@"totcoins" val1:1000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totcoins 5000" xp:9001 icon:1 var1:@"totcoins" val1:5000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totheight 1000" xp:9001 icon:1 var1:@"totheight" val1:1000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totheight 5000" xp:9001 icon:1 var1:@"totheight" val1:5000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totheight 10000" xp:9001 icon:1 var1:@"totheight" val1:10000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totheight 50000" xp:9001 icon:1 var1:@"totheight" val1:50000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totspin 100" xp:9001 icon:1 var1:@"totspin" val1:100]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totspin 500" xp:9001 icon:1 var1:@"totspin" val1:500]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totspin 1000" xp:9001 icon:1 var1:@"totspin" val1:1000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totspin 5000" xp:9001 icon:1 var1:@"totspin" val1:5000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totboost 100" xp:9001 icon:1 var1:@"totboost" val1:100]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totboost 500" xp:9001 icon:1 var1:@"totboost" val1:500]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totboost 1000" xp:9001 icon:1 var1:@"totboost" val1:1000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totboost 5000" xp:9001 icon:1 var1:@"totboost" val1:5000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totrocket 100" xp:9001 icon:1 var1:@"totrocket" val1:100]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totrocket 500" xp:9001 icon:1 var1:@"totrocket" val1:500]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totrocket 1000" xp:9001 icon:1 var1:@"totrocket" val1:1000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totrocket 5000" xp:9001 icon:1 var1:@"totrocket" val1:5000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totride 100" xp:9001 icon:1 var1:@"totride" val1:100]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totride 500" xp:9001 icon:1 var1:@"totride" val1:500]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totride 1000" xp:9001 icon:1 var1:@"totride" val1:1000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totride 5000" xp:9001 icon:1 var1:@"totride" val1:5000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totbonus 100" xp:9001 icon:1 var1:@"totbonus" val1:100]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totbonus 500" xp:9001 icon:1 var1:@"totbonus" val1:500]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totbonus 1000" xp:9001 icon:1 var1:@"totbonus" val1:1000]];
        [achieves addObject:[[Achievement alloc] initWithTitle:@"totbonus 5000" xp:9001 icon:1 var1:@"totbonus" val1:5000]];
    }
    return self;
}

-(void)calcAchieves{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"score"];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for(Achievement *a in achieves){
            if([[NSUserDefaults standardUserDefaults] integerForKey:a.var1] > a.val1){
                [displayAchieves addObject:a];
                [temp addObject:a];
            }
        }
        for(Achievement *a in temp){
            [achieves removeObject:a];
        }
}

@end
