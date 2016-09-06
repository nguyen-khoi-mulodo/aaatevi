#import "PlayerViewController.h"
#import "PlayerDetailView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DBHelper.h"
#import "F3BarGauge.h"
#import "ParserObject.h"

#define PlayerContinueNotification @"PlayerContinueNotification"
#define PlayerHangingNotification @"PlayerHangingNotification"

@interface PlayerViewController ()
- (void)play:(id)sender;
- (void)pause:(id)sender;
- (void)initScrubberTimer;
- (void)showPlayButton;
- (void)showStopButton;
- (void)syncScrubber;
- (IBAction)beginScrubbing:(id)sender;
- (IBAction)scrub:(id)sender;
- (IBAction)endScrubbing:(id)sender;
- (BOOL)isScrubbing;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id)init;
- (void)dealloc;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)viewDidLoad;
- (void)viewWillDisappear:(BOOL)animated;
- (void)handleSwipe:(UISwipeGestureRecognizer*)gestureRecognizer;
- (void)syncPlayPauseButtons;
- (void)setURL:(NSURL*)URL;
- (NSURL*)URL;
- (void) showPlayerMenuFull:(BOOL) isFull;
- (void) changeQuanlity;
@end

@interface PlayerViewController (Player)
- (void)removePlayerTimeObserver;
- (CMTime)playerItemDuration;
- (BOOL)isPlaying;
- (void)playerItemDidReachEnd:(NSNotification *)notification ;
- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
@end

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;
static void *AVPlaybackViewControllerCurrentItemKeepUpObservationContext = &AVPlaybackViewControllerCurrentItemKeepUpObservationContext;

#pragma mark -
@implementation PlayerViewController

@synthesize mPlayer, mPlayerItem, mPlaybackView, mPlayButton, mStopButton, mScrubber, mSvolume;
@synthesize delegate;
@synthesize lbDurationTime, lbTotalTime;

#pragma mark Asset URL

- (void)setURL:(NSURL*)URL 
{
//    [self.mPlayer replaceCurrentItemWithPlayerItem:nil];
    isStoped = NO;
    if (mURL != URL)
	{
		mURL = [URL copy];
        if (self.mPlayer && [self isPlaying]) {
            [self.mPlayer pause];
        }
        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset key "playable".
         */
        LOADING_ASSET = YES;
        [self showPlayButton];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mURL options:nil];
//        NSArray *requestedKeys = @[@"playable"];
        NSArray* requestedKeys = [NSArray arrayWithObjects:@"tracks", @"playable", nil];
    
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{		 
             dispatch_async( dispatch_get_main_queue(), 
                            ^{
                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                if (isStoped) {
                                    return;
                                }
                                if (![[mURL absoluteString] isEqualToString:asset.URL.absoluteString]) {
                                    return;
                                }
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
                            });
         }];
	}
}

- (NSURL*)URL
{
	return mURL;
}


#pragma mark -
#pragma mark Movie controller methods

#pragma mark
#pragma mark Button Action Methods

- (IBAction)play:(id)sender
{
	/* If we are at the end of the movie, we must seek to the beginning first
		before starting playback. */
    if (isStoped) {
        return;
    }
    
	if (YES == seekToZeroBeforePlay)
	{
		seekToZeroBeforePlay = NO;
        [self.mPlayer seekToTime:kCMTimeZero];
	}
	[self.mPlayer play];
    [self showStopButton];
}

- (IBAction)pause:(id)sender
{
	[self.mPlayer pause];
    [self showPlayButton];
}

-(void)stop{
    isStoped = YES;
    if (self.mPlayer && self.isPlaying) {
        [self.mPlayer pause];
    }
    [self.mScrubber setValue:0.0];
    [self disablePlayerButtons];
    [self disableScrubber];
    [self showStopButton];
    [self enableButtonQuality:NO];
}

- (BOOL) playing{
    return self.isPlaying;
}

- (IBAction) doNext:(id)sender{
    UIButton* btn = sender;
    if (btn == mNextButton) {
        if (self.indexCurrent < self.listVideos.count) {
            self.indexCurrent ++;
        }
    }else if(btn == mPrevButton){
        if (self.indexCurrent > 1) {
            self.indexCurrent --;
        }
    }
    if ([self.delegate respondsToSelector:@selector(chooseVideo:atIndex:)]) {
        Video* video = [self.listVideos objectAtIndex:self.indexCurrent - 1];
        [self.delegate showLoading:YES];
        [self.delegate chooseVideo:video atIndex:self.indexCurrent];
    }
}


#pragma mark -
#pragma mark Play, Stop buttons

/* Show the stop button in the movie player controller. */
-(void)showStopButton
{
//    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.mToolbar items]];
//    [toolbarItems replaceObjectAtIndex:0 withObject:self.mStopButton];
//    self.mToolbar.items = toolbarItems;
    [self.mPlayButton setHidden:YES];
    [self.mStopButton setHidden:NO];
}

/* Show the play button in the movie player controller. */
-(void)showPlayButton
{
//    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.mToolbar items]];
//    [toolbarItems replaceObjectAtIndex:0 withObject:self.mPlayButton];
//    self.mToolbar.items = toolbarItems;
    [self.mStopButton setHidden:YES];
    [self.mPlayButton setHidden:NO];
}

/* If the media is playing, show the stop button; otherwise, show the play button. */
- (void)syncPlayPauseButtons
{
	if ([self isPlaying])
	{
        [self showStopButton];
	}
	else
	{
        [self showPlayButton];
	}
}

-(void)enablePlayerButtons
{
    self.mPlayButton.enabled = YES;
    self.mStopButton.enabled = YES;
    mNextButton.enabled = (self.indexCurrent != self.listVideos.count);
    mPrevButton.enabled = (self.indexCurrent != 1);
    
}

-(void)disablePlayerButtons
{
    self.mPlayButton.enabled = NO;
    self.mStopButton.enabled = NO;
    mPrevButton.enabled = NO;
    mNextButton.enabled = NO;
    
}

#pragma mark -
#pragma mark Movie scrubber control

