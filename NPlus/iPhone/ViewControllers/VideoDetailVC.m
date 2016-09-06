//
//  VideoDetailVC.m
//  NPlus
//
//  Created by TEVI Team on 8/28/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "VideoDetailVC.h"
#define kSECTION_VIDEO_DESCRIPTION 0
@interface VideoDetailVC ()<UITableViewDataSource, UITableViewDelegate>{
    UIView *_viewDetail;
    float heightSectionDetail;
}

@end

@implementation VideoDetailVC
-(NSString *)screenNameGA{
    return @"VideoDetail.VideoDescription";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _viewDetail = [[UIView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 300)];
    _viewDetail.layer.cornerRadius = 1.0f;
    _viewDetail.layer.borderWidth = 0.5f;
    _viewDetail.layer.borderColor = RGB(206, 206, 206).CGColor;
    _viewDetail.backgroundColor = [UIColor whiteColor];
    
    _tbMain.delegate = self;
    _tbMain.dataSource = self;
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbMain.backgroundColor = BACKGROUND_COLOR;
    _tbMain.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)viewControllerTitle{
    return @"Chi tiết";
}

-(void)setDetailWithTitle:(NSString *)t withDescription:(NSString *)des{
    self.titleShow = t;
    self.descriptionShow = des;
    [self addObjectToView:_viewDetail inSection:kSECTION_VIDEO_DESCRIPTION];
    [_tbMain reloadData];
}

- (void) addObjectToView: (UIView *) sview inSection: (NSInteger ) section
{
    for (UIView *view in [sview subviews])
    {
        [view removeFromSuperview];
    }
    float dY = 60.0f;
    
    UILabel *lbSection = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 30, 20)];
    lbSection.text = self.titleShow;
    lbSection.textColor = RGB(0, 0, 0);
    lbSection.backgroundColor = [UIColor clearColor];
    lbSection.font = [UIFont boldSystemFontOfSize:14.0f];
    [sview addSubview:lbSection];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 15, 11)];
    imageView.image = [UIImage imageNamed:@"icon_view_count"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.hidden = YES;
    [sview addSubview:imageView];
    
    UILabel *lbViewCount = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 60, 20)];
    lbViewCount.backgroundColor = [UIColor clearColor];
    lbViewCount.font = [UIFont systemFontOfSize:12.0f];
    lbViewCount.textColor = RGB(116, 116, 116);
    lbViewCount.tag = 777;
    lbViewCount.hidden = YES;
    [sview addSubview:lbViewCount];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH - 30, 1)];
    sep.backgroundColor = RGB(231, 231, 231);
    [sview addSubview:sep];
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, dY, SCREEN_WIDTH - 30, 300)];
    txtView.text = self.descriptionShow;
    txtView.backgroundColor = [UIColor clearColor];
    txtView.font = [UIFont systemFontOfSize:14.0f];
    txtView.textColor = RGB(116, 116, 116);
    [txtView sizeToFit];
    txtView.editable = NO;
    txtView.bounces = NO;
    [txtView setScrollEnabled:NO];
    [txtView setUserInteractionEnabled:NO];
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        txtView.textContainer.lineFragmentPadding = 0;
        txtView.textContainerInset = UIEdgeInsetsZero;
    }
    [sview addSubview:txtView];
    
    heightSectionDetail = txtView.frame.size.height + 60;
    
    _viewDetail.frame = CGRectMake(5, 5, SCREEN_WIDTH - 10, heightSectionDetail);
}

-(void)setVideoViewCount:(NSInteger)view_count{
    UILabel *lb = (UILabel*)[_viewDetail viewWithTag:777];
    if (lb) {
        NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
        [frmtr setGroupingSize:3];
        [frmtr setGroupingSeparator:@","];
        [frmtr setUsesGroupingSeparator:YES];
        NSString *commaString = [frmtr stringFromNumber:[NSNumber numberWithInteger:view_count]];
        lb.text = [NSString stringWithFormat:@"%@ lượt xem", commaString];
    }
}

#pragma mark UITableView delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightSectionDetail;
}

- (UITableViewCell *) tableView:(UITableView *)btableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *descriptionCellID		=   @"descriptionCellID";
    UITableViewCell *cell = [btableView dequeueReusableCellWithIdentifier:descriptionCellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:descriptionCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:_viewDetail];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
}


@end
