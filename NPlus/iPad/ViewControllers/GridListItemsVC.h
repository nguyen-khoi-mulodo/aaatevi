//
//  SubListVideoVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//


#import "GridViewBaseVC.h"
#import "BannerViewController.h"
#import "Constant.h"
#import "DownloadManager.h"


@interface GridListItemsVC : GridViewBaseVC <BannerViewControllerDelegate, DownloadManagerDelegate>
{
    IBOutlet UIGridView* gridView;
    BannerViewController* bannerItemView;
//    NSString* mDataType;
    UIPageControl *_pageControl;
    IBOutlet UILabel* lbNodata;
}

@property (nonatomic, strong) NSString* genreID;
@property (nonatomic, strong) NSString* subGenreID;
@property (nonatomic, strong) NSString* filterStr;
@property (nonatomic, weak) IBOutlet UIView* defaultView;

//- (void) setListType:(ListType) listType withDataType:(NSString*) dataType withGenreId:(NSString*) sId;
- (void) setFilterType:(NSString*) filterType andGenreId:(NSString*) gId;
@end
