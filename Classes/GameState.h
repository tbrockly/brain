//
//  GameState.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameState: NSObject{
    int state;
    int boost;
    int score,charge;
    float scale;
}
@property int state;
@property int boost,score,charge;
@property float scale;
@end
