//
//  ISPlayListViewController.h
//  Fitness
//
//  Created by ispluser on 3/13/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol MusicTableViewControllerDelegate; // forward declaration


@interface ISPlayListViewController : UITableViewController <MPMediaPickerControllerDelegate, UITableViewDelegate> {
    
	id <MusicTableViewControllerDelegate>	__weak delegate;
	
}

@property (nonatomic, weak) id <MusicTableViewControllerDelegate>	delegate;

- (IBAction) showMediaPicker: (id) sender;
- (IBAction) goBack: (id) sender;

@end



@protocol MusicTableViewControllerDelegate

// implemented in MainViewController.m
- (void) musicTableViewControllerDidFinish: (ISPlayListViewController *) controller;
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;
- (void) updatePlayerAfterDeleteQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;

@end



