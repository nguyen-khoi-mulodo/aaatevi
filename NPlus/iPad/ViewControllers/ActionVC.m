//
//  ActionVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 2/18/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import "ActionVC.h"
#import "Constant.h"

#define Xoa       @"Xoá"
#define ChiaSe    @"Share Facebook"
#define CopyLink  @"Copy Link"
#define BoXemSau  @"Bỏ xem sau"
#define DanhGia   @"Đánh giá"
#define BoTheoDoi @"Bỏ theo dõi"


@interface ActionVC ()

@end

@implementation ActionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void) loadDataWithType:(ListType) listType{
    self.type = listType;
    if (listType == video_type) {
        _arrTitles = @[ChiaSe, BoXemSau];
        arrImages = @[@"icon-moreoption-share", @"icon-boxemsau"];
    }else if(listType == channel_type){
        _arrTitles = @[ChiaSe, BoTheoDoi];
        arrImages = @[@"icon-moreoption-share", @"icon-botheodoi"];
    }else if(listType == share_type){
        _arrTitles = @[ChiaSe, CopyLink];
//        arrImages = @[@"icon-chiase-video", @"icon-theodoi"];
    }
    [self.myTableView reloadData];
}

- (void) loadDataWithArray:(NSArray*) array andType:(ListType) listType{
    self.type = listType;
    _arrTitles = array;
    arrImages = @[];
    [self.myTableView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrTitles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    [cell.textLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    if (_arrTitles.count > indexPath.row) {
        NSString* strTitle;
        if (self.type == video_type || self.type == channel_type || self.type == share_type) {
            strTitle = [_arrTitles objectAtIndex:indexPath.row];
        }else if(self.type == action_download_type || self.type == action_quality_type){
            QualityURL* quality = [_arrTitles objectAtIndex:indexPath.row];
            strTitle = quality.type;
            if (self.type == action_quality_type && [strTitle isEqualToString:self.mQuality.type]) {
                [cell.textLabel setTextColor:UIColorFromRGB(0x00adef)];
            }
        }
        [cell.textLabel setText:strTitle];
//        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        NSString* strImage = nil;
        if (arrImages.count > indexPath.row) {
            strImage = [arrImages objectAtIndex:indexPath.row];
        }
        if (![strImage isEqualToString:@""] || strImage) {
            [cell.imageView setImage:[UIImage imageNamed:strImage]];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == video_type || self.type == channel_type || self.type == share_type) {
        if (self.arrTitles.count > indexPath.row) {
            NSString* str = [self.arrTitles objectAtIndex:indexPath.row];
            if ([str isEqualToString:BoXemSau]) {
                [self boXemSau];
            }else if([str isEqualToString:BoTheoDoi]){
                [self boFollow];
            }else if([str isEqualToString:CopyLink]){
                [self copyLink];
            }else if([str isEqualToString:ChiaSe]){
                [self shareFacebook];
            }
        }
    }else if(self.type == action_quality_type){
        if (self.arrTitles.count > indexPath.row) {
            QualityURL* quality = [self.arrTitles objectAtIndex:indexPath.row];
            [self doChooseQuality:quality];
        }
    }else if(self.type == action_download_type){
        if (self.arrTitles.count > indexPath.row) {
            QualityURL* quality = [self.arrTitles objectAtIndex:indexPath.row];
            [self downloadWithQuantity:quality];
        }
    }
    
}


- (void) boXemSau{
    if (self.delegate && [self.delegate respondsToSelector:@selector(boXemSau)]) {
        [self.delegate boXemSau];
    }
}

- (void) boFollow{
    if (self.delegate && [self.delegate respondsToSelector:@selector(boFollow)]) {
        [self.delegate boFollow];
    }
}

- (void) copyLink{
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyLink)]) {
        [self.delegate copyLink];
    }
}

- (void) shareFacebook{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareFacebook)]) {
        [self.delegate shareFacebook];
    }
}

- (void) downloadWithQuantity:(QualityURL*) quality{
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadWithQuantity:)]) {
        [self.delegate downloadWithQuantity:quality];
    }
}

- (void) doChooseQuality:(QualityURL*) quality{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doChooseQuality:)]) {
        [self.delegate doChooseQuality:quality];
    }
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
