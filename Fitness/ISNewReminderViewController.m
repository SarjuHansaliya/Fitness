//
//  ISNewReminderViewController.m
//  Fitness
//
//  Created by ispluser on 2/17/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISNewReminderViewController.h"
#import "macros.h"
#import "ILAlertView.h"
#import "ISAppDelegate.h"



@interface ISNewReminderViewController ()

@end

@implementation ISNewReminderViewController
{
    ISAppDelegate *appDel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

-(ISReminderRepeatViewController*)getRepeatController
{
    if (self.repeatController==nil) {
        self.repeatController=[[ISReminderRepeatViewController alloc]initWithStyle:UITableViewStylePlain];
    }
    
    return self.repeatController;
}
-(ISReminderAlertViewController*)getAlertController
{
    if (self.alertController==nil) {
        self.alertController=[[ISReminderAlertViewController alloc]initWithStyle:UITableViewStylePlain];
    }
    
    return self.alertController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupNavigationBar];
    
    self.toDateTextField.inputView=self.datePicker;
    self.toDateTextField.inputAccessoryView=self.accessoryView;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd , yyyy\t   hh:mm a"];
    
    self.toDateTextField.text=[formatter stringFromDate:[NSDate date]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.alertController!=nil) {

        self.alertLabel.text = self.alertController.label;
    }
    
}

//--------------------------------setting up navigation bar--------------------------------------



-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:254.0/255.0 green:247.0/255.0 blue:235.0/255.0 alpha:1.0]];
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:254.0/255.0 green:247.0/255.0 blue:235.0/255.0 alpha:1.0]];
        
    }
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"New Reminder";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 38, 18)];
    
    UITapGestureRecognizer *tapOnCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClicked:)];
    tapOnCancel.numberOfTapsRequired=1;
    [leftView addGestureRecognizer:tapOnCancel];
    
    UILabel *leftLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 38, 18)];
    
    leftLable.backgroundColor=[UIColor clearColor];
    leftLable.text=@"Cancel";
    leftLable.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    leftLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    [leftView addSubview:leftLable];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 38, 18)];
    
    UITapGestureRecognizer *tapOnSave = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveClicked:)];
    tapOnSave.numberOfTapsRequired=1;
    [rightView addGestureRecognizer:tapOnSave];
    
    UILabel *rightLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 38, 18)];
    
    rightLable.backgroundColor=[UIColor clearColor];
    rightLable.text=@"Save";
    rightLable.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    rightLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    rightLable.textAlignment=NSTextAlignmentRight;
    
    [rightView addSubview:rightLable];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    
}



//--------------------------setting up gesture recognizer----------------------------

-(void)setupGestureRecognizer
{
    
    UITapGestureRecognizer *tapOnRepeat = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(repeatClicked:)];
    tapOnRepeat.numberOfTapsRequired=1;
    [self.repeatView addGestureRecognizer:tapOnRepeat];
    
    UITapGestureRecognizer *tapOnAlert = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertClicked:)];
    tapOnAlert.numberOfTapsRequired=1;
    [self.alertView addGestureRecognizer:tapOnAlert];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//------------------------------Events ------------------------------------



-(void)cancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveClicked:(id)sender
{
    if([self.toDateTextField isFirstResponder])
    {
        return;
    }
    
    
    if (![self.reminderLabel.text length]>0) {
        [ILAlertView showWithTitle:@"Warning" message:@"Enter Label" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
        [self.reminderLabel becomeFirstResponder];
    }
    else
    {
        
        EKReminder *reminder=[EKReminder reminderWithEventStore:appDel.eventStore];
        [reminder setTitle:self.reminderLabel.text];
        [reminder setCalendar:appDel.calendar];
        
        
        if ([self.alertController selectedRow]!=0) {
            
            EKAlarm *alarm;
            if (self.alertController.selectedRow==AT_EVENT) {
                alarm=[EKAlarm alarmWithAbsoluteDate:self.datePicker.date];
            }
            else
            {
                switch (self.alertController.selectedRow) {
                        
                    case MIN_5:
                        alarm=[EKAlarm alarmWithRelativeOffset:-(5.0*60.0)];
                        break;
                    case MIN_15:
                        alarm=[EKAlarm alarmWithRelativeOffset:-(15.0*60.0)];
                        break;
                    case MIN_30:
                        alarm=[EKAlarm alarmWithRelativeOffset:-(30.0*60.0)];
                        break;
                    case HOUR_1:
                        alarm=[EKAlarm alarmWithRelativeOffset:-(1.0*60.0*60.0)];
                        break;
                    case HOUR_2:
                        alarm=[EKAlarm alarmWithRelativeOffset:-(2.0*60.0*60.0)];
                        break;
                        
                        
                        
                }
            }
            [reminder setAlarms:@[alarm]];
        }
        
        NSMutableArray * weekDays=[NSMutableArray arrayWithCapacity:1];
//        for (NSIndexPath *ip in [self.repeatController.tableView indexPathsForSelectedRows]) {
//           // NSLog(@"%d",ip.row);
//            [weekDays addObject:[EKRecurrenceDayOfWeek dayOfWeek:ip.row]];
//            
//        }
        
        for(int i=1;i<=7;i++)
        {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
            
                ISRepeatReminderCell *cell = (ISRepeatReminderCell*)[self.repeatController.tableView cellForRowAtIndexPath:ip];
                if(cell.selectedImage.hidden == NO)
                {
                    [weekDays addObject:[EKRecurrenceDayOfWeek dayOfWeek:ip.row]];
                    // NSLog(@"%d",ip.row);
                }
                
           
            
        }
        if([weekDays count] <=0 || self.repeatController ==nil)
        {
            [ILAlertView showWithTitle:@"Warning" message:@"Please select repeat options" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
            return;
        }
        
        EKRecurrenceRule *rr=[[EKRecurrenceRule alloc]initRecurrenceWithFrequency:1 interval:1 daysOfTheWeek:weekDays daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
        
        [reminder setRecurrenceRules:@[rr]];
       
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSTimeZoneCalendarUnit|NSCalendarCalendarUnit;
        NSDateComponents *startDateComponents =
        [gregorian components:unitFlags fromDate:[NSDate date]];
        NSDateComponents *endDateComponents =
        [gregorian components:unitFlags fromDate:self.datePicker.date];
        
               
        
        [reminder setStartDateComponents:startDateComponents];
        [reminder setDueDateComponents:endDateComponents];
     
        
        
        [ILAlertView showWithTitle:@"Save Reminder" message:@"Do u want to save Reminder?" closeButtonTitle:@"No" secondButtonTitle:@"Yes" tappedSecondButton:^{
            NSError *err;
            [appDel.eventStore saveReminder:reminder commit:YES error:&err];
            //NSLog(@"%@",err);
            if (err==nil) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    
    
}
-(void)repeatClicked:(id)sender
{
    
    [self.navigationController pushViewController:[self getRepeatController] animated:YES ];
}

-(void)alertClicked:(id)sender
{
    
    [self.navigationController pushViewController:[self getAlertController] animated:YES ];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if([self.toDateTextField isFirstResponder])
    {
        return;
    }
    
    [self.view endEditing:YES];
}

- (IBAction)doneEditing:(id)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd , yyyy\t   hh:mm a"];
    self.toDateTextField.text = [formatter stringFromDate: self.datePicker.date];
    [self.toDateTextField resignFirstResponder];
    
    
    
}


@end
