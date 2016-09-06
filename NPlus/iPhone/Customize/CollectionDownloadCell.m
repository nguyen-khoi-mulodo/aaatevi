//
//  CollectionDownloadCell.m
//  NPlus
//
//  Created by Anh Le Duc on 9/23/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "CollectionDownloadCell.h"

@implementation CollectionDownloadCell

- (void)awakeFromNib {
    // Initialization code
    self.imgBG.backgroundColor = RGB(235, 235, 235);
    self.layer.borderColor = RGB(202, 202, 202).CGColor;
    self.layer.cornerRadius = 2.0f;
    self.layer.borderWidth = 0.5f;
    self.lbTitle.textColor = RGB(68, 68, 68);

}

-(void)setCollectionDownloadCellType:(CollectionDownloadCellType)t{
    if (CollectionDownloadCellTypeNormal == t) {
        self.imgIcon.hidden = YES;
        self.imgBG.backgroundColor = RGB(235, 235, 235);
        self.layer.borderColor = RGB(202, 202, 202).CGColor;
        self.layer.cornerRadius = 2.0f;
        self.layer.borderWidth = 0.5f;
        self.lbTitle.textColor = RGB(68, 68, 68);
    }else if (CollectionDownloadCellTypeDownloaded == t){
        self.imgIcon.hidden = NO;
        self.imgIcon.image = [UIImage imageNamed:@"ipod_downloaded"];
        self.imgBG.backgroundColor = RGB(235, 235, 235);
        self.layer.borderColor = RGB(202, 202, 202).CGColor;
        self.layer.cornerRadius = 2.0f;
        self.layer.borderWidth = 0.5f;
        self.lbTitle.textColor = RGB(68, 68, 68);
    }else if (CollectionDownloadCellTypeDownloading == t){
        self.imgIcon.hidden = YES;
        self.imgBG.backgroundColor = RGB(165, 231, 248);
        self.layer.borderColor = RGB(73, 193, 238).CGColor;
        self.layer.cornerRadius = 2.0f;
        self.layer.borderWidth = 0.5f;
        self.lbTitle.textColor = RGB(68, 68, 68);
    }else if (CollectionDownloadCellTypeSelected == t){
        self.imgIcon.hidden = YES;
        self.imgBG.backgroundColor = COLOR_MAIN_BLUE;
        self.layer.borderColor = RGB(202, 202, 202).CGColor;
        self.layer.cornerRadius = 2.0f;
        self.layer.borderWidth = 0.5f;
        self.lbTitle.textColor = RGB(255, 255, 255);
    }
}

@end
