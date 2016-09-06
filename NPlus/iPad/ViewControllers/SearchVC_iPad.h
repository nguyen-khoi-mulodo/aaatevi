//
//  SearchVC_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 11/3/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalViewController.h"
#import "CustomSegmentedControl.h"
#import "SearchListItemsVC.h"

@interface SearchVC_iPad : GlobalViewController<GridViewBaseDelegate, UIGestureRecognizerDelegate, CustomSegmentedControlDelegate>
{
    // Search Field
    IBOutlet UIButton* btnHuy;
    IBOutlet UITextField* txtSearch;
    
    // View Result
    IBOutlet UIView* defaultView;
    IBOutlet UIView* topKeysView;
    IBOutlet UIView* topKeysSubView;
    SearchListItemsVC* contentVC;
    IBOutlet UILabel* lbNotiSearch;
    
    // HeaderView
    IBOutlet UIView* headerView;
    IBOutlet UIView* menuView;
    IBOutlet UIView* maskView;
    
    NSString* mKeyWord;
    CustomSegmentedControl* segment;
    ListType mListType;
    
    NSArray* arrTopKeys;
}



@end
