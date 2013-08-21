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
    for(int j =0;j<gamestate.powerups.count;j++){
        Powerup *p=[gamestate.powerups objectAtIndex:j];
        if(p.collectable){
            int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.powStr];
            //int freqLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.freqStr];

                    ShopRow *row=[ShopRow alloc];
                    row.iconName=p.imgName;
                    row.price=10*(powLvl+1)*(powLvl+1)+(j*10);
                    row.level=powLvl;
                    row.type=0;
                    row.name=p.name;
                    row.text=[NSString stringWithFormat:@"%@ \nlevel:%i\nPrice:%i", p.name, powLvl+1, row.price];
                    [bars addObject:row];

//            i=1;
//            while( i<11){
//                if(i==freqLvl+1){
//                    ShopRow *row=[ShopRow alloc];
//                    row.iconName=p.imgName;
//                    row.price=10*i*i;
//                    row.level=i;
//                    row.type=1;
//                    row.name=p.name;
//                    row.text=[NSString stringWithFormat:@"%@ - frequency level %i    Price: %i", p.name, i, row.price];
//                    [bars addObject:row];
//                }
//                i++;
//            }
        }
    }
    int xstart=60;
    int xwidth=65;
    int ystart=255;
    int yheight=65;
    
    for(int i =0;i<bars.count;i++){
        int y=ystart-floor(i/3)*yheight;
        int x=xstart+(i%3)*xwidth;

        ShopRow *shopRow=[bars objectAtIndex:i];
        CCSprite *lolbar= [[CCSprite alloc] initWithFile:@"UICircle.png"];
        lolbar.scale=.4;
        lolbar.position=ccp(x,y);
        [self addChild:lolbar];
        [buttons addObject:lolbar];
        CCSprite *lolbar2= [[CCSprite alloc] initWithFile:@"UICircle.png"];
        lolbar2.scale=.17;
        lolbar2.position=ccp(x-20,y+20);
        [self addChild:lolbar2];
        
        if(shopRow.level>=0){
            CCLabelBMFont *lvl=[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%i", shopRow.level]
                                               fntFile:@"arial16.fnt"];
            lvl.position=ccp(x-20,y+20);
            [self addChild:lvl];
            CCSprite *icon =[[CCSprite alloc] initWithFile:shopRow.iconName];
            icon.position=ccp(x,y);
            icon.scale=.4;
            [self addChild:icon];
        }else{
            CCLabelTTF* tempCoin=[[CCLabelTTF alloc] initWithString:@"?" fontName:@"FontStuck Extended" fontSize:48];
            tempCoin.position=ccp(x,y);
            [self addChild:tempCoin];
        }
    }
    CCSprite *box=[[CCSprite alloc] initWithFile:@"MultipleBox.png"];
    box.position=ccp(340,210);
    [self addChild:box];
    //[NSString stringWithFormat:@"%i",(int)gameState.vx]
    desc=[[CCLabelTTF alloc] initWithString:@"-Select Powerup-" dimensions:CGSizeMake(100,100) alignment:UITextAlignmentLeft fontName:@"Verdana" fontSize:16];
    desc.position=ccp(340,200);
    [self addChild:desc];
    
    buy=[[CCSprite alloc] initWithFile:@"ok.png"];
    buy.scale=.2;
    buy.position=ccp(320,100);
    buy.opacity=0;
    [self addChild:buy];
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
                    [desc setString:row.text];
                    selectedRow=row;
                    selectedIndex=j;
                    int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"gold"];
                    if(gold>selectedRow.price){
                        buy.opacity=250;
                    }else{
                        buy.opacity=50;
                    }
                }
            }
        }
    }
    if (CGRectContainsPoint(buy.boundingBox, location)) {
        int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"gold"];
        for (Powerup *pup in gamestate.powerups){
            if([pup.name isEqualToString:selectedRow.name]){
                if(gold>selectedRow.price){
                    gold=gold-selectedRow.price;
                    [[NSUserDefaults standardUserDefaults] setInteger:gold forKey:@"gold"];
                    if(selectedRow.type==0){
                        [[NSUserDefaults standardUserDefaults] setInteger:selectedRow.level+1 forKey:pup.powStr];
                    }
                    if(selectedIndex+1< [bars count]){
                        ShopRow *row=[bars objectAtIndex:selectedIndex+1];
                        for (Powerup *pup in gamestate.powerups){
                            if([pup.name isEqualToString:row.name]){
                                if([[NSUserDefaults standardUserDefaults] integerForKey:pup.powStr]==-1){
                                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:pup.powStr];
                                }
                            }
                        }
                    }
                    [self removeAllChildrenWithCleanup:true];
                    [self update];
                    
                }
            }
        }
    }
}

@end
