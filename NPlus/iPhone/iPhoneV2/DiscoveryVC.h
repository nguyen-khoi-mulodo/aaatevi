//
//  DiscoveryVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 4/28/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverGenreItemCell.h"

@interface DiscoveryVC : BaseVC <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, DiscoverGenreItemDelegate>{
    IBOutlet UILabel* lbTitleTopKeys;
    IBOutlet UIView* genreView;
    IBOutlet UIView* tagsView;
    IBOutlet UIView* tagsContent;
    NSArray* arrTopKeys;
    NSArray* arrGenres;
    NSString* listIds;
    BOOL isUp;
    IBOutlet UIActivityIndicatorView* loadingTopKeys;
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (weak, nonatomic) IBOutlet UIButton *btnShortFilm;
@property (weak, nonatomic) IBOutlet UIButton *btnTVShow;
@property (weak, nonatomic) IBOutlet UIButton *btnRelax;
@property (weak, nonatomic) IBOutlet UIView *_viewNoConnection;

@end
