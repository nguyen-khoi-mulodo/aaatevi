//
//  ListHistoryController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "HomeVC.h"
#import "DownloadingController.h"
#import "DownloadManager.h"
#import "ConfirmAlertView.h"

@interface DownloadController : HomeVC <UITableViewDelegate, UITableViewDataSource, MyNaviItemDelegate, DownloadManagerDelegate, ConfirmAlertDelegate>{
    NSMutableArray* itemsSelected;
    BOOL selectedAll;
    
    IBOutlet UIView* headerView;
    IBOutlet UIView* footerView;
    IBOutlet UIProgressView* processView;
    IBOutlet UILabel* lbSoLuong;
    IBOutlet UILabel* lbTitle;
    IBOutlet UILabel* lbSize;
    DownloadingController* downloadingVC;
    NSArray* arrayDownloading;
    IBOutlet UILabel* lbDiskSpace;
    FileDownloadInfo* downloadInfoCurrent;
    ConfirmAlertView* confirmView;
}

//@property (weak, nonatomic) IBOutlet UIView* noDataView;
//@property (weak, nonatomic) IBOutlet UILabel *lbNodata;
//@property (weak, nonatomic) IBOutlet UIImageView *imgViewNodata;


@end
