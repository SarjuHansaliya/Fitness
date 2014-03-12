//
//  ISMusicController.h
//  RNFrostedSidebar
//
//  Created by ispluser on 3/11/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MusicTableViewController.h"


@interface ISMusicController : NSObject <MPMediaPickerControllerDelegate, MusicTableViewControllerDelegate, AVAudioPlayerDelegate>
{
	IBOutlet UIBarButtonItem	*artworkItem;
	IBOutlet UINavigationBar	*navigationBar;
	IBOutlet UILabel			*nowPlayingLabel;
	BOOL						playedMusicOnce;
    
	AVAudioPlayer				*appSoundPlayer;
	NSURL						*soundFileURL;
	IBOutlet UIButton			*appSoundButton;
	IBOutlet UIButton			*addOrShowMusicButton;
	BOOL						interruptedOnPlayback;
	BOOL						playing ;
    
	UIBarButtonItem				*playBarButton;
	UIBarButtonItem				*pauseBarButton;
	MPMusicPlayerController		*musicPlayer;
	MPMediaItemCollection		*userMediaItemCollection;
	UIImage						*noArtworkImage;
	NSTimer						*backgroundColorTimer;
}

@property id delegate;
@property (nonatomic, strong)	UIBarButtonItem			*artworkItem;
@property (nonatomic, strong)	UINavigationBar			*navigationBar;
@property (nonatomic, strong)	UILabel					*nowPlayingLabel;
@property (readwrite)			BOOL					playedMusicOnce;

@property (nonatomic, strong)	UIBarButtonItem			*playBarButton;
@property (nonatomic, strong)	UIBarButtonItem			*pauseBarButton;
@property (nonatomic, strong)	MPMediaItemCollection	*userMediaItemCollection;
@property (nonatomic, strong)	MPMusicPlayerController	*musicPlayer;
@property (nonatomic, strong)	UIImage					*noArtworkImage;
@property (nonatomic, strong)	NSTimer					*backgroundColorTimer;

@property (nonatomic, strong)	AVAudioPlayer			*appSoundPlayer;
@property (nonatomic, strong)	NSURL					*soundFileURL;
@property (nonatomic, strong)	IBOutlet UIButton		*appSoundButton;
@property (nonatomic, strong)	IBOutlet UIButton		*addOrShowMusicButton;
@property (readwrite)			BOOL					interruptedOnPlayback;
@property (readwrite)			BOOL					playing;
- (IBAction)prevSong:(id)sender;
- (IBAction)nextSong:(id)sender;
- (void) initialize;
- (IBAction)	playOrPauseMusic:		(id) sender;
- (IBAction)	AddMusicOrShowMusic:	(id) sender;
- (IBAction)	playAppSound:			(id) sender;

- (BOOL) useiPodPlayer;




@end
