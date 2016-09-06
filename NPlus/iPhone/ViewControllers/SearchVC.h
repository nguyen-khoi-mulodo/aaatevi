//
//  SearchVC.h
//  NPlus
//
//  Created by Anh Le Duc on 8/1/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"
#import "HMSegmentedControl.h"
@interface SearchVC : BaseVC<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (strong, nonatomic) IBOutlet UIView *viewResults;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (strong,nonatomic) NSMutableArray *pages;
- (IBAction)btnCancel_Tapped:(id)sender;

@end
