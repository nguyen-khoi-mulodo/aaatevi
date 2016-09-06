//
//  DetailInfoTableViewCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 1/6/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailInfoTableViewCell;
@protocol DetailInfoCellDelegate <NSObject>

- (void)didTapViewMoreBtn:(DetailInfoTableViewCell*)cell;

@end

@interface DetailInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnViewMore;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (nonatomic) id <DetailInfoCellDelegate> delegate;
@end
