//
//  BrainShopTable.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import "BrainShopTable.h"
#import "GlobalParam.h"
#import "cocos2d.h"
#import "ShopRightLayer.h"

@implementation BrainShopRow
@synthesize iconName;
@synthesize name;
@synthesize text;
@synthesize price,level,type;
@end

@implementation BrainShopTable

- (id)initWithFrame:(CGRect)frame gameState:(GameState*)gs rowArray:(id)rowArray
{
    self=[super initWithFrame:frame];
    if (self) {
        self.delegate=self;
        self.dataSource=self;
        self.backgroundColor=[UIColor clearColor];
        myArray=rowArray;
        gameState=gs;
        //self.separatorColor=[UIColor darkGrayColor];
        self.opaque=false;
    }
    return self;
}

-(NSString*)tableView:(UITableView*)tableview titleForHeaderInSection:(NSInteger)section{
    return @"BrainShop";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [myArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.contentView.opaque=false;
    BrainShopRow *row=[myArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor=[UIColor grayColor];
        cell.textLabel.numberOfLines=1;
        cell.textLabel.font=[UIFont fontWithName:@"Verdana" size:8];
        cell.textLabel.backgroundColor=[UIColor grayColor];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.textLabel.shadowColor=[UIColor darkGrayColor];
        cell.textLabel.shadowOffset=CGSizeMake(1, 1);
    }
    if(indexPath.section==0){
        cell.contentView.backgroundColor=[UIColor grayColor];
        cell.textLabel.backgroundColor=[UIColor grayColor];
        cell.textLabel.textColor=[UIColor lightTextColor];
        int brains = [[NSUserDefaults standardUserDefaults] integerForKey:@"brains"];
        
        for (GlobalParam *p in gameState.globalParams){
            if([p.name isEqualToString:row.name]){
                int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.name];
                if((row.type==0 && row.level==powLvl+1)){
                    if(brains>row.price){
                        cell.contentView.backgroundColor=[UIColor whiteColor];
                        cell.textLabel.backgroundColor=[UIColor whiteColor];
                        cell.textLabel.textColor=[UIColor yellowColor];
                    }else{
                        cell.contentView.backgroundColor=[UIColor redColor];
                        cell.textLabel.backgroundColor=[UIColor redColor];
                        cell.textLabel.textColor=[UIColor blackColor];
                    }
                }
            }
        }
        cell.imageView.image=[UIImage imageNamed:row.iconName];
        cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cell.textLabel.text=row.text;
    }
    
    // Configure the cell...
    
    return cell;
}


-(void)removeFromSuperview{
    [super removeFromSuperview];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrainShopRow *row=[myArray objectAtIndex:indexPath.row];
    for (GlobalParam *pup in gameState.globalParams){
        if([pup.name isEqualToString:row.name]){
            int brains = [[NSUserDefaults standardUserDefaults] integerForKey:@"brains"];
            if(brains>row.price){
                int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:pup.name];
                if(row.type==0 && row.level==powLvl+1){
                    brains=brains-row.price;
                    [[NSUserDefaults standardUserDefaults] setInteger:brains forKey:@"brains"];
                    [[NSUserDefaults standardUserDefaults] setInteger:powLvl+1 forKey:pup.name];
                    [pup initSelf];
                    [myArray removeObjectAtIndex:indexPath.row];
                    [CATransaction begin];
                    [CATransaction setCompletionBlock:^{[self reloadData];}];
                    [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [CATransaction commit];
                }
            }
        }
    }
}

@end
