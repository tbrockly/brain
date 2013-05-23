//
//  CoinShop.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "CoinShopTable.h"

@interface CoinShop : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel;
    CCSprite *shopBG;
    GameState *gameState;
    CCColorLayer *parentLayer;
    CoinShopTable *myTable;
    int booster;
}

@property (nonatomic, retain) CCColorLayer *parentLayer;

-(id)init:(GameState*)gs;

@end
