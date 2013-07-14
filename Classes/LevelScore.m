//
//  LevelScore.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/9/13.
//
//

#import "LevelScore.h"

@implementation LevelScore
@synthesize score;
-(id)initWithScore:(int)scoreIn {
    if(self= [super init]){
        score = scoreIn;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder{
    [encoder encodeInt:score forKey:@"score"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    if(self= [super init]){
        score = [decoder decodeIntForKey:@"score"];
    }
    return self;
}

@end
