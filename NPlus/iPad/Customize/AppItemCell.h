//
//  AppItemCell.h
//  XoSo
//
//  Created by Vo Chuong Thien on 5/6/15.
//  Copyright (c) 2015 Khoi Nguyen Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelatedItem.h"

@protocol AppItemDelegate <NSObject>
- (void) showWebViewWithURL:(NSString*) url;
@end

@interface AppItemCell : UITableViewCell{
    IBOutlet UILabel* lbDes;
    IBOutlet UILabel* lbName;
    IBOutlet UIImageView* imgIcon;
    IBOutlet UIButton *btnDownload;
    RelatedItem *appItemCurrent;
}

@property (nonatomic, strong) id <AppItemDelegate> delegate;

- (void) setContentWithAppItem:(RelatedItem*) item;
@end
