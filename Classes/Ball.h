//Ball.h

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import <cocos2d.h>

@class Game;

@interface Ball : CCNode {
@private
    Game *game;
    b2World *world;
    b2Body *body;
    b2BodyDef *bodyDef;
    b2PolygonShape *shapeDef;
    b2FixtureDef *fixtureDef;
}

-(void) addBall;

-(id) initWithMgr:(CGPoint)points; // atlasManager reference

-(id) addCCNode:(CCNode *)pSprite;

@property (nonatomic, retain) Game *game;

@property (nonatomic, assign) b2Body *body;

@property (nonatomic, assign) b2BodyDef *bodyDef;

@property (nonatomic, assign) b2PolygonShape *shapeDef;

@property (nonatomic, assign) b2FixtureDef *fixtureDef;

@end