//
//  ShopHome.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "MainTableView.h"

@interface ShopHome : CCColorLayer <UITextFieldDelegate>{
    CCSprite *oneLevel, *back;
    CCSprite *shopBG,*but1,*but2,*but3;
    GameState *gameState;
    CCColorLayer *parentLayer, *xpBar;
    MainTableView *myTable;
    int booster;
    CCLabelTTF *coinLab, *xpLab,*brainLab, *lvlLab;
}

@property (nonatomic, retain) CCColorLayer *parentLayer;

-(id)init:(GameState*)gs;

@end