/* ---------------------------------------------------------
**  Methods to handle manipulation of the movie scrubber control
** ------------------------------------------------------- */

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void)initScrubberTimer
{
	double interval = 1.0f;
	
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration)) 
	{
		return;
	} 
//	double duration = CMTimeGetSeconds(playerDuration);
//	if (isfinite(duration))
//	{
//		CGFloat width = CGRectGetWidth([self.mScrubber bounds]);
//		interval = 0.5f * duration / width;
//	}
//    NSLog(@"Interval:%f", interval);
	/* Update the scrubber during normal playback. */
	__weak PlayerViewController *weakSelf = self;
	mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC) 
								queue:NULL /* If you pass NULL, the main queue is used. */
								usingBlock:^(CMTime time) 
                                            {
                                                [weakSelf syncScrubber];
                                            }];
}

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
//    NSLog(@"Sync");
    
    float progress = [self availableDuration]/CMTimeGetSeconds(self.player.currentItem.duration);
    [self.bufferProgress setProgress:progress];
    [self.bufferProgress setProgressTintColor:[UIColor grayColor]];
    
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration)) 
	{
		mScrubber.minimumValue = 0.0;
		return;
	} 

	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration))
	{
		float minValue = [self.mScrubber minimumValue];
		float maxValue = [self.mScrubber maximumValue];
		double time = CMTimeGetSeconds([self.mPlayer currentTime]);
		[self.mScrubber setValue:(maxValue - minValue) * time / duration + minValue];
        valueBefore = [self.mScrubber value];
	}
    
    NSString *time = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentTime]];
    [self.lbDurationTime setText:time];
    NSString *total = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentItem.asset.duration]];
    if ([self isPlaying]) {
        [self.lbTotalTime setText:total];
    }
}

- (NSTimeInterval) availableDuration;
{
    NSValue *range = self.player.currentItem.loadedTimeRanges.firstObject;
    if (range != nil){
        return CMTimeGetSeconds(CMTimeRangeGetEnd(range.CMTimeRangeValue));
    }
    return CMTimeGetSeconds(kCMTimeZero);
}


- (IBAction)beginVolumeScrubbing:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelTimerHideMenu:)]) {
        [self.delegate cancelTimerHideMenu:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPanGeature:)]) {
        [self.delegate cancelPanGeature:YES];
    }
}

- (IBAction)endVolumeScrubbing:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelTimerHideMenu:)]) {
        [self.delegate cancelTimerHideMenu:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPanGeature:)]) {
        [self.delegate cancelPanGeature:NO];
    }
}

/* The user is dragging the movie controller thumb to scrub through the movie. */
- (IBAction)beginScrubbing:(id)sender
{
    mRestoreAfterScrubbingRate = [self.mPlayer rate];
	[self.mPlayer setRate:0.f];
	
	/* Remove previous timer. */
	[self removePlayerTimeObserver];
    isTouchDown = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelTimerHideMenu:)]) {
        [self.delegate cancelTimerHideMenu:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPanGeature:)]) {
        [self.delegate cancelPanGeature:YES];
    }
}

/* Set the player current time to match the scrubber position. */
- (IBAction)scrub:(id)sender
{
//	if ([sender isKindOfClass:[UISlider class]] && !isSeeking)
//	{
//		isSeeking = YES;
//		UISlider* slider = sender;
//		
//		CMTime playerDuration = [self playerItemDuration];
//		if (CMTIME_IS_INVALID(playerDuration)) {
//			return;
//		} 
//		
//		double duration = CMTimeGetSeconds(playerDuration);
//		if (isfinite(duration))
//		{
//			float minValue = [slider minimumValue];
//			float maxValue = [slider maximumValue];
//			float value = [slider value];
//			
//			double time = duration * (value - minValue) / (maxValue - minValue);
//			[self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
//				dispatch_async(dispatch_get_main_queue(), ^{
//					isSeeking = NO;
//                    NSString *strtime = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentTime]];
//                    [self.lbDurationTime setText:strtime];
//				});
//			}];
//		}
//	}
    
    UISlider* slider = sender;
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        float minValue = [slider minimumValue];
        float maxValue = [slider maximumValue];
        float value = [slider value];
        
        double time = duration * (value - minValue) / (maxValue - minValue);
        [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
        NSString *strtime = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentTime]];
        [self.lbDurationTime setText:strtime];
    }
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (IBAction)endScrubbing:(id)sender
{
	if (!mTimeObserver)
	{
		CMTime playerDuration = [self playerItemDuration];
		if (CMTIME_IS_INVALID(playerDuration)) 
		{
			return;
		} 
		
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
            double tolerance = 1.0f;
			__weak PlayerViewController *weakSelf = self;
			mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
			^(CMTime time)
			{
				[weakSelf syncScrubber];
			}];
		}
	}

	if (mRestoreAfterScrubbingRate)
	{
		[self.mPlayer setRate:mRestoreAfterScrubbingRate];
		mRestoreAfterScrubbingRate = 0.f;
	}
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelTimerHideMenu:)]) {
        [self.delegate cancelTimerHideMenu:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPanGeature:)]) {
        [self.delegate cancelPanGeature:NO];
    }
}




- (void)sliderTapped:(UIGestureRecognizer *)g {
    if (isTouchDown) {
        isTouchDown = !isTouchDown;
        return;
    }else{
        mRestoreAfterScrubbingRate = [self.mPlayer rate];
        [self.mPlayer setRate:0.f];
        
        /* Remove previous timer. */
        [self removePlayerTimeObserver];
        
        
        UISlider* s = (UISlider*)g.view;
        if (s.highlighted)
            return; // tap on thumb, let slider deal with it
        CGPoint pt = [g locationInView: s];
        CGFloat percentage = pt.x / s.bounds.size.width;
        CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
        CGFloat value = s.minimumValue + delta;
        [self.mScrubber setValue:value];
        
        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            float minValue = [self.mScrubber minimumValue];
            float maxValue = [self.mScrubber maximumValue];
            float value = [self.mScrubber value];
            double time = duration * (value - minValue) / (maxValue - minValue);
            [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
            NSString *strtime = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentTime]];
            [self.lbDurationTime setText:strtime];
            if (!mTimeObserver)
            {
                CMTime playerDuration = [self playerItemDuration];
                if (CMTIME_IS_INVALID(playerDuration))
                {
                    return;
                }
                double duration = CMTimeGetSeconds(playerDuration);
                if (isfinite(duration))
                {
                    //			CGFloat width = CGRectGetWidth([self.mScrubber bounds]);
                    //			double tolerance = 0.5f * duration / width;
                    double tolerance = 1.0f;
                    __weak PlayerViewController *weakSelf = self;
                    mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
                                     ^(CMTime time)
                                     {
                                         [weakSelf syncScrubber];
                                     }];
                }
            }
            
            if (mRestoreAfterScrubbingRate)
            {
                [self.mPlayer setRate:mRestoreAfterScrubbingRate];
                mRestoreAfterScrubbingRate = 0.f;
            }
            
