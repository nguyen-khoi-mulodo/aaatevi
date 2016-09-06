//
//  IntroVC.h
//  XoSo
//
//  Created by Vo Chuong Thien on 5/6/15.
//  Copyright (c) 2015 Khoi Nguyen Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItemCell.h"
//#import "UIController.h"

@interface OtherApps : BaseVC <AppItemDelegate>{
    IBOutlet UITableView *myTableView;
}
@property (nonatomic, strong) NSMutableArray* listApps;
@end
