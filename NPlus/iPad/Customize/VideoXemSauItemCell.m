//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "VideoXemSauItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ActionVC.h"

@implementation VideoXemSauItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 378, 122);
        [[NSBundle mainBundle] loadNibNamed:@"VideoXemSauItemCell" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
        [self.lbTitle setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
        [self.lbDesciption setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
//        [self.lbLuotXem setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        [self.lbTime setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        
    }
    return self;
}

- (void) setContent:(Video *) item{
    self.mVideo = item;
    [self.view setUserInteractionEnabled:YES];
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imageIcon setImageWithURL:[NSURL URLWithString:item.video_image] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    [self setUILabelTextWithVerticalAlignTop:item.video_subtitle withLabel:self.lbTitle];
    [self setUILabelTextWithVerticalAlignTop:item.video_title withLabel:self.lbDesciption];
    [self.vTime setHidden:NO];
//    [self.vLuotXem setHidden:NO];
//    [_lbLuotXem setText:[Utilities convertToStringFromCount:item.viewCount]];
    [_lbTime setText:item.time];
}

- (void)setUILabelTextWithVerticalAlignTop:(NSString *)theText withLabel:(UILabel*) label{
    [label setText:theText];
    // set number line = 0 to show full text
    CGSize theStringSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    float X = label.frame.origin.x;
    float width = label.frame.size.width;
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
}

- (IBAction) doShowMore:(id)sender{
    if (!actionVC) {
        actionVC = [[ActionVC alloc] initWithNibName:@"ActionVC" bundle:nil];
    }
    [actionVC setDelegate:self];
    [actionVC loadDataWithType:video_type];
    if (!actionPopover) {
        actionPopover = [[UIPopoverController alloc] initWithContentViewController:actionVC];
    }
    [actionPopover setPopoverContentSize:CGSizeMake(175, 40 * actionVC.arrTitles.count)];
    [actionPopover presentPopoverFromRect:self.btnAction.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction) doSelect:(id)sender{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void) boXemSau{
    [[APIController sharedInstance] userSubcribeVideo:self.mVideo.video_id subcribe:NO completed:^(int code, BOOL status){
        if (status) {
//            [APPDELEGATE showToastWithMessage:@"Bạn đã bỏ video khỏi danh sách xem sau!" position:@"bottom" type:doneImage];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoadListVideoXemSau object:nil];
        }else{
            [APPDELEGATE showToastWithMessage:@"Bạn bỏ video khỏi danh sách xem sau chưa thành công!" position:@"bottom" type:errorImage];
        }
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
    [actionPopover dismissPopoverAnimated:YES];
}

- (void) shareFacebook{
    [actionPopover dismissPopoverAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareFacebookWithItem:)]) {
        [self.delegate shareFacebookWithItem:self.mVideo];
    }
}

@end
