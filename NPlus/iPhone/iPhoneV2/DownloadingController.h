//
//  ListHistoryController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "HomeVC.h"
#import "DownloadManager.h"
#import "ConfirmAlertView.h"
#import "MyNavigationItem.h"

@interface DownloadingController : HomeVC <UITableViewDelegate,UITableViewDataSource,MyNaviItemDelegate, DownloadManagerDelegate, ConfirmAlertDelegate>{
    NSMutableArray* itemsSelected;
    BOOL selectedAll;
    
    IBOutlet UIView* headerView;
    IBOutlet UIView* footerView;
    IBOutlet UILabel* lbDiskSpace;
    
    // header
    IBOutlet UIButton* btnHeader;
    IBOutlet UILabel* lbHeader;
    
    BOOL isStoppingAll;
    ConfirmAlertView* confirmView;
}


@end
