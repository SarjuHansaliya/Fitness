//
//  ISMusicController.m
//  RNFrostedSidebar
//
//  Created by ispluser on 3/11/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import "ISMusicController.h"
#import <Foundation/Foundation.h>
#import "ViewController.h"

#pragma mark Audio session callbacks_______________________

// Audio session callback function for responding to audio route changes. If playing
//		back application audio when the headset is unplugged, this callback pauses
//		playback and displays an alert that allows the user to resume or stop playback.
//
//		The system takes care of iPod audio pausing during route changes--this callback
//		is not involved with pausing playback of iPod audio.
void audioRouteChangeListenerCallback (
                                       void                      *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueSize,
                                       const void                *inPropertyValue
                                       ) {
	
	// ensure that this callback was invoked for a route change
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
	// This callback, being outside the implementation block, needs a reference to the
	//		MainViewController object, which it receives in the inUserData parameter.
	//		You provide this reference when registering this callback (see the call to
	//		AudioSessionAddPropertyListener).
	ISMusicController *controller = (__bridge ISMusicController *) inUserData;
	
	// if application sound is not playing, there's nothing to do, so return.
	if (controller.appSoundPlayer.playing == 0 ) {
        
		NSLog (@"Audio route change while application audio is stopped.");
		return;
		
	} else {
        
		// Determines the reason for the route change, to ensure that it is not
		//		because of a category change.
		CFDictionaryRef	routeChangeDictionary = inPropertyValue;
		
		CFNumberRef routeChangeReasonRef =
        CFDictionaryGetValue (
                              routeChangeDictionary,
                              CFSTR (kAudioSession_AudioRouteChangeKey_Reason)
                              );
        
		SInt32 routeChangeReason;
		
		CFNumberGetValue (
                          routeChangeReasonRef,
                          kCFNumberSInt32Type,
                          &routeChangeReason
                          );
		
		// "Old device unavailable" indicates that a headset was unplugged, or that the
		//	device was removed from a dock connector that supports audio output. This is
		//	the recommended test for when to pause audio.
		if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            
			[controller.appSoundPlayer pause];
			NSLog (@"Output device removed, so application audio was paused.");
            
			UIAlertView *routeChangeAlertView =
            [[UIAlertView alloc]	initWithTitle: NSLocalizedString (@"Playback Paused", @"Title for audio hardware route-changed alert view")
                                       message: NSLocalizedString (@"Audio output was changed", @"Explanation for route-changed alert view")
                                      delegate: controller
                             cancelButtonTitle: NSLocalizedString (@"StopPlaybackAfterRouteChange", @"Stop button title")
                             otherButtonTitles: NSLocalizedString (@"ResumePlaybackAfterRouteChange", @"Play button title"), nil];
			[routeChangeAlertView show];
			// release takes place in alertView:clickedButtonAtIndex: method
            
		} else {
            
			NSLog (@"A route change occurred that does not require pausing of application audio.");
		}
	}
}


@implementation ISMusicController







@synthesize artworkItem;				// the now-playing media item's artwork image, displayed in the Navigation bar
@synthesize userMediaItemCollection;	// the media item collection created by the user, using the media item picker
@synthesize playBarButton;				// the button for invoking Play on the music player
@synthesize pauseBarButton;				// the button for invoking Pause on the music player
@synthesize musicPlayer;				// the music player, which plays media items from the iPod library
@synthesize navigationBar;				// the application's Navigation bar
@synthesize noArtworkImage;				// an image to display when a media item has no associated artwork
@synthesize backgroundColorTimer;		// a timer for changing the background color -- represents an application that is
//		doing something else while iPod music is playing
@synthesize nowPlayingLabel;			// descriptive text shown on the main screen about the now-playing media item
@synthesize appSoundButton;				// the button to invoke playback for the application sound
@synthesize addOrShowMusicButton;		// the button for invoking the media item picker. if the user has already
//		specified a media item collection, the title changes to "Show Music" and
//		the button invokes a table view that shows the specified collection
@synthesize appSoundPlayer;				// An AVAudioPlayer object for playing application sound
@synthesize soundFileURL;				// The path to the application sound
@synthesize interruptedOnPlayback;		// A flag indicating whether or not the application was interrupted during
//		application audio playback
@synthesize playedMusicOnce;			// A flag indicating if the user has played iPod library music at least one time
//		since application launch.
@synthesize playing;					// An application that responds to interruptions must keep track of its playing/
//		not-playing state.

#pragma mark Music control________________________________

