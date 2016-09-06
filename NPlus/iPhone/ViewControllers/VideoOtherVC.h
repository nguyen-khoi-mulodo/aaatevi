//
//  VideoOtherVC.h
//  NPlus
//
//  Created by Anh Le Duc on 8/28/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"
#import "THSegmentedPageViewControllerDelegate.h"
@interface VideoOtherVC : BaseVC<THSegmentedPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cvMain;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
- (void)setShowRelated:(NSArray*)lst withType:(kItemCollectionType)type;
- (void)setVideoRelated:(NSArray*)lst;
- (void)setDataViewIsTable:(BOOL)isTable;
@end
