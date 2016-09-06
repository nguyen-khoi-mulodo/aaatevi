//
//  RankVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/31/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "BaseVC.h"
#import "GridListItemsVC.h"
#import "GridViewBaseVC.h"
#import "GlobalViewController.h"
#import "CustomSegmentedControl.h"
#import "Constant.h"
#import "FilterListVC.h"

@interface CategoryVC_iPad : GlobalViewController <GridViewBaseDelegate, CustomSegmentedControlDelegate, UIPopoverControllerDelegate, FilterListDelegate>{
    ListType mListType;
    NSString* mDataType;
    GridListItemsVC* contentVC;
    FilterListVC* filterListVC;
    UIPopoverController* popoverVC;
    IBOutlet UIButton* btnShowList;
    NSString* subTitle;
    UIButton* btnGenreCurrent;
    NSMutableArray* listGenres;
    int genreIndex;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView* genreScrollView;
@property (weak, nonatomic) IBOutlet UIButton* btnAll;
@property (weak, nonatomic) IBOutlet UILabel* vIndicator;
@property (weak, nonatomic) IBOutlet UIView* headerView;
@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UITextField* txtSearch;
@property (weak, nonatomic) IBOutlet UIView* menuView;
@property (weak, nonatomic) IBOutlet UILabel* line;
@property (weak, nonatomic) IBOutlet UILabel* lbFilter;
@property MainScreenType screenType;
@end