//            [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    isSeeking = NO;
//                    NSString *strtime = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentTime]];
//                    [self.lbDurationTime setText:strtime];
//                    if (!mTimeObserver)
//                    {
//                        CMTime playerDuration = [self playerItemDuration];
//                        if (CMTIME_IS_INVALID(playerDuration))
//                        {
//                            return;
//                        }
//                        double duration = CMTimeGetSeconds(playerDuration);
//                        if (isfinite(duration))
//                        {
//                            //			CGFloat width = CGRectGetWidth([self.mScrubber bounds]);
//                            //			double tolerance = 0.5f * duration / width;
//                            double tolerance = 1.0f;
//                            __weak PlayerViewController *weakSelf = self;
//                            mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
//                                             ^(CMTime time)
//                                             {
//                                                 [weakSelf syncScrubber];
//                                             }];
//                        }
//                    }
//                    
//                    if (mRestoreAfterScrubbingRate)
//                    {
//                        [self.mPlayer setRate:mRestoreAfterScrubbingRate];
//                        mRestoreAfterScrubbingRate = 0.f;
//                    }
//
//                });
//            }];
        }
        
    }
}

- (IBAction) volumeScrubbing:(UISlider*)slider{
    [MPMusicPlayerController iPodMusicPlayer].volume = slider.value;
}

- (NSString*) getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int hour = mins/60.0;
    if (hour > 0) {
        mins = mins % 60;
    }
    int secs = fmodf(currentSeconds, 60.0);
//    NSString *hourString = hour < 10 ? [NSString stringWithFormat:@"0%d", hour] : [NSString stringWithFormat:@"%d", hour];
//    NSString* hourString = [NSString stringWithFormat:@"%d", hour];
////    mins = hour * 60 + mins;
//    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
//    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
//    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
    NSString *timeString =@"";
    NSString *formatString=@"";
    
    if (hour > 0) {
        formatString = @"%d:%02d:%02d";
        timeString = [NSString stringWithFormat:formatString, hour, mins, secs];
    }else{
        formatString = @"%02d:%02d";
        timeString = [NSString stringWithFormat:formatString, mins, secs];
    }
    return timeString;
}

- (BOOL)isScrubbing
{
	return mRestoreAfterScrubbingRate != 0.f;
}

-(void)enableScrubber
{
    [self.mScrubber setUserInteractionEnabled:YES];
}

-(void)disableScrubber
{
//    self.mScrubber.enabled = NO;
    [self.mScrubber setUserInteractionEnabled:NO];
}

#pragma mark
#pragma mark View Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		[self setPlayer:nil];
		
		[self setEdgesForExtendedLayout:UIRectEdgeAll];
	}
	
	return self;
}

- (id)init
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        return [self initWithNibName:@"PlayerViewController" bundle:nil];
	} 
    else 
    {
        return [self initWithNibName:@"AVPlayerDemoPlaybackView" bundle:nil];
	}
}

