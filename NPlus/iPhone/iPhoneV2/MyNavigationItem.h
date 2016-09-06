//
//  MyNavigationItem.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/21/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyNaviItemDelegate <NSObject>

- (void)didRightButtonTapWithType:(int)type;
- (void)didLeftButtonTap;

@end

@interface MyNavigationItem : NSObject {
    int _type;
}

- (id)initWithController:(UIViewController*)vc type:(int)type;

@property (nonatomic, strong) NSString *typeData;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *logoView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIViewController *ownerVC;
@property (nonatomic, strong) id <MyNaviItemDelegate> delegate;
@property (nonatomic, strong) UITextField *txfSearchField;
@end
