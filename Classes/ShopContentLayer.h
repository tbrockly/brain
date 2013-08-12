//
//  CoinShopContentLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 6/4/13.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "GameState.h"
#import "Powerup.h"



@interface ShopRow : NSObject{
    NSString *iconName;
    NSString *text;
    NSString *name;
    int price, level, type, pages;
}

@property(nonatomic, retain) NSString *iconName;
@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) NSString *name;
@property int price, level, type;

@end

@interface ShopContentLayer : CCLayer{
    NSMutableArray *bars, *buttons, *descriptions,*icons;
    int pages, shopType;
    GameState* gamestate;
    CCLabelTTF* desc;
    CCSprite* buy;
    ShopRow* selectedRow;
}
-(id) init:(GameState*)myGameState;;
@property int pages,shopType;

@end