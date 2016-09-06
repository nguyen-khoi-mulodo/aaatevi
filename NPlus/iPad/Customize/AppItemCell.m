//
//  AppItemCell.m
//  XoSo
//
//  Created by Vo Chuong Thien on 5/6/15.
//  Copyright (c) 2015 Khoi Nguyen Nguyen. All rights reserved.
//

#import "AppItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constant.h"

@implementation AppItemCell

- (void)awakeFromNib {
    // Initialization code
    [btnDownload setBackgroundColor:RGB(36, 152, 137)];
    [btnDownload.layer setCornerRadius:5.0];
    [btnDownload.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) setContentWithAppItem:(RelatedItem*) item{
//    appItemCurrent = item;
//    [lbDes setText:item.mDescription];
//    [lbName setText:item.mName];
//    [imgIcon setImageWithURL:[NSURL URLWithString:item.mIcon]];
}

- (IBAction) doDownload:(id)sender{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showWebViewWithURL:)]) {
//        [self.delegate showWebViewWithURL:appItemCurrent.mLink];
//    }
}

@end
