//
//  PageViewController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@end
