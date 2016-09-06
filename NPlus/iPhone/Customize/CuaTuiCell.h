//
//  CuaTuiCell.h
//  NPlus
//
//  Created by Anh Le Duc on 7/31/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuaTuiCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@end
