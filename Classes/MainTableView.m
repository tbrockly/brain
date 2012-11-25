//
//  MainTableView.m
//  Champion Lineup
//
//  Created by Ted on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainTableView.h"
#import "Powerup.h"
#import "cocos2d.h"
#import "ShopRightLayer.h"

@implementation MainTableView
ShopRightLayer *srl;

- (id)initWithFrame:(CGRect)frame gameState:(GameState*)gs
{
    self=[super initWithFrame:frame];
    if (self) {
        self.delegate=self;
        self.dataSource=self;
        self.backgroundColor=[UIColor clearColor];
        gameState=gs;
        //self.separatorColor=[UIColor darkGrayColor];
        self.opaque=false;
    }
    return self;
}

-(NSString*)tableView:(UITableView*)tableview titleForHeaderInSection:(NSInteger)section{
    return @"All Champions";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[gameState powerups] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.contentView.opaque=false;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor yellowColor];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.numberOfLines=3;
        //cell.textLabel.font=[myApp archerFont];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.textLabel.shadowColor=[UIColor darkGrayColor];
        cell.textLabel.shadowOffset=CGSizeMake(1, 1);
    }
    if(indexPath.section==0){
        Powerup *powerup=[[gameState powerups] objectAtIndex:indexPath.row];
        cell.imageView.image=[UIImage imageNamed:powerup.imgName];
        cell.textLabel.text=powerup.imgName;
    }
    
    // Configure the cell...
    
    return cell;
}
-(void)removeFromSuperview{
    [srl removeFromParentAndCleanup:TRUE];
    [super removeFromSuperview];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Powerup *powerup=[[gameState powerups] objectAtIndex:indexPath.row];
    powerup.position=ccp(300,300);
    srl=[[ShopRightLayer alloc] init:powerup];
    [parent addChild:srl];
    //[[[CCDirector sharedDirector] runningScene] addChild:srl];
}

@end
