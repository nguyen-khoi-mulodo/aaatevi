//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface VideoDownloadedItemCell : UIGridViewCell{
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbName;
@property (weak, nonatomic) IBOutlet UILabel* lbTap;
@property (weak, nonatomic) IBOutlet UILabel* lbViews;
@property (weak, nonatomic) IBOutlet UIButton* btnAction;
@property (weak, nonatomic) IBOutlet UILabel* lbStatus;

@property (weak, nonatomic) IBOutlet UILabel* lbTime;
@property (weak, nonatomic) IBOutlet UIView* actionView;
- (void) setVideo:(Video *) item;
- (void) setContent:(Channel *) item;
- (void) setVideo:(Video*) item isShowActionView:(BOOL) isShow;

@end

