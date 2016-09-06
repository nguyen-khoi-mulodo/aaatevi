//
//  ChooseVideoVC.h
//  NPlus
//
//  Created by Anh Le Duc on 8/28/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"
#import "THSegmentedPageViewControllerDelegate.h"
@protocol ChooseVideoDelegate;
@interface ChooseVideoVC : BaseVC<THSegmentedPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (nonatomic, weak) id<ChooseVideoDelegate> delegate;
@property (strong, nonatomic) IBOutlet UICollectionView *cvItems;
- (void)setVideoItems:(NSArray*)lst selectedAtIndex:(NSInteger)index;
- (void)setStateDownload:(BOOL)isDownload;
- (void)reloadData;
@end

@protocol ChooseVideoDelegate <NSObject>

@optional
- (void)chooseVideoVC:(ChooseVideoVC*)controller didSelectedAtIndex:(NSInteger)index;

@end