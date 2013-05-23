//
//  CoinShopTable.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import <UIKit/UIKit.h>
#import "GameState.h"
#import "cocos2d.h"

@interface CoinShopTable : UITableView <UITableViewDelegate, UITableViewDataSource>{
    GameState *gameState;
    CCLayer *parent;
    NSMutableArray *myArray;
}

- (id)initWithFrame:(CGRect)frame gameState:(GameState*)gs rowArray:myArray;
@end

@interface CoinShopRow : NSObject{
    NSString *iconName;
    NSString *text;
    NSString *name;
    int price, level, type;
}

@property(nonatomic, retain) NSString *iconName;
@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) NSString *name;
@property int price, level, type;

@end