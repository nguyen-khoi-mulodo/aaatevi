//
//  AppRelatedCell.m
//  NPlus
//
//  Created by TEVI Team on 11/24/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "AppRelatedCell.h"

@implementation AppRelatedCell

- (void)awakeFromNib {
    // Initialization code
    if (IS_IPAD) {
        [_lbTitle setFont:[UIFont fontWithName:kFontSemibold size:15.0]];
        [_lbDesc setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContentWithAppItem:(RelatedItem*) item{
    _lbTitle.text = item.appName;
//    _lbDesc.text  = item.desc;
    [self setUILabelTextWithVerticalAlignTop:item.desc withLabel:_lbDesc];
    [_imgItem setImageWithURL:[NSURL URLWithString:item.iconURL] placeholderImage:nil];
    if (IS_IPAD) {
        [_lbTitle setTextColor:RGB(0, 0, 0)];
        [_lbDesc setTextColor:RGB(0, 0, 0)];
    }
}

- (void)setUILabelTextWithVerticalAlignTop:(NSString *)theText withLabel:(UILabel*) label{
    [label setText:theText];
    // set number line = 0 to show full text
    CGSize theStringSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    float X = label.frame.origin.x;
    float width = label.frame.size.width;
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
}

@end
