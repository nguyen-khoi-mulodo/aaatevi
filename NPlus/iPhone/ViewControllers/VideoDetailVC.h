//
//  VideoDetailVC.h
//  NPlus
//
//  Created by TEVI Team on 8/28/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "BaseVC.h"
#import "THSegmentedPageViewControllerDelegate.h"
@interface VideoDetailVC : BaseVC<THSegmentedPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (nonatomic, strong) NSString *titleShow;
@property (nonatomic, strong) NSString *descriptionShow;
-(void)setDetailWithTitle:(NSString*)t withDescription:(NSString*)des;
- (void)setVideoViewCount:(NSInteger)view_count;
@end