- (void)viewDidUnload
{
    self.mPlaybackView = nil;
    self.mPlayButton = nil;
    self.mStopButton = nil;
    self.mScrubber = nil;
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    
	[self setPlayer:nil];
    oldSubtileRect = titleLabel.frame;
	UIView* view  = [self view];
    
	UISwipeGestureRecognizer* swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	[swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
	[view addGestureRecognizer:swipeUpRecognizer];
	
	UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	[swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
	[view addGestureRecognizer:swipeDownRecognizer];

//    UIImage *minImage = [[UIImage imageNamed:@"progress-bar-nowplaying"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
//    UIImage *maxImage = [[UIImage imageNamed:@"playing_progressbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //[mScrubber setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    //[mScrubber setMinimumTrackImage:minImage forState:UIControlStateNormal];
//    [mScrubber setThumbImage:[UIImage imageNamed:@"icon-nut-progressbar"] forState:UIControlStateNormal];
//    mScrubber.minimumValue = 0.0f;
//    mScrubber.maximumValue = 1.0f;
    
//    [mSvolume setMaximumTrackImage:maxImage forState:UIControlStateNormal];
//    [mSvolume setMinimumTrackImage:minImage forState:UIControlStateNormal];
//    [mSvolume setThumbImage:[UIImage imageNamed:@"nowplaying_nut_playing"] forState:UIControlStateNormal];
//    [mSvolume setThumbImage:[UIImage imageNamed:@"nowplaying_nut_playing"] forState:UIControlStateDisabled];
//    mSvolume.minimumValue = 0.0f;
//    mSvolume.maximumValue = 1.0f;
    //[mSvolume setValue:[MPMusicPlayerController iPodMusicPlayer].volume];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [mScrubber addGestureRecognizer:gr];
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    [panGesture setMaximumNumberOfTouches:2];
    [self.mPlaybackView addGestureRecognizer:panGesture];
    
	[self initScrubberTimer];
	[self syncPlayPauseButtons];
	[self syncScrubber];
    [self showPlayerMenuFull:NO];
    [self initObserver];
    
    // mini duation view
    [miniDurationView.layer setCornerRadius:5.0f];
    [mProgressView setTintColor:kStyleColor];
    [mlbDurationTime setTextColor:kStyleColor];
    
    titleLabel.hidden = NO;
    
    // set font
    [lbDurationTime setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [lbTotalTime setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [btnQuality.titleLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [lbTitle setFont:[UIFont fontWithName:kFontSemibold size:20.0f]];
    [lbDesciption setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbStatusWaiting setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    
    [mlbDurationTime setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [mlbTotalTime setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.mPlayer pause];
	
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)setViewDisplayName
{
    /* Set the view title to the last component of the asset URL. */
    self.title = [mURL lastPathComponent];
    
    /* Or if the item has a AVMetadataCommonKeyTitle metadata, use that instead. */
	for (AVMetadataItem* item in ([[[self.mPlayer currentItem] asset] commonMetadata]))
	{
		NSString* commonKey = [item commonKey];
		
		if ([commonKey isEqualToString:AVMetadataCommonKeyTitle])
		{
			self.title = [item stringValue];
		}
	}
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
	UIView* view = [self view];
	UISwipeGestureRecognizerDirection direction = [gestureRecognizer direction];
	CGPoint location = [gestureRecognizer locationInView:view];
	
	if (location.y < CGRectGetMidY([view bounds]))
	{
		if (direction == UISwipeGestureRecognizerDirectionUp)
		{
			[UIView animateWithDuration:0.2f animations:
			^{
				[[self navigationController] setNavigationBarHidden:YES animated:YES];
			} completion:
			^(BOOL finished)
			{
				[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
			}];
		}
		if (direction == UISwipeGestureRecognizerDirectionDown)
		{
			[UIView animateWithDuration:0.2f animations:
			^{
				[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
			} completion:
			^(BOOL finished)
			{
				[[self navigationController] setNavigationBarHidden:NO animated:YES];
			}];
		}
	}
	else
	{
//		if (direction == UISwipeGestureRecognizerDirectionDown)
//		{
//            if (![self.mToolbar isHidden])
//			{
//				[UIView animateWithDuration:0.2f animations:
//				^{
//					[self.mToolbar setTransform:CGAffineTransformMakeTranslation(0.f, CGRectGetHeight([self.mToolbar bounds]))];
//				} completion:
//				^(BOOL finished)
//				{
//					[self.mToolbar setHidden:YES];
//				}];
//			}
//		}
//		else if (direction == UISwipeGestureRecognizerDirectionUp)
//		{
//            if ([self.mToolbar isHidden])
//			{
//				[self.mToolbar setHidden:NO];
//				
//				[UIView animateWithDuration:0.2f animations:
//				^{
//					[self.mToolbar setTransform:CGAffineTransformIdentity];
//				} completion:^(BOOL finished){}];
//			}
//		}
	}
}

- (void)dealloc
{
	[self removePlayerTimeObserver];
	[self.mPlayer removeObserver:self forKeyPath:@"rate"];
	[mPlayer.currentItem removeObserver:self forKeyPath:@"status"];
	
	[self.mPlayer pause];
}


- (void)initObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)volumeChanged:(NSNotification *)notification
{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self.mSvolume setValue:volume];
}



- (void)panHandle:(UIPanGestureRecognizer *)recognizer
{
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    static CGPoint startPoint;
    CGPoint endPoint;
    UIViewController* topview = [((UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController]) topViewController];
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            startPoint = [recognizer locationInView:topview.view];
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            direct_type = normal_direct;
            mini_direct_current = normal_direct;
            if (isVerticalGesture) {
                if (velocity.y > 0) {
                    direct_type = down_direct;
                } else {
                    direct_type = up_direct;
                }
            }
            
            else {
                if (velocity.x > 0) {
                    direct_type = right_direct;
                } else {
                    direct_type = left_direct;
                }
            }
            if (direct_type == down_direct || direct_type == up_direct) {
                if (startPoint.x <= SCREEN_WIDTH/2) {
                    isChangeBrightness = YES;
                    brightnessCurrent = [[UIScreen mainScreen] brightness];
                }else{
                    isChangeVolume = YES;
                    volumeCurrent = [MPMusicPlayerController iPodMusicPlayer].volume;
                }
            }
            else if(direct_type == left_direct || direct_type == right_direct){
                isChangeProgress = YES;
                [self showMiniDurationView];
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            if (isVerticalGesture) {
                if (velocity.y > 0) {
                    direct_type = down_direct;
                } else {
                    direct_type = up_direct;
                }
            }
            
            else {
                if (velocity.x > 0) {
                    direct_type = right_direct;
                } else {
                    direct_type = left_direct;
                }
            }
            
            if (direct_type == up_direct || direct_type == down_direct) {
                if (startPoint.x <= SCREEN_WIDTH/2) {
                    if (isChangeBrightness) {
                        endPoint   = [recognizer locationInView:topview.view];
                        float gPointY = startPoint.y - endPoint.y;
                        float alpha = gPointY / self.mPlaybackView.frame.size.height;
                        float delta = brightnessCurrent + alpha;
                        if (delta > 1) {
                            delta = 1;
                        }else if(delta < 0){
                            delta = 0;
                        }
                        [[UIScreen mainScreen] setBrightness:delta];
                        [self showBrightnessView:delta];
                    }
                }else{
                    if (isChangeVolume) {
                        endPoint   = [recognizer locationInView:topview.view];
                        float gPointY = startPoint.y - endPoint.y;
                        float alpha = gPointY / self.mPlaybackView.frame.size.height;
                        float delta = volumeCurrent + alpha;
                        if (delta > 1) {
                            delta = 1;
                        }else if(delta < 0){
                            delta = 0;
                        }
                        [MPMusicPlayerController iPodMusicPlayer].volume = delta;
                    }
                }
            }
            else if(direct_type == right_direct || direct_type == left_direct){
                if (isChangeProgress) {
                    endPoint   = [recognizer locationInView:topview.view];
                    float gPointX = endPoint.x - startPoint.x;
                    float alpha = (gPointX / self.mPlaybackView.frame.size.width * 0.5);
                    [self updateMiniDurationView:direct_type andAlpha:alpha];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            isChangeVolume = NO;
            isChangeBrightness = NO;
            if (isChangeProgress) {
                isChangeProgress = NO;
                [self stopMiniDurationView];
            }
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            isChangeVolume = NO;
            isChangeBrightness = NO;
            if (isChangeProgress) {
                isChangeProgress = NO;
                [self stopMiniDurationView];
            }
        }
            break;
        default:
            break;
    }
}

- (void)showBrightnessView:(float)progress{
    UIView *brightnessView = (UIView*)[self.view viewWithTag:666];
    if (!brightnessView) {
        brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        brightnessView.backgroundColor = [UIColor clearColor];
        brightnessView.tag = 666;
        brightnessView.userInteractionEnabled = YES;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, brightnessView.bounds.size.width, brightnessView.bounds.size.height)];
        [img setImage:[UIImage imageNamed:@"brightness_bg"]];
        img.userInteractionEnabled = YES;
        [brightnessView addSubview:img];
        
        F3BarGauge *progressView = [[F3BarGauge alloc] initWithFrame:CGRectMake(13, 132, 135, 7)];
        progressView.tag = 10;
        progressView.numBars = 16;
        progressView.litEffect = NO;
        UIColor *clrBar = RGB(255, 255, 255);
        progressView.normalBarColor = clrBar;
        progressView.warningBarColor = clrBar;
        progressView.dangerBarColor = clrBar;
        progressView.backgroundColor = [UIColor blackColor];
        progressView.outerBorderColor = [UIColor clearColor];
        progressView.innerBorderColor = [UIColor clearColor];
        [brightnessView addSubview:progressView];
        
        [self.view addSubview:brightnessView];
    }
    F3BarGauge *progressView = (F3BarGauge*)[brightnessView viewWithTag:10];
    progressView.value = progress;
    
    brightnessView.hidden = NO;
    brightnessView.alpha = 1.0f;
    brightnessView.center = self.view.center;
    [brightnessView.layer removeAllAnimations];
    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        brightnessView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            brightnessView.hidden = YES;
        }
    }];
}

- (void) showMiniDurationView{
    timeCurrent = self.mScrubber.value;
    [self beginScrubbing:self.mScrubber];
    if (miniDurationView.hidden) {
        [miniDurationView setAlpha:1.0f];
        [miniDurationView setHidden:NO];
        [self cancelTimerHideMenu:YES];
    }
}

- (void) stopMiniDurationView{
    [self cancelTimerHideMenu:NO];
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        float minValue = [self.mScrubber minimumValue];
        float maxValue = [self.mScrubber maximumValue];
        float value = [mProgressView progress];
        
        double time = duration * (value - minValue) / (maxValue - minValue);
        [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *strtime = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentTime]];
                [self.lbDurationTime setText:strtime];
                [self.mScrubber setValue:value];
                [self endScrubbing:self.mScrubber];
            });
        }];
    }
}

