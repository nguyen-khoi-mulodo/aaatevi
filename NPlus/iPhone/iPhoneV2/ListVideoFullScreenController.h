//
//  ListVideoFullScreenController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/9/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeVC.h"
#import "ItemCell.h"

@interface ListVideoFullScreenController : HomeVC <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,MoreOptionViewDelegate,ItemCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbVideo;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblIndex;

@property int curIndexVideoChoose;

@end