// A toggle control for playing or pausing iPod library music playback, invoked
//		when the user taps the 'playBarButton' in the Navigation bar.
- (IBAction)prevSong:(id)sender {
    
    if (userMediaItemCollection && [[userMediaItemCollection items]count]>0) {
        
        if ([musicPlayer currentPlaybackTime]>=2.0) {
            [musicPlayer skipToBeginning];
        }
        else
        {
            if ([musicPlayer indexOfNowPlayingItem]==0) {
                [musicPlayer setNowPlayingItem:[[self.userMediaItemCollection items] lastObject]];
            }
            else
            {
                [musicPlayer skipToPreviousItem];
            }
        }
    }
}

- (IBAction)nextSong:(id)sender {
    if (userMediaItemCollection && [[userMediaItemCollection items]count]>0) {
        
        if ([musicPlayer indexOfNowPlayingItem]==([self.userMediaItemCollection count]-1)) {
            [musicPlayer setNowPlayingItem:[[self.userMediaItemCollection items] objectAtIndex:0]];
        }
        else
        {
            [musicPlayer skipToNextItem];
        }
    }
}

- (IBAction) playOrPauseMusic: (id)sender {
    
	MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    
	if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
		[musicPlayer play];
       // [(ViewController*)self.delegate playerIsPlaying:YES];
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
		[musicPlayer pause];
      //  [(ViewController*)self.delegate playerIsPlaying:NO];
	}
}