- (void) cancelTimerHideMenu:(BOOL) isCancel{
    if (isCancel) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideMiniDurationView) object:nil];
    }else{
        [self performSelector:@selector(hideMiniDurationView) withObject:nil afterDelay:2.0f];
    }
}

- (void) hideMiniDurationView{
    [UIView animateWithDuration:1.0 animations:^{
        [miniDurationView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [miniDurationView setHidden:YES];
    }];
    
}

- (void) updateMiniDurationView:(Direct_Type) type andAlpha:(float) alpha{
    float delta = timeCurrent + alpha;
    if (delta > 1) {
        delta = 1;
    }else if(delta < 0){
        delta = 0;
    }
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        float minValue = [self.mScrubber minimumValue];
        float maxValue = [self.mScrubber maximumValue];
        float value = delta;
        
        double time = duration * (value - minValue) / (maxValue - minValue);
        CMTime sTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
        NSString* strTime = [self getStringFromCMTime:sTime];
        [mlbDurationTime setText:strTime];
        [mlbTotalTime setText:[NSString stringWithFormat:@"/ %@", self.lbTotalTime.text]];
        [mProgressView setProgress:delta];
        if (mini_direct_current == type) {
            return;
        }
        if (type == right_direct) {
            [mStatusImageView setImage:[UIImage imageNamed:@"icon_next_ipad.png"]];
        }else if(type == left_direct){
            [mStatusImageView setImage:[UIImage imageNamed:@"icon_prev_ipad.png"]];
        }
        mini_direct_current = type;
    }
    
//    if (delta > 1) {
//        delta = 1;
//    }else if(delta < 0){
//        delta = 0;
//    }
//    self.mScrubber.value = delta;
//    [self scrub:self.mScrubber];
//    [mlbDurationTime setText:self.lbDurationTime.text];
//    [mlbTotalTime setText:[NSString stringWithFormat:@"/ %@", self.lbTotalTime.text]];
//    [mProgressView setProgress:self.mScrubber.value];
//    if (mini_direct_current == type) {
//        return;
//    }
//    if (type == right_direct) {
//        [mStatusImageView setImage:[UIImage imageNamed:@"icon_next_ipad.png"]];
//    }else if(type == left_direct){
//        [mStatusImageView setImage:[UIImage imageNamed:@"icon_prev_ipad.png"]];
//    }
//    mini_direct_current = type;
}

