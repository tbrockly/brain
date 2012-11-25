//
//  MainTableView.h
//  Champion Lineup
//
//  Created by Ted on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"
#import "cocos2d.h"

@interface MainTableView : UITableView <UITableViewDelegate, UITableViewDataSource>{
    GameState *gameState;
    CCLayer *parent;
}
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) CCLayer *parent;

- (id)initWithFrame:(CGRect)frame gameState:(GameState*)gs;
@end
