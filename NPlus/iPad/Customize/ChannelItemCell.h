//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface ChannelItemCell : UIGridViewCell{
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbDesciption;
@property (weak, nonatomic) IBOutlet UILabel* lbRating;
@property (weak, nonatomic) IBOutlet UILabel* lbUsersView;

@property (weak, nonatomic) IBOutlet UIView* vFollow;
//@property (weak, nonatomic) IBOutlet UIView* vRating;
-(void) setContentChannel:(Channel *) channel;
@end

