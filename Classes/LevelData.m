//
//  LevelData.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/7/13.
//
//

#import "LevelData.h"

@implementation LevelData

-(id)initWithName:(NSString*)myname bronze:(int)mybronze silver:(int)mysilver gold:(int)mygold{
    if(self= [super init]){
        [self setName:myname];
        [self setBronze:mybronze];
        [self setSilver:mysilver];
        [self setGold:mygold];
    }
    return self;
}




@end
