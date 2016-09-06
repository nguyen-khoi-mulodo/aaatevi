//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
#import "Video.h"
#import "ActionVC.h"

@protocol VideoXemSauItemDelegate <NSObject>
- (void) shareFacebookWithItem:(id) item;
@end

@interface VideoXemSauItemCell : UIGridViewCell<ActionDelegate>{
    
    UIPopoverController* actionPopover;
    ActionVC* actionVC;
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbDesciption;
@property (weak, nonatomic) IBOutlet UIButton* btnAction;
@property (weak, nonatomic) IBOutlet UILabel* lbTime;
@property (weak, nonatomic) IBOutlet UILabel* lbLuotXem;
@property (weak, nonatomic) IBOutlet UIView* vLuotXem;
@property (weak, nonatomic) IBOutlet UIView* vTime;


@property (nonatomic, strong) Video* mVideo;
@property (nonatomic, strong) id <VideoXemSauItemDelegate> delegate;


- (void) setContent:(Video *) item;

@end

