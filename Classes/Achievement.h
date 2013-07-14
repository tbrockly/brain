//
//  Achievement.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 10/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Achievement : NSObject{
    NSString* title,*var1,*var2;
    int xp,val1,val2;
    int icon;
}

@property (copy) NSString *title,*var1,*var2;
@property int val1,val2;
@property int xp;
@property int icon;



-(id)initWithTitle:(NSString*)titleIn xp:(int)xpIn icon:(int)iconIn var1:(NSString*)var1in val1:(int)val1in ;

@end