- (void) changeVideoFillModeWithFullScreen:(BOOL) isFullScreen{
    titleLabel.hidden = NO;
    if (isFullScreen) {
        //        [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
        [btnFullScreen setImage:[UIImage imageNamed:@"icon-zoom-in"] forState:UIControlStateNormal];
        [btnFullScreen setImage:[UIImage imageNamed:@"icon-zoom-in-press"] forState:UIControlStateHighlighted];
        titleLabel.frame = CGRectMake(oldSubtileRect.origin.x, self.view.frame.size.height - self.bottomPlayer.frame.size.height - 50, oldSubtileRect.size.width, 50);
        [titleLabel setFont:[UIFont systemFontOfSize:22.0f]];
    }else{
        //        [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
        [btnFullScreen setImage:[UIImage imageNamed:@"icon-zoom-out"] forState:UIControlStateNormal];
        [btnFullScreen setImage:[UIImage imageNamed:@"icon-zoom-out-press"] forState:UIControlStateHighlighted];
        titleLabel.frame = CGRectMake(20, mPlaybackView.frame.size.height - oldSubtileRect.size.height, mPlaybackView.frame.size.width - 40, oldSubtileRect.size.height);
        [titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    }
}


- (void) changeVideoFullModeWithMinimizedScreen:(BOOL) isMinimized{
    [btnFullScreen setImage:[UIImage imageNamed:@"icon-zoom-out"] forState:UIControlStateNormal];
    [btnFullScreen setImage:[UIImage imageNamed:@"icon-zoom-out-press"] forState:UIControlStateHighlighted];
    [self.bottomPlayer setHidden:isMinimized];
    [self.headerPlayer setHidden:isMinimized];
    [self.centerPlayer setHidden:isMinimized];
    if (isMinimized) {
        [self.mPlaybackView removeGestureRecognizer:panGesture];
        [miniDurationView setHidden:YES];
        titleLabel.frame = CGRectMake(10, mPlaybackView.frame.size.height - 21, mPlaybackView.frame.size.width - 20, 21);
        [titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    }else{
        [self showPlayerMenuFull:NO];
        titleLabel.frame = CGRectMake(20, mPlaybackView.frame.size.height - oldSubtileRect.size.height, mPlaybackView.frame.size.width - 40, oldSubtileRect.size.height);
        [titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    }
}

- (void) showPlayerMenuFull:(BOOL) isFull{
    if (isFull) {
//        [mPlayButton setFrame:CGRectMake(57, mPlayButton.frame.origin.y, mPlayButton.frame.size.width, mPlayButton.frame.size.height)];
//        [mStopButton setFrame:mPlayButton.frame];
//        [mScrubber setFrame:CGRectMake(161, mScrubber.frame.origin.y, 569, mScrubber.frame.size.height)];
    }else{
//        [mPlayButton setFrame:CGRectMake(17, mPlayButton.frame.origin.y, mPlayButton.frame.size.width, mPlayButton.frame.size.height)];
//        [mStopButton setFrame:mPlayButton.frame];
//        [mScrubber setFrame:CGRectMake(91, mScrubber.frame.origin.y, 512, mScrubber.frame.size.height)];
        [self showControlFull:isFull];
    }
//    [self.lbDurationTime setFrame:CGRectMake(mScrubber.frame.origin.x, self.lbDurationTime.frame.origin.y, self.lbDurationTime.frame.size.width, self.lbDurationTime.frame.size.height)];
//    [self.lbTotalTime setFrame:CGRectMake(mScrubber.frame.origin.x + mScrubber.frame.size.width - self.lbTotalTime.frame.size.width, self.lbTotalTime.frame.origin.y, self.lbTotalTime.frame.size.width, self.lbTotalTime.frame.size.height)];
}

- (void) showControlFull:(BOOL) isFull{
    if (isFull) {
        [self.mPlaybackView addGestureRecognizer:panGesture];
    }else{
        [self.mPlaybackView removeGestureRecognizer:panGesture];
        [miniDurationView setHidden:YES];
    }
    
    [imgVolume setHidden:!isFull];
    [self.mSvolume setHidden:!isFull];
    [mNextButton setHidden:!isFull];
    [mPrevButton setHidden:!isFull];
    [lbTitle setHidden:!isFull];
    [lbDesciption setHidden:!isFull];
}

- (BOOL) mpIsFullScreen{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mpIsFullScreen)]) {
        return [self.delegate mpIsFullScreen];
    }
    return NO;
}

- (void) showLoading:(BOOL) isShow{
    if (isShow) {
        [self.lbTotalTime setText:@"00:00"];
        [self.mScrubber setValue:0.0];
        [self.mPlayer seekToTime:kCMTimeZero];
        [playerMessage setHidden:YES];
        [playerLoading setHidden:NO];
        if ([self mpIsFullScreen]) {
            [self.mPlaybackView removeGestureRecognizer:panGesture];
        }
    }else{
        [playerLoading setHidden:YES];
        if ([self mpIsFullScreen]) {
            [self.mPlaybackView addGestureRecognizer:panGesture];
        }
    }
    [animationView setHidden:!isShow];
    [self showLoadingWithAnimation:isShow];
}

- (void) showPlayerMessage:(NSString*) msg isShow:(BOOL) show{
    [playerLoading setHidden:!show];
    if (show) {
        [animationView setHidden:YES];
        [self showLoadingWithAnimation:NO];
        if ([self mpIsFullScreen]) {
            [self.mPlaybackView removeGestureRecognizer:panGesture];
        }
    }
    [playerMessage setHidden:!show];
    [playerMessage setText:msg];
}

- (void) updateLoadingView{
    //    [loading setCenter:self.view.center];
}

- (void) hideMenuPlayer:(BOOL) isHidden{
    [self.bottomPlayer setHidden:isHidden];
    [self.headerPlayer setHidden:isHidden];
    [self.centerPlayer setHidden:isHidden];
}

- (void) showLoadingWithAnimation:(BOOL) isShow{
    if (animationImage.animationImages.count == 0) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 1; i < 3; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_icon_loading%i", i]]];
        }
        // Normal Animation
        animationImage.animationImages = images;
        animationImage.animationDuration = 0.3;
        animationImage.animationRepeatCount = -1;
    }
    
    if (isShow) {
        [animationImage startAnimating];
    }else{
        [animationImage stopAnimating];
    }
    
}

- (void) showXemSauStatus:(BOOL) isViewLater{
//    if (isViewLater) {
//        [_btnXemSau setImage:[UIImage imageNamed:@"icon-xemsau-hover"] forState:UIControlStateNormal];
//    }else{
//        [_btnXemSau setImage:[UIImage imageNamed:@"icon-history"] forState:UIControlStateNormal];
//    }
    [_btnXemSau setSelected:isViewLater];
}

- (void) enableButtonQuality:(BOOL) enable{
    [btnQuality.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btnQuality.layer setBorderWidth:1.0f];
    [btnQuality.layer setCornerRadius:5.0f];
    [btnQuality setClipsToBounds:YES];
//    [btnQuality setEnabled:enable];
}

- (void) setQualityWithType:(NSString*) type withLink:(NSString*) link{
    if (link && ![link isEqualToString:@""]) {
//        NSLog(@"%@", link);
        CMTime curTime = self.mPlayer.currentTime;
        AVPlayerItem* item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:link]];
        [self.mPlayer replaceCurrentItemWithPlayerItem:item];
        [self.mPlayer seekToTime:curTime];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    
    }
    [btnQuality setTitle:type forState:UIControlStateNormal];
}

