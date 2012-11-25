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
@synthesize bgImageView;
@synthesize myTable;
- (id)init
{
    self = [super init];
    if (self) {
        bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [bgImageView setImage:[UIImage imageNamed:@"slice_3_0.jpg"]];
        [self.view addSubview:bgImageView];
        myTable=[[MainTableView alloc] initWithFrame:CGRectMake(10, 0, 300, self.view.frame.size.height)];
        [self.view addSubview:myTable];
    }
    return self;
}

-(void)reloadData{
    [myTable reloadData];
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
