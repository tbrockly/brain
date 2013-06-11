//
//  CoinShopContentLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 6/4/13.
//
//

#import "ShopContentLayer.h"

@implementation ShopRow
@synthesize iconName;
@synthesize name;
@synthesize text;
@synthesize price,level,type;
@end

@implementation ShopContentLayer
@synthesize pages,shopType;

-(id) init:(GameState *)myGameState{
    if( (self=[super init] )) {
        gamestate=myGameState;
        [self update];
    }
    return self;
}

- (void)update{
    pages=0;
    self.isTouchEnabled=true;
    buttons=[[NSMutableArray alloc] init];
    bars=[[NSMutableArray alloc] init];
    for (Powerup *p in gamestate.powerups){
        if(p.collectable){
            int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.powStr];
            int freqLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.freqStr];
            int i=1;
            while( i<11){
                if(i==powLvl+1){
                    ShopRow *row=[ShopRow alloc];
                    row.iconName=p.imgName;
                    row.price=10*i*i;
                    row.level=i;
                    row.type=0;
                    row.name=p.name;
                    row.text=[NSString stringWithFormat:@"%@ - power level %i    Price: %i", p.name, i, row.price];
                    [bars addObject:row];
                }
                i++;
            }
            i=1;
            while( i<11){
                if(i==freqLvl+1){
                    ShopRow *row=[ShopRow alloc];
                    row.iconName=p.imgName;
                    row.price=10*i*i;
                    row.level=i;
                    row.type=1;
                    row.name=p.name;
                    row.text=[NSString stringWithFormat:@"%@ - frequency level %i    Price: %i", p.name, i, row.price];
                    [bars addObject:row];
                }
                i++;
            }
        }
    }
    int xb1=160;
    int xc1=360;
    int xb2=210;
    int xc2=410;
    int y1=255;
    int y2=190;
    int y3=125;
    int y4=60;
    int xb=xb1;
    int xc=xc1;
    int y=y4;
    for(int i =0;i<bars.count;i++){
        if(y==y1){
            y=y2;
            xb=xb2+(pages-1)*480;
            xc=xc2+(pages-1)*480;
        }else if(y==y2){
            y=y3;
            xb=xb1+(pages-1)*480;
            xc=xc1+(pages-1)*480;
        }else if(y==y3){
            y=y4;
            xb=xb2+(pages-1)*480;
            xc=xc2+(pages-1)*480;
        }else{
            pages=pages+1;
            xb=xb1+(pages-1)*480;
            xc=xc1+(pages-1)*480;
            y=y1;
        }
        ShopRow *shopRow=[bars objectAtIndex:i];
        CCSprite *lolbar= [[CCSprite alloc] initWithFile:@"UIBar.png"];
        lolbar.scale=.5;
        lolbar.position=ccp(xb,y);
        [self addChild:lolbar];
        CCSprite *icon =[[CCSprite alloc] initWithFile:shopRow.iconName];
        icon.position=ccp(xb-115,y);
        icon.scale=.3+shopRow.level*.04;;
        [self addChild:icon];
        CCLabelTTF * lab= [[CCLabelTTF alloc] initWithString:shopRow.text dimensions:CGSizeMake(200, 40) alignment:UITextAlignmentLeft fontName:@"Verdana" fontSize:12];
        lab.position=ccp(xb+30,y);
        [self addChild:lab];
        CCSprite *lolbutt= [[CCSprite alloc] initWithFile:@"UICircle.png"];
        lolbutt.scale=.5;
        lolbutt.position=ccp(xc,y);
        [self addChild:lolbutt];
        [buttons addObject:lolbutt];
        CCSprite *coin =[[CCSprite alloc] initWithFile:@"super_mario_coin.png"];
        coin.scale=.3+shopRow.level*.04;
        coin.position=ccp(xc,y);
        [self addChild:coin];
        
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    location = [self convertToNodeSpace:location];
    for(int j =0;j<bars.count;j++){
        CCSprite *button=[buttons objectAtIndex:j];
        if (CGRectContainsPoint(button.boundingBox, location)) {
            ShopRow *row=[bars objectAtIndex:j];
            for (Powerup *pup in gamestate.powerups){
                if([pup.name isEqualToString:row.name]){
                    int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"gold"];
                    if(gold>row.price){
                        gold=gold-row.price;
                        [[NSUserDefaults standardUserDefaults] setInteger:gold forKey:@"gold"];
                        if(row.type==0){
                            [[NSUserDefaults standardUserDefaults] setInteger:row.level forKey:pup.powStr];
                        }else if (row.type==1){
                            [[NSUserDefaults standardUserDefaults] setInteger:row.level forKey:pup.freqStr];
                        }
                        [self removeAllChildrenWithCleanup:true];
                        [self update];
                        
                    }
                }
            }
        }
    }
}

@end
