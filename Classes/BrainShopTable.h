//
//  BrainShopTable.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import <UIKit/UIKit.h>
#import "GameState.h"
#import "cocos2d.h"

@interface BrainShopTable : UITableView <UITableViewDelegate, UITableViewDataSource>{
    GameState *gameState;
    CCLayer *parent;
}

- (id)initWithFrame:(CGRect)frame gameState:(GameState*)gs;
@end
