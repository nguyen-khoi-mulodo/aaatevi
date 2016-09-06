//
//  SubListVideoVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//


#import "GridViewBaseVC.h"
#import "DownloadManager.h"

@interface DownloadVC_iPad : GridViewBaseVC <DownloadManagerDelegate>
{
    IBOutlet UIGridView* gridView;
    IBOutlet UIView* nodataView;
    IBOutlet UILabel* lbNoData;
}

- (void) loadCategoryType:(int) categoryType andSreenType:(int) screenType andSubScreenType:(int) subScreen andIsEdit:(BOOL) showEdit;
@end
