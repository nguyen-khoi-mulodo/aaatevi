//
//  TVCollectionViewCell.h
//  NPlus
//
//  Created by Khoi Nguyen on 5/8/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) Video *video;

@end
