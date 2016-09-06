//
//  CartoonVC.h
//  NPlus
//
//  Created by Anh Le Duc on 8/19/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface CartoonVC : BaseVC<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnHot;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIView *viewTab;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (nonatomic, assign) NSInteger curTab;
- (IBAction)changeTab:(id)sender;
- (IBAction)btnBack_Tapped:(id)sender;

@end
