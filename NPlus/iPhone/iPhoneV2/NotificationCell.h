//
//  NotificationCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/28/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalNotif.h"

@interface NotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (strong, nonatomic) LocalNotif *localNotif;
- (void)loadData;

@end
