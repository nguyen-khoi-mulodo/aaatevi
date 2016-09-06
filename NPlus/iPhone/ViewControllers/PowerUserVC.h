//
//  PowerUserVC.h
//  NPlus
//
//  Created by Anh Le Duc on 11/12/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface PowerUserVC : BaseVC
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnStore;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
- (IBAction)btnBack_Tapped:(id)sender;

@end
