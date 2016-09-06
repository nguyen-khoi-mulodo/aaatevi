//
//  ListHistoryController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "HomeVC.h"
#import "ConfirmAlertView.h"
#import "MyNavigationItem.h"

@interface ListHistoryController : HomeVC <UITableViewDelegate,UITableViewDataSource,MyNaviItemDelegate, ConfirmAlertDelegate>{
    NSMutableArray* itemsSelected;
    BOOL selectedAll;
    ConfirmAlertView* confirmView;
}

@end
