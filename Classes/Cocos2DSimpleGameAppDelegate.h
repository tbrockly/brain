

#import <UIKit/UIKit.h>

@class RootViewController;

@interface Cocos2DSimpleGameAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    //UIFont *archerFont;
}

@property (nonatomic, retain) UIWindow *window;

@end
