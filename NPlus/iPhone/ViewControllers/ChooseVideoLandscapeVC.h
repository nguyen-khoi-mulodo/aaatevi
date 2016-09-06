//
//  ChooseVideoLandscapeVC.h
//  NPlus
//
//  Created by Anh Le Duc on 9/18/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseVideoLandscapeVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, copy) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *cvMain;
- (void)loadData;
@end
