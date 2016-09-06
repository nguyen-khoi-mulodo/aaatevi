//
//  ListVideoCell.h
//  NPlus
//
//  Created by Anh Le Duc on 8/20/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;
@property (weak, nonatomic) IBOutlet UILabel *lbCountVideo;
@property (weak, nonatomic) IBOutlet UIImageView *imgOver;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubTitle;

@end
