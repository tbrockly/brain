//
//  GameNode.h
//  GravityGrapple
//
//  Created by Jordan Schidlowsky on 26/07/09.
//  Copyright 2009 Scouting Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GameScene.h"

@interface Monster : CCNode {
    
    b2Body* b2body;
    b2Shape* b2shape;
    b2World* gameWorld;
    
}

-(id) initWithGame:(Game *)gameScene;

@property (readwrite,assign) b2Body* b2body;
@property (readwrite,assign) b2Shape* b2shape;
@property (nonatomic,assign) b2World* gameWorld;

@end