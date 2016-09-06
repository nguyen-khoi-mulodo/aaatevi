//
//  DownloadedVC.h
//  NPlus
//
//  Created by Anh Le Duc on 10/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface DownloadedVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
- (void)onEdit:(BOOL)edit;
- (void)onCheckAll:(BOOL)checkAll;
- (void)onDelete;
@end
