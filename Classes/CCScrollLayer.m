

#import "CCScrollLayer.h"

@implementation CCScrollLayer

- (id) init {
	// stuff snipped out
	isTouchEnabled = YES;
    
	isDragging = NO;
	lasty = 0.0f;
	yvel = 0.0f;
	contentHeight = 800; // whatever you want here for total height
    
	// main scrolling layer
	scrollLayer = [[Layer alloc] init];
	scrollLayer.anchorPoint = ccp( 0, 1 );
	scrollLayer.position = ccp( 0, 320 );
	[self addChild:scrollLayer];
    
	[self schedule:@selector(moveTick:) interval:0.02f];
    return self;
}

#pragma mark Scheduled Methods

- (void) moveTick: (ccTime)dt {
	float friction = 0.95f;
    
	if ( !isDragging ) {
		// inertia
		yvel *= friction;
		CGPoint pos = scrollLayer.position;
		pos.y += yvel;
		pos.y = MAX( 320, pos.y );
		pos.y = MIN( contentHeight + 320, pos.y );
		scrollLayer.position = pos;
	}
	else {
		yvel = ( scrollLayer.position.y - lasty ) / 2;
		lasty = scrollLayer.position.y;
	}
}

#pragma mark Touch Methods

// other touch events : ccTouchesBegan, ccTouchesMoved, ccTouchesEnded, ccTouchesCancelled
- (BOOL) ccTouchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
	isDragging = YES;
	return kEventHandled;
}

- (BOOL) ccTouchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
    
	UITouch *touch = [touches anyObject];
    
	// simple position update
	CGPoint a = [[Director sharedDirector] convertToGL:[touch previousLocationInView:touch.view]];
	CGPoint b = [[Director sharedDirector] convertToGL:[touch locationInView:touch.view]];
	CGPoint nowPosition = scrollLayer.position;
	nowPosition.y += ( b.y - a.y );
	nowPosition.y = MAX( 320, nowPosition.y );
	nowPosition.y = MIN( contentHeight + 320, nowPosition.y );
	scrollLayer.position = nowPosition;
    
	return kEventHandled;
}

- (BOOL) ccTouchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	isDragging = NO;
	return kEventHandled;
}