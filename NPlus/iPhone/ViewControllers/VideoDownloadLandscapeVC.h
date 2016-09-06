//
//  VideoDownloadLandscapeVC.h
//  NPlus
//
//  Created by Anh Le Duc on 9/24/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDownloadLandscapeVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, copy) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *cvMain;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
- (IBAction)btnDownload_Tapped:(id)sender;

- (void)loadData;
@end
