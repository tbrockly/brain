//
//  LevelData.h
//  Cocos2DSimpleGame
//
//  Created by Ted on 7/7/13.
//
//

#import <Foundation/Foundation.h>

@interface LevelData : NSObject

@property int bronze, silver, gold;
@property (nonatomic,retain) NSString *name;

-(id)initWithName:(NSString*)name bronze:(int)bronze silver:(int)silver gold:(int)gold;

@end
