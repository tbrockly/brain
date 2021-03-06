//
//  XPShop.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "XPShopTable.h"

@interface XPShop : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel;
    CCSprite *shopBG,*but1,*but2,*but3;
    GameState *gameState;
    CCColorLayer *parentLayer;
    XPShopTable *myTable;
    int booster;
    CCLabelTTF *coinLab, *xpLab,*brainLab;
}

@property (nonatomic, retain) CCColorLayer *parentLayer;

-(id)init:(GameState*)gs;

@end