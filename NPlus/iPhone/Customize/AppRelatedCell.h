//
//  AppRelatedCell.h
//  NPlus
//
//  Created by TEVI Team on 11/24/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelatedItem.h"

@interface AppRelatedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;

- (void) setContentWithAppItem:(RelatedItem*) item;

@end
