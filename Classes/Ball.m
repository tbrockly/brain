#import "Ball.h"
#import "GameScene.h"

#define PTM_RATIO 32

@implementation Ball

- (void)dealloc {
    delete bodyDef;
    delete shapeDef;
    delete fixtureDef;
    [self setBody:nil];
    [self setBodyDef:nil];
    [self setShapeDef:nil];
    [self setFixtureDef:nil];
    
    [super dealloc];
}

- (id)initWithMgr:(CGPoint)points {
    if(self = [super init]) {
        [self init];
        
        [self setBodyDef:new b2BodyDef];
        [self bodyDef]->position.Set(points.x/PTM_RATIO, points.y/PTM_RATIO);
        [self bodyDef]->type = b2_dynamicBody;
        
        [self setShapeDef:new b2PolygonShape];
        [self shapeDef]->SetAsBox(2, 2, b2Vec2(0, 0), .01);
        
        [self setFixtureDef:new b2FixtureDef];
        [self fixtureDef]->shape = shapeDef;
        
        [self fixtureDef]->friction = 0.91f;
        [self fixtureDef]->density = 0.4f;
        [self fixtureDef]->restitution = 0.4f;
        
    }
    
    return self;
}

-(id) addCCNode:(CCNode *)pSprite {
    [self body]->SetUserData(pSprite);
    return self;
}

- (void)addBall {
    [self setBody:[[self game] world]->CreateBody([self bodyDef])];
    [self body]->CreateFixture([self fixtureDef]);
}

@synthesize game;

@synthesize body;

@synthesize bodyDef;

@synthesize shapeDef;

@synthesize fixtureDef;

@end