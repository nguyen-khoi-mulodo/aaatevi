//
//  NotificationCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/28/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData {
    if (_localNotif) {
        [_thumbImg setImageWithURL:[NSURL URLWithString:_localNotif.url] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
        _lblDesc.text = _localNotif.desc;
        _lblTime.text = _localNotif.time;
    }
}

@end
