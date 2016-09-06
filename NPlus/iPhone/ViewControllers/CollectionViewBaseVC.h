//
//  CollectionViewBaseVC.h
//  NPlus
//
//  Created by Anh Le Duc on 8/19/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"
#define kTabHot 0
#define kTabAll 1
@interface CollectionViewBaseVC : BaseVC<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger currentTab;
@property (weak, nonatomic) IBOutlet UICollectionView *cvMain;
- (IBAction)btnBack_Tapped:(id)sender;
@end
