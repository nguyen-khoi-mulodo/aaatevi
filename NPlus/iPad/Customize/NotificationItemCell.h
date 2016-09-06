//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
#import "LocalNotif.h"


@protocol NotificationItemDelegate <NSObject>
//- (void) shareFacebookWithItem:(id) item;
@end

@interface NotificationItemCell : UIGridViewCell {
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbDate;

@property (nonatomic, strong) LocalNotif* mNoti;
@property (nonatomic, strong) id <NotificationItemDelegate> delegate;


- (void) setContent:(LocalNotif *) item;

@end

