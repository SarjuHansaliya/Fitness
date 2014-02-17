//
//  ISProfileViewController.m
//  Fitness
//
//  Created by ispladmin on 11/02/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISProfileViewController.h"



@interface ISProfileViewController ()

@end


@implementation ISProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self registerForKeyboardNotifications];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    [self setupGenderRB];
    
       // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-----------------------handling keyboard activities------------------------------


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.contentScrollView.contentInset = contentInsets;
    self.contentScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
//    if (!CGRectContainsPoint(aRect, self.weightTextfeild.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, self.weightTextfeild.frame.origin.y-kbSize.height);
//        [self.contentScrollView setContentOffset:scrollPoint animated:YES];
//    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UIView * txt in self.subviews){
//        if (!([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder])) {
//            [self.view endEditing:YES];
//        }
//        
//    }

    [self.view endEditing:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentScrollView.contentInset = contentInsets;
    self.contentScrollView.scrollIndicatorInsets = contentInsets;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//-------------------------------Handle gender RB checked change---------------------------------


-(void)setupGenderRB
{
    //UIImage *imageUnchecked = [UIImage imageNamed:@"radoi.png"];
    UIImage *imageChecked = [UIImage imageNamed:@"radio-sel.png"];

    [self.maleRB setImage:imageChecked forState:UIControlStateSelected];
    [self.femaleRB setImage:imageChecked forState:UIControlStateSelected];

    
}
-(void)changeGender
{
   self.maleRB.selected=!self.maleRB.selected;
    self.femaleRB.selected=!self.femaleRB.selected;
    
}

- (IBAction)maleRBClicked:(id)sender {
    
    if (!self.maleRB.selected) {
        
        
        [self changeGender];
    }
    
}

- (IBAction)femaleRBClicked:(id)sender {
    if (!self.femaleRB.selected) {
        
        
        [self changeGender];
    }
    
}


@end






//-----------------------------custom view with keyboard dismiss-------------

@implementation UIViewDismissKB:UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.subviews){
        if (!([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder])) {
             [self endEditing:YES];
        }
        
    }
}


@end




