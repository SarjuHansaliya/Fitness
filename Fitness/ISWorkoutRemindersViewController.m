//
//  ISWorkoutRemindersViewController.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISWorkoutRemindersViewController.h"



@interface ISWorkoutRemindersViewController ()

@end

@implementation ISWorkoutRemindersViewController
{
    // dummy data, just for checking screen--------------------------
    NSMutableArray *dateArray;
    NSMutableArray *daysArray;
   
    
    //remove before original implementation---------------------------
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillDummyReminderData]; //remove this
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.backgroundColor=[UIColor clearColor];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






//--------------------------------handling table view controller-------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [dateArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReminderCell";
    ISReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[ISReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        
               
    }
    [cell setReminderTime:[dateArray objectAtIndex:indexPath.row] reminderOnDays:[daysArray objectAtIndex:indexPath.row] ];
    
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ISReminderCell *prevSelectedCell=(ISReminderCell *)[self.tableView cellForRowAtIndexPath:self.selectedReminderIndex];
    ISReminderCell *newSelectedCell=(ISReminderCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.selectedReminderIndex isEqual:indexPath]) {
        prevSelectedCell.reminderSelImage.hidden=!prevSelectedCell.reminderSelImage.hidden;
        if (prevSelectedCell.reminderSelImage.hidden) {
            self.selectedReminderIndex=nil;
        }
        
        
    }
    else
    {
        
        
        prevSelectedCell.reminderSelImage.hidden=YES;
        newSelectedCell.reminderSelImage.hidden=NO;
        
        self.selectedReminderIndex=indexPath;
        
    }
    
    
}

-(void)deleteCell
{
    if (self.selectedReminderIndex!=nil) {
        
    
    [dateArray removeObjectAtIndex:self.selectedReminderIndex.row];
    [daysArray removeObjectAtIndex:self.selectedReminderIndex.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[self.selectedReminderIndex] withRowAnimation:UITableViewRowAnimationFade];
        self.selectedReminderIndex=nil;
    }
    
}



//-------------------------filling dummy Data-------------------------
-(void)fillDummyReminderData
{
    dateArray=[[NSMutableArray alloc]initWithCapacity:1];
    [dateArray addObject:[NSDate date]];
    [dateArray addObject:[NSDate date]];
    [dateArray addObject:[NSDate date]];
    
    NSArray *weekdays1=@[@"Mon,",@"Tue,",@"Wed,",@"Thu,",@"Fri,",@"Sat"];
    NSArray *weekdays2=@[@"Mon,",@"Tue,",@"Wed"];
    NSArray *weekdays3=@[@"Wed,",@"Thu,",@"Fri,",@"Sat"];
    
    
    daysArray=[[NSMutableArray alloc]initWithCapacity:1];
    
    [daysArray addObject:weekdays1];
    [daysArray addObject:weekdays2];
    [daysArray addObject:weekdays3];
    
    
    
}
    




@end
