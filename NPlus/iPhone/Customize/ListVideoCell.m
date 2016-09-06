//
//  ListVideoCell.m
//  NPlus
//
//  Created by Anh Le Duc on 8/20/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "ListVideoCell.h"

@implementation ListVideoCell

- (void)awakeFromNib
{
    // Initialization code
    self.lbCountVideo.textColor = [UIColor whiteColor];
    self.lbCountVideo.font = [UIFont boldSystemFontOfSize:13.0f];
    self.lbTitle.textColor = RGB(68, 68, 68);
    self.lbSubTitle.textColor = RGB(136, 137, 137);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
