//
//  GlobalParam.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/27/13.
//
//

#import "CCSprite.h"

@interface GlobalParam : CCSprite{
    int power;
    float value;
    NSString *imgName;
    NSString *name;
}

@property int power;
@property float value;
@property (assign) NSString *imgName;
@property (assign) NSString *name;

-(id) initSelf;

@end
