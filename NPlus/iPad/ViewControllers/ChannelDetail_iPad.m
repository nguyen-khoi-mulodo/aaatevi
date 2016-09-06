//
//  ArtistDetail_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ChannelDetail_iPad.h"
#import "UIImageEffects.h"
#import "ArtistChannel_iPad.h"
#import "ArtistSuggestItemCell.h"

@interface ChannelDetail_iPad ()
@end


@implementation ChannelDetail_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!infoDetail) {
        infoDetail = [[ChannelInfoDetailVC_iPad alloc] initWithNibName:@"ChannelInfoDetailVC_iPad" bundle:nil];
    }
    [infoDetail setDelegate:self];
    [infoDetail setType:CHANNEL_TYPE];
    [infoDetail.view setFrame:CGRectMake(0, 196, 674, 388)];
    [self.view addSubview:infoDetail.view];
    
    [lbRating setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [lbUsersView setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Data

- (void) loadDataWithChannel:(Channel*) channel{
    
    [thumbImageView setClipsToBounds:YES];
    [thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    [thumbImageView setImageWithURL:[NSURL URLWithString:channel.fullImg] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    
    [lbRating setText:[NSString stringWithFormat:@"%0.1f", channel.rating]];
    [lbUsersView setText:[NSString stringWithFormat:@"%ld", channel.view]];
    
    [infoDetail loadDataWithChannel:channel];
}

#pragma mark Action

-(IBAction) doPlay:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playVideoDefaultOfChannel)]) {
        [self.delegate playVideoDefaultOfChannel];
    }
}

- (void) showArtist:(id)item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showArtist:)]) {
        [self.delegate showArtist:item];
    }
}

- (void) showRatingView:(id) vc{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRatingView:)]) {
        [self.delegate showRatingView:vc];
    }
}

- (void) showLoginWithTask:(NSString*) task withVC:(id) vc{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:withVC:) ]) {
        [self.delegate showLoginWithTask:task withVC:vc];
    }
}

- (void) hideLoginView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideLoginView)]) {
        [self.delegate hideLoginView];
    }
}

@end
