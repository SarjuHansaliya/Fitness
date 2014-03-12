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
#import "flite.h"


cst_voice *register_cmu_us_rms();
cst_wave *sound;
cst_voice *voice;


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
{
    float volumeMusicPlayer;
    BOOL wasMusicPlayerPlaying;
    NSString *remainingTextToSpeech;
}

@synthesize userMediaItemCollection;	// the media item collection created by the user, using the media item picker

@synthesize musicPlayer;				// the music player, which plays media items from the iPod library

@synthesize noArtworkImage;				// an image to display when a media item has no associated artwork



//		specified a media item collection, the title changes to "Show Music" and
//		the button invokes a table view that shows the specified collection
@synthesize appSoundPlayer;				// An AVAudioPlayer object for playing application sound

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
               
            }
			
			
		}
        
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
        
		
	}
    else
    {
        [self setUserMediaItemCollection: [MPMediaItemCollection collectionWithItems:@[]]];
        [musicPlayer setQueueWithItemCollection: userMediaItemCollection];
        [musicPlayer stop];
    }
}

// If the music player was paused, leave it paused. If it was playing, it will continue to
//		play on its own. The music player state is "stopped" only if the previous list of songs
//		had finished or if this is the first time the user has chosen songs after app
//		launch--in which case, invoke play.
- (void) restorePlaybackState {
    
	if (musicPlayer.playbackState == MPMusicPlaybackStateStopped && userMediaItemCollection) {
        
		if (playedMusicOnce == NO) {
			[self setPlayedMusicOnce: YES];
			[musicPlayer play];
            [(ViewController*)self.delegate playerIsPlaying:YES];
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
	
	UIImage *artworkImage = noArtworkImage;
    
	
	// Get the artwork from the current media item, if it has artwork.
	MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
	
	// Obtain a UIImage object from the MPMediaItemArtwork object
	if (artwork) {
		artworkImage = [artwork imageWithSize: CGSizeMake (30, 30)];
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
        
		//[musicPlayer stop];
        [(ViewController*)self.delegate playerIsPlaying:NO];
        
	}
    
}

- (void) handle_iPodLibraryChanged: (id) notification {
    
	// Implement this method to update cached collections of media items when the
	// user performs a sync while your application is running. This sample performs
	// no explicit media queries, so there is nothing to update.
}



#pragma mark Application playback control_________________


// delegate method for the audio route change alert view; follows the protocol specified
//	in the UIAlertViewDelegate protocol.
- (void) alertView: routeChangeAlertView clickedButtonAtIndex: buttonIndex {
    
	if ((NSInteger) buttonIndex == 1) {
		[appSoundPlayer play];
	} else {
		[appSoundPlayer setCurrentTime: 0];
	}
	
}



#pragma mark AV Foundation delegate methods____________

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer1 successfully: (BOOL) flag {
    
	playing = NO;
    [[AVAudioSession sharedInstance] setActive: NO error:nil];
    
    if (wasMusicPlayerPlaying) {
        [musicPlayer play];
    }
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
    //[musicPlayer play];
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



// Configure the application.
- (void) initialize {
    
	voice = register_cmu_us_rms();
	[self setPlayedMusicOnce: NO];
    [self setupApplicationAudio];
    
	[self setNoArtworkImage:	[UIImage imageNamed: @"artwork.jpeg"]];
    
    [self setMusicPlayer: [MPMusicPlayerController iPodMusicPlayer]];
    
    if ([musicPlayer nowPlayingItem]) {
        [self handle_NowPlayingItemChanged: nil];
        
    }
	[self registerForMediaPlayerNotifications];
    playing=NO;
    
	
}
//------------------------------voice assistance
//

- (void) setupApplicationAudio {
	
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers  error: nil];
    
//	UInt32 doSetProperty = 0;
//	AudioSessionSetProperty (
//                             kAudioSessionProperty_OverrideCategoryMixWithOthers,
//                             sizeof (doSetProperty),
//                             &doSetProperty
//                             );

	// Registers the audio route change listener callback function
	AudioSessionAddPropertyListener (
                                     kAudioSessionProperty_AudioRouteChange,
                                     audioRouteChangeListenerCallback,
                                     (__bridge void *)(self)
                                     );
    
	
    
}

-(void)speakText:(NSString *)text
{
    
	NSMutableString *cleanString;
	cleanString = [NSMutableString stringWithString:@""];
	if([text length] > 1)
	{
		int x = 0;
		while (x < [text length])
		{
			unichar ch = [text characterAtIndex:x];
			[cleanString appendFormat:@"%c", ch];
			x++;
		}
	}
	if(cleanString == nil)
	{	// string is empty
		cleanString = [NSMutableString stringWithString:@""];
	}
	sound = flite_text_to_wave([cleanString UTF8String], voice);
	NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *recordingDirectory = [filePaths objectAtIndex: 0];
	// Pick a file name
	NSString *tempFilePath = [NSString stringWithFormat: @"%@/%s", recordingDirectory, "temp.wav"];
	// save wave to disk
	char *path;
	path = (char*)[tempFilePath UTF8String];
	cst_wave_save_riff(sound, path);
	// Play the sound back.
	NSError *err;
	[appSoundPlayer stop];
	appSoundPlayer =  [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:tempFilePath] error:&err];
    [appSoundPlayer setDelegate:self];
	//[appSoundPlayer prepareToPlay];
    wasMusicPlayerPlaying=NO;
    if ([musicPlayer playbackState]==MPMusicPlaybackStatePlaying) {
        wasMusicPlayerPlaying=YES;
        [musicPlayer pause];
    }
    BOOL soundPlayed=YES;
    playing = YES;
    // Activates the audio session.
	
	NSError *activationError = nil;
	[[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    soundPlayed =[appSoundPlayer play];
   
    if (!soundPlayed) {
        
        [self audioPlayerDidFinishPlaying:appSoundPlayer successfully:soundPlayed];
    }
    
	// Remove file
	[[NSFileManager defaultManager] removeItemAtPath:tempFilePath error:nil];
	delete_wave(sound);
	
}

-(void)setPitch:(float)pitch variance:(float)variance speed:(float)speed
{
	feat_set_float(voice->features,"int_f0_target_mean", pitch);
	feat_set_float(voice->features,"int_f0_target_stddev",variance);
	feat_set_float(voice->features,"duration_stretch",speed);
}

-(void)stopTalking
{
	[appSoundPlayer stop];
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
    
	
}

@end
