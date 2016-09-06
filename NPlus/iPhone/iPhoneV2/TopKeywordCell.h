//
//  TopKeywordCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/16/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopKeyword.h"

@interface TopKeywordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblKeyword;

@property (strong, nonatomic) TopKeyword *keyword;
- (void)loadContentWithIndex:(NSInteger)index;
@end