- (void) setTitle:(NSString*) title andSubTitle:(NSString*) subTitle{
    [lbTitle setText:title];
    [lbDesciption setText:subTitle];
}

- (void) showActionView:(BOOL) isShow{
    [_actionView setHidden:!isShow];
}

@end

@implementation PlayerViewController (Player)

#pragma mark Player Item

- (BOOL)isPlaying
{
	return mRestoreAfterScrubbingRate != 0.f || [self.mPlayer rate] != 0.f;
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification 
{
	/* After the movie has played to its end time, seek back to time zero 
		to play it again. */
	seekToZeroBeforePlay = YES;
    if (!LOADING_ASSET) {
        self.indexCurrent ++;
        if (self.indexCurrent == self.listVideos.count) {
            if(self.listVideos.count > 1){
                self.indexCurrent = 0;
                Video* item = [self.listVideos objectAtIndex:self.indexCurrent];
                if (self.delegate && [self.delegate respondsToSelector:@selector(loadVideoPlayerWithItem:withIndex:fromRootView:)]) {
                    [self.delegate loadVideoPlayerWithItem:item withIndex:self.indexCurrent fromRootView:NO];
                }
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(cannotPlayNext)]) {
                    [self.delegate cannotPlayNext];
                    [self changeVideoFillModeWithFullScreen:NO];
                }
            }
        }else{
            Video* item = [self.listVideos objectAtIndex:self.indexCurrent];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadVideoPlayerWithItem:withIndex:fromRootView:)]) {
                [self.delegate loadVideoPlayerWithItem:item withIndex:self.indexCurrent fromRootView:NO];
            }
        }
    }
    
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem. 
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
	AVPlayerItem *playerItem = [self.mPlayer currentItem];
	if (playerItem.status == AVPlayerItemStatusReadyToPlay)
	{
		return([playerItem duration]);
	}
	
	return(kCMTimeInvalid);
}


/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
	if (mTimeObserver)
	{
		[self.mPlayer removeTimeObserver:mTimeObserver];
		mTimeObserver = nil;
	}
}

#pragma mark -
#pragma mark Loading the Asset Keys Asynchronously

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 ** 
 **  1) values of asset keys did not load successfully, 
 **  2) the asset keys did load successfully, but the asset is not 
 **     playable
 **  3) the item did not become ready to play. 
 ** ----------------------------------------------------------- */

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    if (self.indexCurrent == self.listVideos.count) {
        
        [self removePlayerTimeObserver];
        [self syncScrubber];
        [self disableScrubber];
        [self disablePlayerButtons];
        [self showPlayerMessage:@"Không thể play video này!" isShow:YES];
        isStoped = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVideoItemCurrent)]) {
            [self.delegate deleteVideoItemCurrent];
        }
    }else{
        [mNextButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    /* Display the error. */
//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
//														message:[error localizedFailureReason]
//													   delegate:nil
//											  cancelButtonTitle:@"OK"
//											  otherButtonTitles:nil];
//	[alertView show];
}


#pragma mark Prepare to play asset, URL

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
	for (NSString *thisKey in requestedKeys)
	{
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
		{
			[self assetFailedToPrepareForPlayback:error];
			return;
		}
		/* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
	}
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable) 
    {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey, 
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey, 
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        return;
    }
	
	/* At this point we're ready to set up for playback of the asset. */
    	
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.mPlayerItem)
    {
        /* Remove existing player item key value observers and notifications. */
        [self.mPlayerItem removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.mPlayerItem];
        [self.mPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
	
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.mPlayerItem addObserver:self 
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
    
    /* Observe the AVplayer "playbackLikelyToKeepUp" */
    [self.mPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlaybackViewControllerCurrentItemKeepUpObservationContext];
	
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.mPlayerItem];
    
    
    seekToZeroBeforePlay = NO;
    /* Create new player, if we don't already have one. */
    if (!self.mPlayer)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.mPlayerItem]];
		
        /* Observe the AVPlayer "currentItem" property to find out when any 
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did 
         occur.*/
        [self.mPlayer addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [self.mPlayer addObserver:self
                      forKeyPath:@"rate"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    [self startNotificationObservers];
    if (self.mPlayer.currentItem != self.mPlayerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs 
         asynchronously; observe the currentItem property to find out when the 
         replacement will/did occur
		 
		 If needed, configure player item here (example: adding outputs, setting text style rules,
		 selecting media options) before associating it with a player
		 */
//        if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(checkOpenningVideo)]) {
//            if (![self.parentDelegate checkOpenningVideo]) {
//                [self stop];
//            }else{
//                [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
//            }
//        }
        [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
        [self syncPlayPauseButtons];
    }
//    if (playWithQualityDefault) {
//        [self.mScrubber setValue:0.0];
//    }
    [self.bufferProgress setProgress:0.0f];
    [self.mPlayer play];
    LOADING_ASSET = NO;
}

- (void)startNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerContinue)
                                                 name:PlayerContinueNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerHanging)
                                                 name:PlayerHangingNotification
                                               object:nil];
}


