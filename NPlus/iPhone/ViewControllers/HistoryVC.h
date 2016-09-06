//
//  HistoryVC.h
//  NPlus
//
//  Created by Anh Le Duc on 11/11/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@protocol HistoryDelegate <NSObject>
- (void) showVideo:(id) item andOtherItem:(id) otherItem;
- (void) showHistoryView:(BOOL) isShow;
@end

@interface HistoryVC : BaseVC<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id <HistoryDelegate> parentDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIView* viewHeader;
@property (weak, nonatomic) IBOutlet UIButton* btnDeleteHeader;
- (IBAction)btnDelete_Tapped:(id)sender;
- (IBAction)btnBack_Tapped:(id)sender;

@end
