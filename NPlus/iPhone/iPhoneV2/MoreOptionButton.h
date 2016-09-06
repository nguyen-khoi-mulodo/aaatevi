//
//  MoreOptionButton.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/9/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreOptionButton : UIButton

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) NSString *iconDefaultName;
@property (nonatomic, strong) NSString *iconSelectedName;
- (id)initWithFrame:(CGRect)frame iconDefault:(NSString*)iconName iconSelected:(NSString*)iconSelectedName title:(NSString*)title;

@end
