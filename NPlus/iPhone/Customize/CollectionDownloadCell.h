//
//  CollectionDownloadCell.h
//  NPlus
//
//  Created by Anh Le Duc on 9/23/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CollectionDownloadCellType) {
    CollectionDownloadCellTypeNormal,
    CollectionDownloadCellTypeDownloaded,
    CollectionDownloadCellTypeDownloading,
    CollectionDownloadCellTypeSelected,
};
@interface CollectionDownloadCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (nonatomic, assign) CollectionDownloadCellType type;
- (void)setCollectionDownloadCellType:(CollectionDownloadCellType)t;
@end
