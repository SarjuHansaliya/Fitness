//
//  ISWorkoutRemindersViewController.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISWorkoutRemindersViewController.h"
#import "ISReminderCell.h"
#import "ISEditReminderViewController.h"
#import "ISNewReminderViewController.h"


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
    [self setupNavigationBar];
    [self fillDummyReminderData]; //remove this
    self.tableView.separatorColor=[UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    
    self.tableView.backgroundView = imageView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------------------setting up navigation bar--------------------------------------

-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 19)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Workout Reminder";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    
    
    UIButton *backButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButtonCustom setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [backButtonCustom addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButtonCustom setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backButtonCustom];
    
    UIButton *addButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButtonCustom setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [addButtonCustom addTarget:self action:@selector(addNewReminder:) forControlEvents:UIControlEventTouchUpInside];
    [addButtonCustom setImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:addButtonCustom];
    
    // [backButton setTintColor: [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    
}
-(void)addNewReminder:(id)sender
{
    ISNewReminderViewController *newReminder=[[ISNewReminderViewController alloc]initWithNibName:nil bundle:nil];
    newReminder.wantsFullScreenLayout = YES;
    
    [self presentViewController:newReminder animated:YES completion:nil];

}
-(void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)editReminder:(id)sender
{
    
    ISEditReminderViewController *edit=[[ISEditReminderViewController alloc]initWithNibName:nil bundle:nil];
    edit.wantsFullScreenLayout = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:edit];
    [self presentViewController:nav animated:YES completion:nil];
    
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
    UITapGestureRecognizer *tapOnEdit = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editReminder:)];
    tapOnEdit.numberOfTapsRequired =1;

    
    if (cell == nil) {
        
        cell = [[ISReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        
        [cell.outletOwner.editView addGestureRecognizer:tapOnEdit];
        
       //cell = [[ISReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        
        
    }
    [cell setReminderTime:[dateArray objectAtIndex:indexPath.row] reminderOnDays:[daysArray objectAtIndex:indexPath.row]];
    
    
    
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
