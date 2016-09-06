//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
#import "Channel.h"
#import "ActionVC.h"

@protocol ChannelLikedItemDelegate <NSObject>
- (void) shareFacebookWithItem:(id) item;
@end

@interface ChannelLikedItemCell : UIGridViewCell <ActionDelegate>{
    
    UIPopoverController* actionPopover;
    ActionVC *actionVC;
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbDesciption;
@property (weak, nonatomic) IBOutlet UILabel* lbNumVideos;
@property (weak, nonatomic) IBOutlet UILabel* lbRating;
@property (weak, nonatomic) IBOutlet UILabel* lbFollow;
@property (weak, nonatomic) IBOutlet UIButton* btnAction;
@property (weak, nonatomic) IBOutlet UIView* vFollow;
@property (weak, nonatomic) IBOutlet UIView* vRating;

@property (nonatomic, strong) Channel* mChannel;
@property (nonatomic, strong) id <ChannelLikedItemDelegate> delegate;


- (void) setContent:(Channel *) item;

@end

