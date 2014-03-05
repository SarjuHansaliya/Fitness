//
//  ISWorkoutRemindersViewController.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISWorkoutRemindersViewController.h"
#import "ISAppDelegate.h"
#import "ILAlertView.h"



@interface ISWorkoutRemindersViewController ()

@end

@implementation ISWorkoutRemindersViewController
{
    // dummy data, just for checking screen--------------------------
    NSMutableArray *dateArray;
    NSMutableArray *daysArray;
   
    
    //remove before original implementation---------------------------
    
    ISAppDelegate *appDel;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.backgroundColor=[UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeChanged:)
                                                 name:EKEventStoreChangedNotification
                                               object:appDel.eventStore];
    [self showHUD];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}






//--------------------------------handling table view controller-------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.reminders count];
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
    [cell setCellValuesForReminder:[self.reminders objectAtIndex:indexPath.row]] ;
    
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
    
    NSError *err;
    [appDel.eventStore removeReminder:[self.reminders objectAtIndex:self.selectedReminderIndex.row] commit:YES error:&err];
    if (err==nil) {
        [self.reminders removeObjectAtIndex:self.selectedReminderIndex.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[self.selectedReminderIndex] withRowAnimation:UITableViewRowAnimationFade];
        self.selectedReminderIndex=nil;
    }
    else
    {
        [ILAlertView showWithTitle:@"Error" message:@"Unexpected Error occured!" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    }
    
    
}

- (void)showHUD {
	
    [appDel checkEventStoreAccessForCalendar];
    if (!appDel.isCalendarAccessGranted) {
        
        self.reminders=[NSMutableArray arrayWithCapacity:1];
        [self.tableView reloadData];
        return;
    }
    
	self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.HUD];
	
	self.HUD.labelText = @"Loading...";
	self.HUD.detailsLabelText = @"Fetching data";
	self.HUD.square = YES;
    [self.HUD show:YES];
    [self fetchData];
}

-(void)fetchData
{
    
    NSPredicate *pre=[appDel.eventStore predicateForRemindersInCalendars:@[appDel.calendar]];
    [appDel.eventStore fetchRemindersMatchingPredicate:pre completion:^(NSArray *reminders) {
        
        self.reminders=[NSMutableArray arrayWithCapacity:1];
        for (EKReminder *rm in reminders) {
            
            if (rm.recurrenceRules==nil || [rm.recurrenceRules count]<=0) {
                //[self.reminders removeObject:rm];
                continue;
            }
            
            EKRecurrenceRule *rr=(EKRecurrenceRule*)[rm.recurrenceRules objectAtIndex:0];
            
            if (([rr.daysOfTheWeek count]<=0 || rr.daysOfTheWeek==nil) && (rr.frequency!=EKRecurrenceFrequencyDaily)) {
                continue;
            }
            [self.reminders addObject:rm];
        }
        
        
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        
    }];
    
}
-(void)storeChanged:(id)sender
{
    
    [self showHUD];
}





@end
