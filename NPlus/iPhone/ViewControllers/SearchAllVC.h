//
//  SearchAllVC.h
//  NPlus
//
//  Created by Anh Le Duc on 10/2/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"
#import "THSegmentedPageViewControllerDelegate.h"
@interface SearchAllVC : BaseVC<THSegmentedPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cvMain;
@property (nonatomic, copy) NSString *keyword;
@end
