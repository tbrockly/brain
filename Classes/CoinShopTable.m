//
//  CoinShopTable.m
//  Cocos2DSimpleGame
//
//  Created by Ted on 5/18/13.
//
//

#import "CoinShopTable.h"
#import "Powerup.h"
#import "cocos2d.h"
#import "Shield.h"

@implementation CoinShopRow
@synthesize iconName;
@synthesize name;
@synthesize text;
@synthesize price,level,type;
@end

@implementation CoinShopTable

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
    return @"CoinShop";
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
    CoinShopRow *row=[myArray objectAtIndex:indexPath.row];
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
        for (Powerup *p in gameState.powerups){
            if([p.name isEqualToString:row.name]){
                int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.powStr];
                int freqLvl=[[NSUserDefaults standardUserDefaults] integerForKey:p.freqStr];
                if(row.type==0 && row.level==powLvl+1){
                    cell.contentView.backgroundColor=[UIColor whiteColor];
                    cell.textLabel.backgroundColor=[UIColor whiteColor];
                    cell.textLabel.textColor=[UIColor yellowColor];
                }
                if(row.type==1 && row.level==freqLvl+1){
                    cell.contentView.backgroundColor=[UIColor whiteColor];
                    cell.textLabel.backgroundColor=[UIColor whiteColor];
                    cell.textLabel.textColor=[UIColor yellowColor];
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
    CoinShopRow *row=[myArray objectAtIndex:indexPath.row];
    for (Powerup *pup in gameState.powerups){
        if([pup.name isEqualToString:row.name]){
            int powLvl=[[NSUserDefaults standardUserDefaults] integerForKey:pup.powStr];
            int freqLvl=[[NSUserDefaults standardUserDefaults] integerForKey:pup.freqStr];
            if(row.type==0 && row.level==powLvl+1){
                [[NSUserDefaults standardUserDefaults] setInteger:powLvl+1 forKey:pup.powStr];
                [pup initSelf];
                [myArray removeObjectAtIndex:indexPath.row];
                [CATransaction begin];
                [CATransaction setCompletionBlock:^{[self reloadData];}];
                [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [CATransaction commit];
            }
            if(row.type==1 && row.level==freqLvl+1){
                [[NSUserDefaults standardUserDefaults] setInteger:freqLvl+1 forKey:pup.freqStr];
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

@end
