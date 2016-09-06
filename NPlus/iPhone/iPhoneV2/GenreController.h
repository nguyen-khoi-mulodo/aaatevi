//
//  GenreController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/12/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeVC.h"
#import "XLButtonBarPagerTabStripViewController.h"

@interface GenreController : XLButtonBarPagerTabStripViewController
@property (strong, nonatomic) IBOutlet UIView *headerKeyword;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *viewAll;
@property (weak, nonatomic) IBOutlet UIView *lineSelected;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectAll;
@property (strong, nonatomic) NSMutableArray *listGenres;
@property (strong, nonatomic) NSMutableArray *listSearch;
@property (strong, nonatomic) Genre *genre;
@property (strong, nonatomic) IBOutlet UIButton *btnTitleGenre;
@property (strong, nonatomic) IBOutlet UIView *viewParentGenre;
@property (strong, nonatomic) IBOutlet UIButton *btnFilter;
@property (strong, nonatomic) NSString *type;
@property (weak, nonatomic) IBOutlet UIButton *btnShortFilm;
@property (weak, nonatomic) IBOutlet UIButton *btnTVShow;
@property (weak, nonatomic) IBOutlet UIButton *btnRelax;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil listGenres:(NSMutableArray*)listGenres indexTab:(NSUInteger)index ;

@end