// If there is no selected media item collection, display the media item picker. If there's
// already a selected collection, display the list of selected songs.
- (IBAction) AddMusicOrShowMusic: (id) sender {
    
	// if the user has already chosen some music, display that list
	if (userMediaItemCollection) {
        
		MusicTableViewController *controller = [[MusicTableViewController alloc] initWithNibName: @"MusicTableView" bundle: nil];
		controller.delegate = self;
		
		controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		
		[self.delegate presentModalViewController: controller animated: YES];
        
        // else, if no music is chosen yet, display the media item picker
	} else {
        
		MPMediaPickerController *picker =
        [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
		
		picker.delegate						= self;
		picker.allowsPickingMultipleItems	= YES;
		picker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
		
		// The media item picker uses the default UI style, so it needs a default-style
		//		status bar to match it visually
		[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
        
        [self.delegate presentModalViewController: picker animated: YES];
	}
}


// Invoked by the delegate of the media item picker when the user is finished picking music.
//		The delegate is either this class or the table view controller, depending on the
//		state of the application.
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection  {
    
	// Configure the music player, but only if the user chose at least one song to play
	if (mediaItemCollection) {
        
		// If there's no playback queue yet...
		if (userMediaItemCollection == nil) {
            
			// apply the new media item collection as a playback queue for the music player
			[self setUserMediaItemCollection: mediaItemCollection];
			[musicPlayer setQueueWithItemCollection: userMediaItemCollection];
			[self setPlayedMusicOnce: YES];
			[musicPlayer play];
           // [(ViewController*)self.delegate playerIsPlaying:YES];
            
            
            
            // Obtain the music player's state so it can then be
            //		restored after updating the playback queue.
		} else {
            
			// Take note of whether or not the music player is playing. If it is
			//		it needs to be started again at the end of this method.
			BOOL wasPlaying = NO;
			if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
				wasPlaying = YES;
			}
			
			// Save the now-playing item and its current playback time.
			MPMediaItem *nowPlayingItem			= musicPlayer.nowPlayingItem;
			NSTimeInterval currentPlaybackTime	= musicPlayer.currentPlaybackTime;
            
			// Combine the previously-existing media item collection with the new one
			NSMutableArray *combinedMediaItems	= [[userMediaItemCollection items] mutableCopy];
			NSArray *newMediaItems				= [mediaItemCollection items];
			[combinedMediaItems addObjectsFromArray: newMediaItems];
			
			[self setUserMediaItemCollection: [MPMediaItemCollection collectionWithItems: (NSArray *) combinedMediaItems]];
            
			// Apply the new media item collection as a playback queue for the music player.
			[musicPlayer setQueueWithItemCollection: userMediaItemCollection];
			
			// Restore the now-playing item and its current playback time.
            
            musicPlayer.nowPlayingItem			= nowPlayingItem;
            musicPlayer.currentPlaybackTime		= currentPlaybackTime;
            
            if (wasPlaying) {
                [musicPlayer play];
               // [(ViewController*)self.delegate playerIsPlaying:YES];
            }
			
			// If the music player was playing, get it playing again.
			
		}
        
		// Finally, because the music player now has a playback queue, ensure that
		//		the music play/pause button in the Navigation bar is enabled.
		navigationBar.topItem.leftBarButtonItem.enabled = YES;
        
		[addOrShowMusicButton	setTitle: NSLocalizedString (@"Show Music", @"Alternate title for 'Add Music' button, after user has chosen some music")
                              forState: UIControlStateNormal];
	}
}
- (void) updatePlayerAfterDeleteQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection  {
    
	// Configure the music player, but only if the user chose at least one song to play
	if ([[mediaItemCollection items]count]>0 && mediaItemCollection) {
        
		// If there's no playback queue yet...
		if (userMediaItemCollection == nil) {
            
			// apply the new media item collection as a playback queue for the music player
			[self setUserMediaItemCollection: mediaItemCollection];
			[musicPlayer setQueueWithItemCollection: userMediaItemCollection];
			[self setPlayedMusicOnce: YES];
			[musicPlayer play];
           // [(ViewController*)self.delegate playerIsPlaying:YES];
            // Obtain the music player's state so it can then be
            //		restored after updating the playback queue.
		} else {
            
			// Take note of whether or not the music player is playing. If it is
			//		it needs to be started again at the end of this method.
			BOOL wasPlaying = NO;
			if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
				wasPlaying = YES;
			}
			
			// Save the now-playing item and its current playback time.
			MPMediaItem *nowPlayingItem			= musicPlayer.nowPlayingItem;
			NSTimeInterval currentPlaybackTime	= musicPlayer.currentPlaybackTime;
            
			// Combine the previously-existing media item collection with the new one
            //			NSMutableArray *combinedMediaItems	= [NSMutableArray arrayWithCapacity:1];
            //			NSArray *newMediaItems				= [mediaItemCollection items];
            //			[combinedMediaItems addObjectsFromArray: newMediaItems];
			
			[self setUserMediaItemCollection: [MPMediaItemCollection collectionWithItems:mediaItemCollection.items]];
            
			// Apply the new media item collection as a playback queue for the music player.
			[musicPlayer setQueueWithItemCollection: userMediaItemCollection];
			
			// Restore the now-playing item and its current playback time.
            if ([[mediaItemCollection items] containsObject:nowPlayingItem]) {
                musicPlayer.nowPlayingItem			= nowPlayingItem;
                musicPlayer.currentPlaybackTime		= currentPlaybackTime;
                if (wasPlaying) {
                    [musicPlayer play];
                   // [(ViewController*)self.delegate playerIsPlaying:YES];
                }
            }
            else if (wasPlaying)
            {
                [self nextSong:nil];
            }
			
			
			// If the music player was playing, get it playing again.
			
		}
        
		// Finally, because the music player now has a playback queue, ensure that
		//		the music play/pause button in the Navigation bar is enabled.
		navigationBar.topItem.leftBarButtonItem.enabled = YES;
        
		[addOrShowMusicButton	setTitle: NSLocalizedString (@"Show Music", @"Alternate title for 'Add Music' button, after user has chosen some music")
                              forState: UIControlStateNormal];
	}
    else
    {
        [self setUserMediaItemCollection: [MPMediaItemCollection collectionWithItems:@[]]];
        [musicPlayer setQueueWithItemCollection: userMediaItemCollection];
        [musicPlayer stop];
       // [(ViewController*)self.delegate playerIsPlaying:NO];
    }
}

// If the music player was paused, leave it paused. If it was playing, it will continue to
//		play on its own. The music player state is "stopped" only if the previous list of songs
//		had finished or if this is the first time the user has chosen songs after app
//		launch--in which case, invoke play.
- (void) restorePlaybackState {
    
	if (musicPlayer.playbackState == MPMusicPlaybackStateStopped && userMediaItemCollection) {
        
		[addOrShowMusicButton	setTitle: NSLocalizedString (@"Show Music", @"Alternate title for 'Add Music' button, after user has chosen some music")
                              forState: UIControlStateNormal];
		
		if (playedMusicOnce == NO) {
            
			[self setPlayedMusicOnce: YES];
			[musicPlayer play];
           // [(ViewController*)self.delegate playerIsPlaying:YES];
		}
	}
    
}



#pragma mark Media item picker delegate methods________

// Invoked when the user taps the Done button in the media item picker after having chosen
//		one or more media items to play.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
	// Dismiss the media item picker.
	
	[self.delegate dismissModalViewControllerAnimated: YES];
	// Apply the chosen songs to the music player's queue.
	[self updatePlayerQueueWithMediaCollection: mediaItemCollection];
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
}

