//
//  DetailInfoTableViewCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 1/6/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "DetailInfoTableViewCell.h"

@implementation DetailInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)viewMoreBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didTapViewMoreBtn:)]) {
        [_delegate didTapViewMoreBtn:self];
    }
}

@end
