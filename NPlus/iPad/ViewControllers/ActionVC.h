//
//  ActionVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 2/18/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QualityURL.h"

@protocol ActionDelegate <NSObject>
- (void) boXemSau;
- (void) boFollow;
- (void) copyLink;
- (void) shareFacebook;
- (void) downloadWithQuantity:(QualityURL*) quality;
- (void) doChooseQuality:(QualityURL*) quality;
@end

@interface ActionVC : UIViewController{
    NSArray* arrImages;
}
@property (nonatomic, strong) IBOutlet UITableView* myTableView;
@property (nonatomic, strong) NSArray* arrTitles;
@property (nonatomic, strong) id <ActionDelegate> delegate;
@property ListType type;
@property (nonatomic, strong) QualityURL* mQuality;
- (void) loadDataWithType:(ListType) listType;
- (void) loadDataWithArray:(NSArray*) array andType:(ListType) listType;
@end
