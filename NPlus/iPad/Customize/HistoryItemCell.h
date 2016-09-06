//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
#import "CDHistory.h"

@interface HistoryItemCell : UIGridViewCell{
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbSubtitle;
@property (weak, nonatomic) IBOutlet UILabel* lbTime;
@property (weak, nonatomic) IBOutlet UIImageView* iconHD;

- (void) setVideo:(CDHistory*) item;

@end