// Invoked when the user taps the Done button in the media item picker having chosen zero
//		media items to play
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	
	[self.delegate dismissModalViewControllerAnimated: YES];
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
}



#pragma mark Music notification handlers__________________

// When the now-playing item changes, update the media item artwork and the now-playing label.
- (void) handle_NowPlayingItemChanged: (id) notification {
    
	MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
	
	// Assume that there is no artwork for the media item.
	UIImage *artworkImage = noArtworkImage;
    
	
	// Get the artwork from the current media item, if it has artwork.
	MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
	
	// Obtain a UIImage object from the MPMediaItemArtwork object
	if (artwork) {
		artworkImage = [artwork imageWithSize: CGSizeMake (30, 30)];
	}
    

	// Obtain a UIButton object and set its background to the UIImage object
	UIButton *artworkView = [[UIButton alloc] initWithFrame: CGRectMake (0, 0, 30, 30)];
	[artworkView setBackgroundImage: artworkImage forState: UIControlStateNormal];
    
	// Obtain a UIBarButtonItem object and initialize it with the UIButton object
	UIBarButtonItem *newArtworkItem = [[UIBarButtonItem alloc] initWithCustomView: artworkView];
	[self setArtworkItem: newArtworkItem];
	
	[artworkItem setEnabled: NO];
	
	// Display the new media item artwork
	[navigationBar.topItem setRightBarButtonItem: artworkItem animated: YES];
	
	// Display the artist and song name for the now-playing media item
	[nowPlayingLabel setText: [
                               NSString stringWithFormat: @"%@ %@ %@ %@",
                               NSLocalizedString (@"Now Playing:", @"Label for introducing the now-playing song title and artist"),
                               [currentItem valueForProperty: MPMediaItemPropertyTitle],
                               NSLocalizedString (@"by", @"Article between song name and artist name"),
                               [currentItem valueForProperty: MPMediaItemPropertyArtist]]];
    
	if (musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
		// Provide a suitable prompt to the user now that their chosen music has
		//		finished playing.
		[nowPlayingLabel setText: [
                                   NSString stringWithFormat: @"%@",
                                   NSLocalizedString (@"Music-ended Instructions", @"Label for prompting user to play music again after it has stopped")]];
        
	}
    
    [(ViewController*)self.delegate setArtworkImage:artworkImage];
}

// When the playback state changes, set the play/pause button in the Navigation bar
//		appropriately.
- (void) handle_PlaybackStateChanged: (id) notification {
    
	MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStatePaused) {
        
        [(ViewController *)self.delegate playerIsPlaying:NO];
		
		
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
        
		[(ViewController *)self.delegate playerIsPlaying:YES];
        
	} else if (playbackState == MPMusicPlaybackStateStopped) {
        
		[musicPlayer stop];
        [(ViewController*)self.delegate playerIsPlaying:NO];
        
	}
}

- (void) handle_iPodLibraryChanged: (id) notification {
    
	// Implement this method to update cached collections of media items when the
	// user performs a sync while your application is running. This sample performs
	// no explicit media queries, so there is nothing to update.
}



#pragma mark Application playback control_________________

- (IBAction) playAppSound: (id) sender {
    
	[appSoundPlayer play];
	playing = YES;
	[appSoundButton setEnabled: NO];
}

// delegate method for the audio route change alert view; follows the protocol specified
//	in the UIAlertViewDelegate protocol.
- (void) alertView: routeChangeAlertView clickedButtonAtIndex: buttonIndex {
    
	if ((NSInteger) buttonIndex == 1) {
		[appSoundPlayer play];
	} else {
		[appSoundPlayer setCurrentTime: 0];
		[appSoundButton setEnabled: YES];
	}
	
}



#pragma mark AV Foundation delegate methods____________

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer successfully: (BOOL) flag {
    
    
	playing = NO;
	[appSoundButton setEnabled: YES];
}

- (void) audioPlayerBeginInterruption: player {
    
	NSLog (@"Interrupted. The system has paused audio playback.");
	
	if (playing) {
        
		playing = NO;
		interruptedOnPlayback = YES;
	}
}

- (void) audioPlayerEndInterruption: player {
    
	NSLog (@"Interruption ended. Resuming audio playback.");
	
	// Reactivates the audio session, whether or not audio was playing
	//		when the interruption arrived.
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	
	if (interruptedOnPlayback) {
        
		[appSoundPlayer prepareToPlay];
		[appSoundPlayer play];
		playing = YES;
		interruptedOnPlayback = NO;
	}
}



