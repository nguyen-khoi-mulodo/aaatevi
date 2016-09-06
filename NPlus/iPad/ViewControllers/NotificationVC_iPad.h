//
//  SubListVideoVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//


#import "GridViewBaseVC.h"
#import "NOtificationItemCell.h"

@interface NotificationVC_iPad : GridViewBaseVC <NotificationItemDelegate>
{
    IBOutlet UIGridView* gridView;
    IBOutlet UIView* vNoData;
    IBOutlet UILabel* lbNodata;
}

- (void) loadListChannelLiked;


@end
