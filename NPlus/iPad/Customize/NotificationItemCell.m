//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "NotificationItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NotificationItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 760, 142);
        [[NSBundle mainBundle] loadNibNamed:@"NotificationItemCell" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
        [self.lbDate setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    }
    return self;
}

- (void) setContent:(LocalNotif *) item{
    [self.view setUserInteractionEnabled:YES];
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imageIcon setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    _lbTitle.text = item.desc;
    _lbDate.text = item.time;
}


@end
