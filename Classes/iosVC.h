//
//  iosVC.h
//  Champion Lineup
//
//  Created by Ted on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableView.h"

@interface iosVC : UIViewController{

    UIImageView* bgImageView;
    MainTableView* myTable;
}
@property (nonatomic,retain) MainTableView* myTable;
@property (nonatomic, retain) UIImageView* bgImageView;
-(void)reloadData;
@end
