//
//  VideoHotCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoOfSeasonItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView* mContentView;
@property (nonatomic, weak) IBOutlet UIImageView* thumbImage;
@property (nonatomic, strong) IBOutlet UILabel* lbTitle;

- (void) setContent:(Video*) video;

- (void) commonInit;
@end