#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
**  Called when the value at the specified key path relative
**  to the given object has changed. 
**  Adjust the movie play and pause button controls when the 
**  player item "status" value changes. Update the movie 
**  scrubber control when the player item is ready to play.
**  Adjust the movie scrubber control when the player item 
**  "rate" value changes. For updates of the player
**  "currentItem" property, set the AVPlayer for which the 
**  player layer displays visual output.
**  NOTE: this method is invoked on the main queue.
** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path 
			ofObject:(id)object 
			change:(NSDictionary*)change 
			context:(void*)context
{
	/* AVPlayerItem "status" property value observer. */
	if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
	{
		[self syncPlayPauseButtons];

        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
            /* Indicates that the status of the player is not yet known because 
             it has not tried to load new media resources for playback */
            case AVPlayerItemStatusUnknown:
            {
                [self removePlayerTimeObserver];
                [self syncScrubber];
                [self disableScrubber];
                [self disablePlayerButtons];
            }
            break;
                
            case AVPlayerItemStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e. 
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                [self initScrubberTimer];
                [self enableScrubber];
                [self enablePlayerButtons];
//                if (playWithQualityDefault) {
//                    [self.mPlayer play];
//                }
                
            }
            break;
                
            case AVPlayerItemStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
                [self showLoading:NO];
            }
            break;
        }
	}
	/* AVPlayer "rate" property value observer. */
	else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
	{
        [self syncPlayPauseButtons];
	}
	/* AVPlayer "currentItem" property observer. 
        Called when the AVPlayer replaceCurrentItemWithPlayerItem: 
        replacement will/did occur. */
	else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
	{
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            [self disablePlayerButtons];
            [self disableScrubber];
            [self showLoading:NO];
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            [self showLoading:NO];
            [self.mPlaybackView setPlayer:self.mPlayer];
            [self setViewDisplayName];
            /* Specifies that the player should preserve the video’s aspect ratio and
             fit the video within the layer’s bounds. */
            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            [self syncPlayPauseButtons];
        }
    } else if (context == AVPlaybackViewControllerCurrentItemKeepUpObservationContext) {
        if (self.mPlayer.currentItem.playbackLikelyToKeepUp == NO && CMTIME_COMPARE_INLINE(self.mPlayer.currentTime,>,kCMTimeZero) && CMTIME_COMPARE_INLINE(self.mPlayer.currentTime, !=, self.mPlayer.currentItem.duration)) {
            //[[NSNotificationCenter defaultCenter]postNotificationName:PlayerHangingNotification object:self.mPlayer];
        } else if (self.mPlayer.currentItem.playbackLikelyToKeepUp == NO){
            [self.mPlayer play];
        }
        
    }
	else
	{
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
}

- (void)playerHanging {
    [self.mPlayer pause];
    // start an activity indicator / busy view
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayerContinueNotification object:self.player];
}

// playerContinue does the actual waiting and restarting
- (void)playerContinue {
    if (CMTIME_COMPARE_INLINE(self.player.currentTime, ==, self.player.currentItem.duration)) { // we've reached the end
        
        //stop
        
    }  else if (self.player.currentItem.playbackLikelyToKeepUp == YES) {
        
        // Here I stop/remove the activity indicator I put up in playerHanging
        [self.mPlayer play]; // continue from where we left off
        
    } else { // still hanging, not at end
        
        // create a 0.5-second delay to see if buffering catches up
        // then post another playerContinue notification to call this method again
        // in a manner that attempts to avoid any recursion or threading nightmares
        //playerTryCount += 1;
        //        double delayInSeconds = 0.5;
        //        dispatch_time_t executeTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //        dispatch_after(executeTime, dispatch_get_main_queue(), ^{
        //
        //        // test playerTryCount again to protect against changes that might have happened during the 0.5 second delay
        //        if (playerTryCount > 0) {
        //            if (playerTryCount <= 10) {
        //                [self.notificationCenter postNotificationName:PlayerContinueNotification object:self.videoPlayer];
        //            } else {
        //                [self stopPlaying];
        //                // put up "sorry" alert
        //            }
        //        }
        //    });
    }
}


- (IBAction)doFullScreen:(id)sender{

    if (self.view.frame.size.width == SCREEN_WIDTH) {
        [self changeVideoFillModeWithFullScreen:NO];
        [self setScreenName:@"iPad.VideoDetail"];
    }else{
        [self changeVideoFillModeWithFullScreen:YES];
        [self setScreenName:@"iPad.VideoFullScreen"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFullScreen)]) {
        [self.delegate showFullScreen];
    }
}

- (IBAction) doMinimized:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doMinimized)]) {
        [self.delegate doMinimized];
    }
}

- (IBAction) doXemSau:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doXemSau)]) {
        [self.delegate doXemSau];
    }
}

- (IBAction) doDownload:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doDownload)]) {
        [self.delegate doDownload];
    }
}

- (IBAction) doViewQuality:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doViewQuality)]) {
        [self.delegate doViewQuality];
    }
}

- (IBAction) doShare:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doShare)]) {
        [self.delegate doShare];
    }
}



- (void) checkSeekOfVideo{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentVideo)]) {
        Video* video = [self.delegate getCurrentVideo];
        double seconds = [[DBHelper sharedInstance] getSecondsContinueVideo:video];
        if (seconds < 0) {
            seconds = 0;
        }
        [self.mPlayer seekToTime:CMTimeMakeWithSeconds(seconds, 60000)];
    }
}

- (void) changeQuanlity{
    mRestoreAfterScrubbingRate = [self.mPlayer rate];
    [self.mPlayer setRate:0.f];
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    
    [self.mScrubber setValue:valueBefore];
    float minValue = [self.mScrubber minimumValue];
    float maxValue = [self.mScrubber maximumValue];
    
    double time = duration * (valueBefore - minValue) / (maxValue - minValue);
    [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *strtime = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentTime]];
            [self.lbDurationTime setText:strtime];
            if (!mTimeObserver)
            {
                CMTime playerDuration = [self playerItemDuration];
                if (CMTIME_IS_INVALID(playerDuration))
                {
                    return;
                }
                double duration = CMTimeGetSeconds(playerDuration);
                if (isfinite(duration))
                {
                    //			CGFloat width = CGRectGetWidth([self.mScrubber bounds]);
                    //			double tolerance = 0.5f * duration / width;
                    double tolerance = 1.0f;
                    __weak PlayerViewController *weakSelf = self;
                    mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
                                     ^(CMTime time)
                                     {
                                         [weakSelf syncScrubber];
                                     }];
                }
            }
            
            if (mRestoreAfterScrubbingRate)
            {
                [self.mPlayer setRate:mRestoreAfterScrubbingRate];
                mRestoreAfterScrubbingRate = 0.f;
            }
            
        });
    }];
    
    
//    CMTime curTime = APPDELEGATE.nowPlayerVC.player.mPlayer.currentTime;
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:link]];
//    [APPDELEGATE.nowPlayerVC.player.mPlayer replaceCurrentItemWithPlayerItem:item];
//    [APPDELEGATE.nowPlayerVC.player.mPlayer seekToTime:curTime];
}


@end

