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
#import "ShopContentLayer.h"

@interface CoinShop : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel;
    CCSprite *shopBG;
    CCSprite *left, *right;
    GameState *gameState;
    CCColorLayer *parentLayer;
    int booster;
    CCLabelTTF *coinLab, *xpLab,*brainLab;
    ShopContentLayer *shop;
    int currpage;
}

@property (nonatomic, retain) CCColorLayer *parentLayer;

-(id)init:(GameState*)gs;

@end
