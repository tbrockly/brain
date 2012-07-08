//
//  GameNode.m
//  GravityGrapple
//
//  Created by Jordan Schidlowsky on 26/07/09.
//  Copyright 2009 Scouting Solutions. All rights reserved.
//

#import "Monster.h"
#import "GameScene.h"
#import "Box2D.h"
#import "cocos2d.h"

@implementation Monster
@synthesize b2body, b2shape, gameWorld;
#define PTM_RATIO 25.0

- (id) init {
    self = [super init];
    if( self ) {
        
        // set body and shape to nil;
        //b2body = //DO ALL BOX 2D initialize here
        // b2shape = //DO ALL BOX 2D initialize here
        // Create sprite and add it to the layer
        self = [CCSprite spriteWithFile:@"HeadItemside.png"];
        self.position = ccp(1000, 100);
        
        b2BodyDef enemyBodyDef;
        enemyBodyDef.type = b2_dynamicBody;
        enemyBodyDef.linearVelocity= b2Vec2(1,0);
        enemyBodyDef.position.Set(1000/PTM_RATIO, 100/PTM_RATIO);
        b2body= [gameWorld _world]->CreateBody(&enemyBodyDef);
        
        b2PolygonShape lol;
        lol.SetAsBox(1, 1, b2Vec2(0, 0), .01);
        
        b2FixtureDef enemyShape;
        enemyShape.shape = &lol;
        enemyShape.density = 0.1f;
        enemyShape.friction = 0.0f;
        enemyShape.restitution = 0.6f;
        b2body->CreateFixture(&enemyShape);
        
        [self schedule: @selector(tickGameNode:) interval:1.0/60.0];
    }
    
    return self;
}

-(id) initWithGame:(Game *)game{
    self.gameWorld=game;
}

-(void) tickGameNode: (ccTime) dt {
    // set position of sprite based on position of space
    if(b2body != nil) {
//        CGPoint worldPosition = cpv(b2body->GetPosition().x * PTM_RATIO, b2body->GetPosition().y * PTM_RATIO);
//        
//        // find the screen position relative to the camera view.
//        CGPoint viewPosition = [[Game instance] view];
//        worldPosition = cpvsub(worldPosition, viewPosition);
//        
//        [self setPosition:worldPosition];
//        [self setRotation:CC_RADIANS_TO_DEGREES(b2body->GetAngle() * -1)];
    }
}

-(void) dealloc {
    CCLOG( @"deallocing %@",self);
    [super dealloc];
}

@end