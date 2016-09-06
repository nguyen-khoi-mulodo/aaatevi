//
//  MyNavigationItem.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/21/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import "MyNavigationItem.h"
#import "AKTabBarController.h"
#import "GenreController.h"

@implementation MyNavigationItem

- (id)initWithController:(UIViewController*)vc type:(int)type{
    self = [super init];
    if (self) {
        _type = type;
        _ownerVC = vc;
        _logoView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 24)];
        [_logoView setImage:[UIImage imageNamed:@"logo-tevi"] forState:UIControlStateNormal];
        [_logoView addTarget:self action:@selector(btnLogoAction) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        _rightBtn.exclusiveTouch = YES;
        if (type == 1 || type == 6) {
            if (type == 1) {
                [_rightBtn setImage:[UIImage imageNamed:@"icon-search-v2"] forState:UIControlStateNormal];
            }
            
            UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithCustomView:_logoView];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                            target:nil action:nil];
            negativeSpacer.width = 20;
            UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                            target:nil action:nil];
            negativeSpacer1.width = -10;
            vc.navigationItem.leftBarButtonItems = @[negativeSpacer1,logo,negativeSpacer];
            
            
        } else if (type == 2){
            _txfSearchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width,36)];
            _txfSearchField.borderStyle = UITextBorderStyleNone;
            _txfSearchField.frame = CGRectMake(0, 0, SCREEN_SIZE.width,36);
            _txfSearchField.backgroundColor = RGBA(171, 174, 174, 0.15);
            _txfSearchField.textColor = UIColorFromRGB(0x212121);
            _txfSearchField.tintColor = UIColorFromRGB(0x212121);
            _txfSearchField.placeholder = @"Tìm kiếm";
            
            _txfSearchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tìm kiếm"
                                                                            attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xa4a4a4), NSFontAttributeName : [UIFont fontWithName:kFontRegular size:15.0]
                                                                                         }
                                             ];
            _txfSearchField.clipsToBounds = YES;
            _txfSearchField.layer.cornerRadius = 5;
            UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-search-thumb-v2"]];
            [leftView setFrame:CGRectMake(0, 0, 35,35)];
            leftView.contentMode = UIViewContentModeCenter;
            _txfSearchField.leftView = leftView;
            _txfSearchField.leftViewMode = UITextFieldViewModeAlways;
            _txfSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
            //[titleView addSubview:txfSearchField];
            vc.navigationItem.titleView = _txfSearchField;
            
            UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [backBtn setImage:[UIImage imageNamed:@"icon-back-v2"] forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
            vc.navigationItem.leftBarButtonItem = backItem;
            backBtn.hidden = YES;
            [_rightBtn setBackgroundColor:[UIColor clearColor]];
            _rightBtn.frame = CGRectMake(0, 0, 40, 40);
            [_rightBtn setImage:nil forState:UIControlStateNormal];
            [_rightBtn setTitle:@"Hủy" forState:UIControlStateNormal];
            [_rightBtn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
        } else if (type == 3) {
            UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithCustomView:_logoView];
            vc.navigationItem.leftBarButtonItem = logo;
            [_rightBtn setImage:[UIImage imageNamed:@"icon-setting"] forState:UIControlStateNormal];
            [_rightBtn setImage:[UIImage imageNamed:@"icon-setting-press"] forState:UIControlStateHighlighted];
            
            //[_rightBtn addTarget:self action:@selector(rightBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        } else if (type == 4 || type == 5 || type == 8 || type == 9 || type == 10) {
            _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            [_leftBtn setImage:[UIImage imageNamed:@"icon-back-v2"] forState:UIControlStateNormal];
            [_leftBtn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
            [_leftBtn.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17]];
            _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
            [_leftBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _leftBtn.exclusiveTouch = YES;
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                            target:nil action:nil];
            negativeSpacer.width = -10;

            vc.navigationItem.leftBarButtonItems = @[negativeSpacer,backItem] ;
            
            if (type == 4) {
                [_rightBtn setImage:[UIImage imageNamed:@"icon-menu"] forState:UIControlStateNormal];
                [_rightBtn setImage:[UIImage imageNamed:@"icon-menu-press"] forState:UIControlStateHighlighted];
            } else if (type == 5){
                [_rightBtn setImage:[UIImage imageNamed:@"icon-share"] forState:UIControlStateNormal];
                [_rightBtn setImage:[UIImage imageNamed:@"icon-share-h-v2"] forState:UIControlStateHighlighted];
            } else if (type == 8 || type == 10){
                [_rightBtn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
                [_rightBtn.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17]];
                [_rightBtn setImage:[UIImage imageNamed:@"icon-xoa-v2"] forState:UIControlStateNormal];
                [_rightBtn setImage:[UIImage imageNamed:@"icon-xoa-h-v2"] forState:UIControlStateHighlighted];
                
                if (type == 10) {
                    [_leftBtn setImage:nil forState:UIControlStateNormal];
                    _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
                }
                
            } else if (type == 9) {
                _rightBtn = nil;
            }
        }
        if (_rightBtn) {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
            
            negativeSpacer.width = -10;
            UIBarButtonItem *btHis = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
            vc.navigationItem.rightBarButtonItems = @[negativeSpacer,btHis];
            [_rightBtn addTarget:self action:@selector(rightBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [vc.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:kFontSemibold size:18.0f],NSForegroundColorAttributeName: UIColorFromRGB(0x212121)}];
        [vc.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-header-top-v2"]
                                                      forBarMetrics:UIBarMetricsDefault];
        vc.navigationController.navigationBar.translucent = YES;
        vc.navigationController.view.backgroundColor = [UIColor lightTextColor];
        vc.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void) addBlurEffect:(UIViewController*)vc {
    // Add blur view
    CGRect bounds = vc.navigationController.navigationBar.bounds;
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.frame = bounds;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [vc.navigationController.navigationBar addSubview:visualEffectView];
    vc.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [vc.navigationController.navigationBar sendSubviewToBack:visualEffectView];
    
    // Here you can add visual effects to any UIView control.
    // Replace custom view with navigation bar in above code to add effects to custom view.
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)backBtnAction:(id)sender {
    if (self.searchBar) {
        [self.searchBar resignFirstResponder];
    }
    [_ownerVC.navigationController popViewControllerAnimated:YES];
    //[APPDELEGATE.rootNavController.topViewController.navigationController popViewControllerAnimated:YES];
}
- (void) btnLogoAction {
    if (APPDELEGATE.tabBarController) {
        UIViewController *vc = APPDELEGATE.tabBarController.viewControllers[0];
        
        if (APPDELEGATE.tabBarController.selectedViewController == vc)
        {
            if ([vc isKindOfClass:[UINavigationController class]])
                [(UINavigationController *)APPDELEGATE.tabBarController.selectedViewController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [[APPDELEGATE.tabBarController navigationItem] setTitle:[vc title]];
            APPDELEGATE.tabBarController.selectedViewController = vc;
        }
    }
}
- (void)rightBtnTap:(id)sender {
    //[_delegate didRightButtonTapWithType:_type];
    if (_type == 1) {
        GenreController *searchVC = [[GenreController alloc]initWithNibName:@"GenreController" bundle:nil];
        searchVC.isSearch = YES;
        searchVC.listSearch = [[NSMutableArray alloc]initWithArray:@[@"Video",@"Kênh",@"Nghệ sĩ"]];
        searchVC.hidesBottomBarWhenPushed = YES;
        [_ownerVC.navigationController pushViewController:searchVC animated:NO];
    } else if (_type == 2){
        [_ownerVC.navigationController popViewControllerAnimated:NO];
    } else if (_type == 3){
        
    } else if (_type == 4){
        APPDELEGATE.nowPlayerVC.view.hidden = YES;
        if ([_ownerVC.sideMenuViewController.rightMenuViewController isKindOfClass:[MenuGenreViewController class]]) {
            MenuGenreViewController *menuVC = (MenuGenreViewController*)_ownerVC.sideMenuViewController.rightMenuViewController;
            menuVC.type = _typeData;
            [_ownerVC.sideMenuViewController presentRightMenuViewController];
        }
    } else if (_type == 5 || _type == 8 || _type == 10){
        if (_type == 8 || _type == 10) {
            if (!_rightBtn.selected) {
                _rightBtn.frame = CGRectMake(0, 0, 35, 30);
                [_rightBtn setImage:nil forState:UIControlStateNormal];
                [_rightBtn setImage:nil forState:UIControlStateHighlighted];
                [_rightBtn setTitle:@"Hủy" forState:UIControlStateNormal];
                
                _leftBtn.frame = CGRectMake(0, 0, 100, 30);
                [_leftBtn setImage:nil forState:UIControlStateNormal];
                [_leftBtn setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
                _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
                [_leftBtn removeTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [_leftBtn addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                _rightBtn.frame = CGRectMake(0, 0, 28, 28);
                [_rightBtn setImage:[UIImage imageNamed:@"icon-xoa-v2"] forState:UIControlStateNormal];
                [_rightBtn setImage:[UIImage imageNamed:@"icon-xoa-h-v2"] forState:UIControlStateHighlighted];
                [_rightBtn setTitle:@"" forState:UIControlStateNormal];
                
                _leftBtn.frame = CGRectMake(0, 0, 30, 30);
                [_leftBtn setImage:[UIImage imageNamed:@"icon-back-v2"] forState:UIControlStateNormal];
                [_leftBtn setTitle:@"" forState:UIControlStateNormal];
                [_leftBtn removeTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
                [_leftBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        if (_delegate && [_delegate respondsToSelector:@selector(didRightButtonTapWithType:)]) {
            [_delegate didRightButtonTapWithType:_type];
        }
    }
}

- (void) leftButtonTapped{
    if (_delegate && [_delegate respondsToSelector:@selector(didLeftButtonTap)]) {
        [_delegate didLeftButtonTap];
    }
}

@end
