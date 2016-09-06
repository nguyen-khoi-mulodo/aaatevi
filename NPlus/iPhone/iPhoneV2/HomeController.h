//
//  HomeController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/20/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "BaseVC.h"
#import "CycleScrollView.h"
#import "ILTranslucentView.h"
#import "HomeItem.h"
#import "HomeItemCell.h"
#import "HomeHeaderSection.h"
#import "MyNavigationItem.h"

@interface HomeController : BaseVC <CycleScrollViewDelegate,UITableViewDelegate, UITableViewDataSource,HomeItemCellDelegate,UISearchBarDelegate,HomeHeaderSectionDelegate, UINavigationControllerDelegate> {
    CycleScrollView *_cycleScroll;
    UIPageControl *_pageControl;
    UIRefreshControl *refreshControl;
    MyNavigationItem *myNaviItem;
    //UITableViewController *tableViewController;
    BOOL isUp;
}
@property (weak, nonatomic) IBOutlet UIView *viewShowcase;
@property (weak, nonatomic) IBOutlet UIView *viewGenre;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;

@property (weak, nonatomic) IBOutlet UIButton *btnShortFilm;
@property (weak, nonatomic) IBOutlet UIButton *btnTVShow;
@property (weak, nonatomic) IBOutlet UIButton *btnRelax;
@property (weak, nonatomic) IBOutlet UIView *viewNoConnection;


@property (strong, nonatomic) HomeItem *homeItem;

@end
