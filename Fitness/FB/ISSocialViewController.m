//
//  ISSocialViewController.m
//  Fitness
//
//  Created by ispluser on 3/20/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISSocialViewController.h"
#import "ILAlertView.h"
#import <Social/Social.h>
#import "MBProgressHUD.h"
#import "ISStatisticsViewController.h"
#import "ISReportDetailsViewController.h"


@interface ISSocialViewController ()


@end

@implementation ISSocialViewController
{
    MBProgressHUD *hud;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(UIViewController*)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate=delegate;
        hud = [[MBProgressHUD alloc] initWithView:delegate.view];
        [self.delegate.view addSubview:hud];
        hud.labelText = @"Loading...";
        hud.square = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMenuItemsTouchEvents];
    // Do any additional setup after loading the view from its nib.
}
-(void)setupMenuItemsTouchEvents
{
    UITapGestureRecognizer *tapOnFBView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayFBDialog:)] ;
    tapOnFBView.numberOfTapsRequired=1;
    [self.facebookView addGestureRecognizer:tapOnFBView];
    
    UITapGestureRecognizer *tapOnTWView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayTWDialog:)] ;
    tapOnTWView.numberOfTapsRequired=1;
    [self.twitterView addGestureRecognizer:tapOnTWView];
    
    
    
}
-(void)twitterSheet
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if (self.initialText) {
            [controller setInitialText:self.initialText];
        }
       
        if ([self.delegate isKindOfClass:[ISReportDetailsViewController class]]) {
            self.imageToshare=[(ISReportDetailsViewController*)self.delegate imageToShare];
        }
        else if ([self.delegate isKindOfClass:[ISStatisticsViewController class]])
        {
            self.imageToshare=[(ISStatisticsViewController*)self.delegate imageToShare];
        }
        if (self.imageToshare) {
            
        
            
            [controller addImage:self.imageToshare];
        }
        
        
        [self.delegate presentViewController:controller animated:YES completion:nil];
        
    }
    else
    {
        [ILAlertView showWithTitle:@"No Twitter Account Found" message:@"Go to Settings and add a Twitter Account" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    }
    
    [self clearData];
}

-(void)facebookSheet
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if (self.initialText) {
            [controller setInitialText:self.initialText];
        }
        if ([self.delegate isKindOfClass:[ISReportDetailsViewController class]]) {
            self.imageToshare=[(ISReportDetailsViewController*)self.delegate imageToShare];
        }
        else if ([self.delegate isKindOfClass:[ISStatisticsViewController class]])
        {
            self.imageToshare=[(ISStatisticsViewController*)self.delegate imageToShare];
        }
        if (self.imageToshare) {
            
            [controller addImage:self.imageToshare];
        }
        
        
        //            controller.completionHandler = ^(SLComposeViewControllerResult result) {
        //                switch(result) {
        //                        //  This means the user cancelled without sending the Tweet
        //                    case SLComposeViewControllerResultCancelled:
        //                        break;
        //                    case SLComposeViewControllerResultDone:
        //
        //                        [ILAlertView showWithTitle:@"Success" message:@"Status Update Successful" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
        //
        //                        break;
        //                }
        //
        //
        //            };
        
        
        [self.delegate presentViewController:controller animated:YES completion:Nil];
        
    }
    else
    {
        [ILAlertView showWithTitle:@"No Facebook Account Found" message:@"Go to Settings and add a Facebook Account" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    }
    [self clearData];
}

- (void)displayFBDialog:(id)sender {
    
    [self.popover dismissPopoverAnimated:YES];
    [hud show:YES];
    [self performSelector:@selector(facebookSheet) withObject:nil afterDelay:0.3];
    // [self facebookSheet];
    [hud hide:YES];
    

    
    
}
- (void)displayTWDialog:(id)sender {
     [self.popover dismissPopoverAnimated:YES];
    //[hud showWhileExecuting:@selector(twitterSheet) onTarget:self withObject:nil animated:YES];
    [hud show:YES];
    [self performSelector:@selector(twitterSheet) withObject:nil afterDelay:0.3];
    //[self twitterSheet];
    [hud hide:YES];
    
}


-(void)clearData
{
    self.imageToshare=nil;
    self.initialText=nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
