//
//  TopKeywordCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/16/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "TopKeywordCell.h"

@implementation TopKeywordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)loadContentWithIndex:(NSInteger)index {
    _lblKeyword.text = _keyword.title;
    switch (index) {
        case 0:
            [_imgIcon setImage:[UIImage imageNamed:@"top-keyword-1-v2"]];
            break;
        case 1:
            [_imgIcon setImage:[UIImage imageNamed:@"top-keyword-2-v2"]];
            break;
        case 2:
            [_imgIcon setImage:[UIImage imageNamed:@"top-keyword-3-v2"]];
            break;
        case 3:
            [_imgIcon setImage:[UIImage imageNamed:@"top-keyword-4-v2"]];
            break;
        case 4:
            [_imgIcon setImage:[UIImage imageNamed:@"top-keyword-5-v2"]];
            break;
        default:
            break;
    }
}

@end
