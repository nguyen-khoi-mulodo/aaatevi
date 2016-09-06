//
//  TVCollectionViewCell.m
//  NPlus
//
//  Created by Khoi Nguyen on 5/8/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "TVCollectionViewCell.h"

@implementation TVCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 8;
    self.layer.borderColor = UIColorFromRGB(0x00adef).CGColor;
    self.layer.borderWidth = 1;
}

@end
