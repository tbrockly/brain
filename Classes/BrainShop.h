//
//  BrainShop.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "BrainShopTable.h"

@interface BrainShop : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel;
    CCSprite *shopBG;
    GameState *gameState;
    CCColorLayer *parentLayer;
    BrainShopTable *myTable;
    int booster;
    CCLabelTTF *coinLab, *xpLab,*brainLab;
}

@property (nonatomic, retain) CCColorLayer *parentLayer;

-(id)init:(GameState*)gs;

@end
