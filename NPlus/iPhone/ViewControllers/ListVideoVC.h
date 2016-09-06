//
//  ListVideoVC.h
//  NPlus
//
//  Created by Anh Le Duc on 8/20/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface ListVideoVC : BaseVC
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (nonatomic, assign) kItemCollectionType itemCollectionType;
@property (nonatomic, strong) Channel *currentItem;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

- (IBAction)btnBack_Tapped:(id)sender;
@end
