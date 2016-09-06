//
//  DetailGenreController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/12/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeVC.h"
#import "XLPagerTabStripViewController.h"
#import "HomeItemCell.h"

@interface DetailGenreController : HomeVC <XLPagerTabStripChildItem,HomeItemCellDelegate>

@property (nonatomic, strong) Genre *genre;
@property (nonatomic, strong) NSString *type;
@property BOOL isNotLoading;

- (void)loadDataIsAnimation:(BOOL)isAnimation;

@end
