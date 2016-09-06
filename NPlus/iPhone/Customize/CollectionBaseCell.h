//
//  CollectionBaseCell.h
//  NPlus
//
//  Created by Anh Le Duc on 8/19/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionBaseCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgItem;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@end
