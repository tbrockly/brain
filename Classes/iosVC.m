//
//  iosVC.m
//  Champion Lineup
//
//  Created by Ted on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iosVC.h"
#import "MainTableView.h"
#define myApp (AppDelegate*)[[UIApplication sharedApplication] delegate]

@implementation iosVC
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)reloadData{

}

- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

@end
