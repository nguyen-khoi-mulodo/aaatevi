//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface VideoNewItemCell : UIGridViewCell{
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbSubTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbViews;
@property (weak, nonatomic) IBOutlet UILabel* lbTime;
@property (weak, nonatomic) IBOutlet UIView* actionView;
@property (weak, nonatomic) IBOutlet UIView* vLuotXem;
@property (weak, nonatomic) IBOutlet UIView* vTime;

//- (void) setVideo:(Video *) item;
//-(void) setContent:(Show *) item;
- (void) setVideo:(Video*) item isShowActionView:(BOOL) isShow;

@end

