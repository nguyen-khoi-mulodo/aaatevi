//
//  HomeHeaderSection.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/25/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeHeaderSectionDelegate <NSObject>

- (void)headerTappedWithTitle:(NSString*)headerTitle isHide:(BOOL)hidden;

@end

@interface HomeHeaderSection : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIImageView *iconHeader;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property BOOL isHideButton;

@property (strong, nonatomic) id<HomeHeaderSectionDelegate> delegate;

@end
