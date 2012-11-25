

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCScrollLayer:CCLayer{
    CCLayer *scrollLayer;
    BOOL isDragging;
    float lasty;
    float yvel;
    int contentHeight;
}


@end