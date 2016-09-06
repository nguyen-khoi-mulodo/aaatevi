//
//  CustomVideoCell.h
//  NPlus
//
//  Created by Anh Le Duc on 11/14/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSinger;

@end
