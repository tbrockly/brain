//
//  Achievement.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Achievement.h"

@implementation Achievement
@synthesize title,xp,icon,var1,var2,val1,val2;


-(id)initWithTitle:(NSString*)titleIn xp:(int)xpIn icon:(int)iconIn var1:(NSString*)var1in val1:(int)val1in {
    if(self= [super init]){
        self.title = titleIn;
        self.xp = xpIn;
        self.icon = iconIn;
        self.var1 = var1in;
        self.val1 = val1in;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeInt:self.xp forKey:@"xp"];
    [encoder encodeInt:self.icon forKey:@"icon"];
    [encoder encodeObject:self.var1 forKey:@"var1"];
    [encoder encodeInt:self.val1 forKey:@"val1"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    if(self= [super init]){
        self.title = [decoder decodeObjectForKey:@"title"];
        self.xp = [decoder decodeIntForKey:@"xp"];
        self.icon = [decoder decodeIntForKey:@"icon"];
        self.var1 = [decoder decodeObjectForKey:@"var1"];
        self.val1 = [decoder decodeIntForKey:@"val1"];

    }
    return self;
}

@end