#pragma mark Table view delegate methods________________

// Invoked when the user taps the Done button in the table view.
- (void) musicTableViewControllerDidFinish: (MusicTableViewController *) controller {
	
    [self.delegate dismissModalViewControllerAnimated: YES];
	[self restorePlaybackState];
}



#pragma mark Application setup____________________________

#if TARGET_IPHONE_SIMULATOR
#warning *** Simulator mode: iPod library access works only when running on a device.
#endif




// To learn about notifications, see "Notifications" in Cocoa Fundamentals Guide.
- (void) registerForMediaPlayerNotifications {
    
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_NowPlayingItemChanged:)
							   name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
							 object: musicPlayer];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged:)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: musicPlayer];
    
    /*
     // This sample doesn't use libray change notifications; this code is here to show how
     //		it's done if you need it.
     [notificationCenter addObserver: self
     selector: @selector (handle_iPodLibraryChanged:)
     name: MPMediaLibraryDidChangeNotification
     object: musicPlayer];
     
     [[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
     */
    
	[musicPlayer beginGeneratingPlaybackNotifications];
}


// To learn about the Settings bundle and user preferences, see User Defaults Programming Topics
//		for Cocoa and "The Settings Bundle" in iPhone Application Programming Guide

// Returns whether or not to use the iPod music player instead of the application music player.
- (BOOL) useiPodPlayer {
    
    //	if ([[NSUserDefaults standardUserDefaults] boolForKey: PLAYER_TYPE_PREF_KEY]) {
    //		return YES;
    //	} else {
    //		return NO;
    //	}
	return YES;
}

// Configure the application.
- (void) initialize {
    
    
	
	[self setPlayedMusicOnce: NO];
    
	[self setNoArtworkImage:	[UIImage imageNamed: @"artwork.jpeg"]];
    
	[self setPlayBarButton:		[[UIBarButtonItem alloc]	initWithBarButtonSystemItem: UIBarButtonSystemItemPlay
                                                                           target: self
                                                                           action: @selector (playOrPauseMusic:)]];
    
	[self setPauseBarButton:	[[UIBarButtonItem alloc]	initWithBarButtonSystemItem: UIBarButtonSystemItemPause
                                                                           target: self
                                                                           action: @selector (playOrPauseMusic:)]];
    
	[addOrShowMusicButton	setTitle: NSLocalizedString (@"Add Music", @"Title for 'Add Music' button, before user has chosen some music")
                          forState: UIControlStateNormal];
    
	[appSoundButton			setTitle: NSLocalizedString (@"Play App Sound", @"Title for 'Play App Sound' button")
                      forState: UIControlStateNormal];
    
	[nowPlayingLabel setText: NSLocalizedString (@"Instructions", @"Brief instructions to user, shown at launch")];
	
	// Instantiate the music player. If you specied the iPod music player in the Settings app,
	//		honor the current state of the built-in iPod app.
	if ([self useiPodPlayer]) {
        
		[self setMusicPlayer: [MPMusicPlayerController iPodMusicPlayer]];
		
		if ([musicPlayer nowPlayingItem]) {
            
			navigationBar.topItem.leftBarButtonItem.enabled = YES;
			
			// Update the UI to reflect the now-playing item.
			[self handle_NowPlayingItemChanged: nil];
			
			if ([musicPlayer playbackState] == MPMusicPlaybackStatePaused) {
				navigationBar.topItem.leftBarButtonItem = playBarButton;
			}
		}
		
	} else {
        
		[self setMusicPlayer: [MPMusicPlayerController applicationMusicPlayer]];
		
		// By default, an application music player takes on the shuffle and repeat modes
		//		of the built-in iPod app. Here they are both turned off.
		[musicPlayer setShuffleMode: MPMusicShuffleModeOff];
		[musicPlayer setRepeatMode: MPMusicRepeatModeNone];
	}
    
	[self registerForMediaPlayerNotifications];
    
	
}





- (void)dealloc {
    
    /*
     // This sample doesn't use libray change notifications; this code is here to show how
     //		it's done if you need it.
     [[NSNotificationCenter defaultCenter] removeObserver: self
     name: MPMediaLibraryDidChangeNotification
     object: musicPlayer];
     
     [[MPMediaLibrary defaultMediaLibrary] endGeneratingLibraryChangeNotifications];
     
     */
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: musicPlayer];
    
	[musicPlayer endGeneratingPlaybackNotifications];
    
	[backgroundColorTimer		invalidate];
    
}

@end
