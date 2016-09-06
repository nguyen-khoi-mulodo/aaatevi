//
//  VideoDetailLandscapeVC.m
//  NPlus
//
//  Created by TEVI Team on 9/23/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "VideoDetailLandscapeVC.h"

@interface VideoDetailLandscapeVC ()
@end

@implementation VideoDetailLandscapeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _scrollMain.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)loadData{
    NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
    Channel *show = nowVC.curChannel;
    if (show) {//_txtTitle.frame.origin.y + _txtTitle.frame.size.height + 10
        UITextView *txtTitle = (UITextView*)[_scrollMain viewWithTag:100];
        if (txtTitle == nil) {
            txtTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
            txtTitle.tag = 100;
            txtTitle.textColor = [UIColor whiteColor];
            txtTitle.backgroundColor = [UIColor clearColor];
            txtTitle.font = [UIFont boldSystemFontOfSize:18.0f];
            txtTitle.editable = NO;
            txtTitle.bounces = NO;
            [txtTitle setScrollEnabled:NO];
            [txtTitle setUserInteractionEnabled:NO];
            if (IOS_NEWER_OR_EQUAL_TO_7) {
                txtTitle.textContainer.lineFragmentPadding = 0;
                txtTitle.textContainerInset = UIEdgeInsetsZero;
            }
            [_scrollMain addSubview:txtTitle];
        }
        txtTitle.text = show.channelName;
        [txtTitle sizeThatFits:CGSizeMake(320, 999)];
        
        
        UITextView *txtDesc = (UITextView*)[_scrollMain viewWithTag:101];
        if (txtDesc == nil) {
            txtDesc = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
            txtDesc.tag = 101;
            txtDesc.textColor = RGB(116, 116, 116);
            txtDesc.font = [UIFont systemFontOfSize:14.0f];
            txtDesc.backgroundColor = [UIColor clearColor];
            
            txtDesc.editable = NO;
            txtDesc.bounces = NO;
            [txtDesc setScrollEnabled:NO];
            [txtDesc setUserInteractionEnabled:NO];
            if (IOS_NEWER_OR_EQUAL_TO_7) {
                txtDesc.textContainer.lineFragmentPadding = 0;
                txtDesc.textContainerInset = UIEdgeInsetsZero;
            }
            [_scrollMain addSubview:txtDesc];
        }
        txtDesc.text = show.channelDes;
        [txtDesc sizeToFit];
        CGRect frame = txtDesc.frame;
        frame.origin.y = txtTitle.frame.origin.y + txtTitle.frame.size.height + 10;
        txtDesc.frame = frame;
        _scrollMain.contentSize = CGSizeMake(300, txtTitle.bounds.size.height + txtDesc.bounds.size.height + 20);
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
