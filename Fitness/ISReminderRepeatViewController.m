//
//  ISReminderRepeatViewController.m
//  Fitness
//
//  Created by ispluser on 2/19/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISReminderRepeatViewController.h"
#import "ISRepeatReminderCell.h"
#import "macros.h"

@interface ISReminderRepeatViewController ()

@end

@implementation ISReminderRepeatViewController

{
    
    NSMutableArray *labelArray;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Repeat";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    float xSpace=SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?-10.0f:-0.0f;
    
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tapBack=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack:)];
    tapBack.numberOfTapsRequired=1;
    [backView addGestureRecognizer:tapBack];
    UIButton *backButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButtonCustom setFrame:CGRectMake(xSpace, 3.0f, 25.0f, 25.0f)];
    [backButtonCustom addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButtonCustom setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backView addSubview:backButtonCustom];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    
    
    
    // [backButton setTintColor: [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
}

-(void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}





//--------------------------------handling table view controller-------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [labelArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *CellIdentifier = @"ReminderCell";
    ISRepeatReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[ISRepeatReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
    }
    
   // BOOL temp = (self.selectedRow == indexPath.row) ? YES : NO;
    
    [cell setLabel:[labelArray objectAtIndex:indexPath.row] isSelected:cell.isSelected];
    
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
    
    
    
    
    
    if (indexPath.row==0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        for (int i=1; i<[labelArray count]; i++) {
            ISRepeatReminderCell *cellOther=(ISRepeatReminderCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cellOther.selectedImage setHidden:NO];
        }
        
    }
    else
    {
        ISRepeatReminderCell *cell=(ISRepeatReminderCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.selectedImage setHidden:!cell.selectedImage.hidden];
        ISRepeatReminderCell *cellOther=(ISRepeatReminderCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cellOther.selectedImage setHidden:YES];
    }
    
}





//-------------------------filling dummy Data-------------------------
-(void)fillDummyReminderData
{
    labelArray=[[NSMutableArray alloc]initWithCapacity:1];
    [labelArray addObject:@"Every Day"];
    [labelArray addObject:@"Sunday"];
    [labelArray addObject:@"Monday"];
    [labelArray addObject:@"Tuesday"];
    [labelArray addObject:@"Wednesday"];
    [labelArray addObject:@"Thursday"];
    [labelArray addObject:@"Friday"];
    [labelArray addObject:@"Saturday"];
    
    
    
    
}



@end
