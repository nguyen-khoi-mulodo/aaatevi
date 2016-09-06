//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCustomViewFromXib.h"

@interface BannerItemCell : PSCustomViewFromXib{
}


@property (nonatomic, strong) IBOutlet UIButton* btnPlay;
@property (nonatomic, strong) IBOutlet UILabel* lbTitle;
@property (nonatomic, strong) IBOutlet UILabel* lbType;
@property (nonatomic, strong) IBOutlet UILabel* lbSubTitle;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;

- (void) showButtonPlay:(BOOL) show;
- (void) setContentVideo:(Video*) video;
@end

