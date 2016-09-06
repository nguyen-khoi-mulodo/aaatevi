//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "ChannelLikedItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ActionVC.h"

@implementation ChannelLikedItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 378, 122);
        [[NSBundle mainBundle] loadNibNamed:@"ChannelLikedItemCell" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
        [self.lbTitle setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
        [self.lbFollow setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        [self.lbRating setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    }
    return self;
}

- (void) setContent:(Channel *) item{
    self.mChannel = item;
    [self.view setUserInteractionEnabled:YES];
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imageIcon setImageWithURL:[NSURL URLWithString:item.fullImg] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    [self.lbTitle setText:item.channelName];
    [self.vFollow setHidden:NO];
    [self.vRating setHidden:NO];
    [self.lbRating setText:[NSString stringWithFormat:@"%0.1f", item.rating]];
    [self.lbFollow setText:[Utilities convertToStringFromCount:item.view]];
}

- (IBAction) doShowMore:(id)sender{
    if (!actionVC) {
        actionVC = [[ActionVC alloc] initWithNibName:@"ActionVC" bundle:nil];
    }
    [actionVC setDelegate:self];
    [actionVC loadDataWithType:channel_type];
    if (!actionPopover) {
        actionPopover = [[UIPopoverController alloc] initWithContentViewController:actionVC];
    }
    [actionPopover setPopoverContentSize:CGSizeMake(175, 40 * actionVC.arrTitles.count)];
    [actionPopover presentPopoverFromRect:self.btnAction.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];

}

- (IBAction) doSelect:(id)sender{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void) boFollow{
    [[APIController sharedInstance] userSubcribeChannel:self.mChannel.channelId subcribe:NO completed:^(int code, BOOL status){
        if (status) {
//            [APPDELEGATE showToastWithMessage:@"Bạn đã bỏ follow kênh thành công!" position:@"bottom" type:doneImage];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoadListChannelLiked object:nil];
        }else{
            [APPDELEGATE showToastWithMessage:@"Bạn bỏ follow kênh chưa thành công!" position:@"bottom" type:errorImage];
        }
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
    [actionPopover dismissPopoverAnimated:YES];
}

- (void) shareFacebook{
        [actionPopover dismissPopoverAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareFacebookWithItem:)]) {
        [self.delegate shareFacebookWithItem:self.mChannel];
    }
}

@end
