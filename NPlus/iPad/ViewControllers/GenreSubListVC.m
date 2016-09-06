//
//  CategoryListVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/11/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "GenreSubListVC.h"

@interface GenreSubListVC ()
@end

@implementation GenreSubListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = BACKGROUND_COLOR;
    _tbMain.backgroundColor = [UIColor whiteColor];
    [_tbMain setFrame:CGRectMake(0, 0, 320, 480)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Load Data

- (void)loadData:(NSArray*) list andTitle:(NSString*) title{
    [self.navigationItem setTitle:title];
    [self.dataSources removeAllObjects];
    [self.dataSources addObjectsFromArray:list];
    [_tbMain reloadData];
}

#pragma mark TableView Delegate

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
    if ([_tbMain respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tbMain setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tbMain respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tbMain setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImage* imgCheck = [UIImage imageNamed:@"icon-checked"];
        UIImageView* checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, imgCheck.size.width, imgCheck.size.height)];
        [checkImageView setImage:imgCheck];
        [checkImageView setTag:1000];
        [cell addSubview:checkImageView];
    }
    
    UIImageView* checkImageView = [cell viewWithTag:1000];
    if (indexPath.row < self.dataSources.count) {
        Genre* genre = [self.dataSources objectAtIndex:indexPath.row];
        if (self.genreId) {
            [checkImageView setHidden:![genre.genreId isEqualToString:self.genreId]];
        }else{
            [checkImageView setHidden:YES];
        }
        cell.textLabel.text = genre.genreName;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = RGB(0, 0, 0);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSources.count) {
        Genre* genre = [self.dataSources objectAtIndex:indexPath.row];
        self.genreId = genre.genreId;
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectGenreFromSubListGenre:withGenreTitle:)]) {
            [self.delegate selectGenreFromSubListGenre:self.genreId withGenreTitle:genre.genreName];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}



@end
