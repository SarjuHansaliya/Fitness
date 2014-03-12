//
//  ViewController.m
//  RNFrostedSidebar
//
//  Created by Ryan Nystrom on 8/13/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#import "ViewController.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define ARTWORK_ITEM 0
#define PREVIOUS_ITEM 1
#define PLAY_ITEM 2
#define NEXT_ITEM 3
#define ADD_ITEM 4



@interface ViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation ViewController
{
    RNFrostedSidebar *callout;
    BOOL visible;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.musicController=[[ISMusicController alloc]init];
        [self.musicController initialize];
        [self.musicController setDelegate:self];
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:2];
    [self setupCallout];
   
}

-(void)setupCallout
{
    NSArray *images = @[
                        [UIImage imageNamed:@"artwork.jpeg"],
                        [UIImage imageNamed:@"prev.png"],
                        [UIImage imageNamed:@"play.png"],
                        [UIImage imageNamed:@"next.png"],
                        [UIImage imageNamed:@"add.png"]
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1]
                        ];
    

    callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    callout.delegate = self;
    callout.showFromRight = YES;
    visible=NO;
    
}

-(void)playerIsPlaying:(BOOL)b
{
    [callout.actionButtonImageView setHighlighted:b];
}

-(void)setArtworkImage:(UIImage*)img
{
    [callout.artworkImageView setImage:img];
}

- (IBAction)onBurger:(id)sender {
    
    
    if (!visible) {
        [callout showInViewController:self animated:YES];
    }
    else
    {
        [callout dismissAnimated:YES];
    }
}
- (void)sidebar:(RNFrostedSidebar *)sidebar didShowOnScreenAnimated:(BOOL)animatedYesOrNo
{
    visible=YES;
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didDismissFromScreenAnimated:(BOOL)animatedYesOrNo
{
    visible=NO;
}


#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
   // NSLog(@"Tapped item at index %i",index);
    switch (index) {
        case ARTWORK_ITEM:
            
            break;
        case PREVIOUS_ITEM:
            [self.musicController prevSong:nil];
            break;
        case PLAY_ITEM:
            [self.musicController playOrPauseMusic:nil];
            break;
        case NEXT_ITEM:
            [self.musicController nextSong:nil];
            break;
        case ADD_ITEM:
             [callout dismissAnimated:YES];
            [self.musicController AddMusicOrShowMusic:nil];
            break;
            
        default:
            break;
    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
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
    
    
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 20, 200, 80)];
    [backView setBackgroundColor:[UIColor greenColor]];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 27)];
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Dashboard";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    
    [backView addSubview:titleLable];
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    //self.navigationController.navigationBarHidden=YES;
    self.title=@"Dashboard";
    
    
    UIButton *addButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButtonCustom setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [addButtonCustom addTarget:self action:@selector(onBurger:) forControlEvents:UIControlEventTouchUpInside];
    [addButtonCustom setImage:[UIImage imageNamed:@"music.png"] forState:UIControlStateNormal];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:addButtonCustom];
    
    // [backButton setTintColor: [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1]];
   [self.navigationItem setRightBarButtonItem:addButton];
    //[self.navigationItem.backBarButtonItem setImage:backImage];
    
}

@end
