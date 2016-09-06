//
//  MenuGenreViewController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/29/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import "MenuGenreViewController.h"
#import "MyButton.h"

@interface MenuGenreViewController () {
    UITableView *tbMain;
    UIView *headerView;
    MyButton *newBtn;
    MyButton *hotBtn;
    BOOL isExpanded;
    Genre *_genre;
    NSMutableArray *arrayAllGenres;
    UILabel *lblGenere;
    int indexSelected;
}

@end

@implementation MenuGenreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 64)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 47, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnBackTapped) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    lblGenere = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - 100, 47, 200, 30)];
    lblGenere.textAlignment = NSTextAlignmentCenter;
    lblGenere.textColor = [UIColor whiteColor];
    lblGenere.font = [UIFont fontWithName:@"SanFranciscoDisplay-Semibold.otf" size:17];
    lblGenere.text = @"Thể loại";
    [headerView addSubview:lblGenere];
    
    [self.view addSubview:headerView];
    
    tbMain = [[UITableView alloc]initWithFrame:CGRectMake(70, headerView.frame.size.height+20, SCREEN_SIZE.width - 70, SCREEN_SIZE.height - headerView.frame.size.height-20) style:UITableViewStylePlain];
    tbMain.dataSource = self;
    tbMain.delegate = self;
    tbMain.backgroundColor = [UIColor clearColor];
    tbMain.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.08];
    indexSelected = 0;
    [self.view addSubview:tbMain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataWithParentGenre:(NSString *)genreId {
    [[APIController sharedInstance]getListGenresWithParentId:genreId completed:^(int code, NSArray *results) {
        if (results) {
            indexSelected = 0;
            _arrayMainGenres = (NSMutableArray*)results;
            [tbMain reloadData];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - MyButton Action
- (void)btnBackTapped {
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - UITableView DataSource-Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayMainGenres.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *genreCellIdef = @"genreCellIdef";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:genreCellIdef];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:genreCellIdef];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    if (_arrayMainGenres.count > indexPath.row) {
        Genre *genre = [_arrayMainGenres objectAtIndex:indexPath.row];
        _genre = genre;
    }
    cell.textLabel.text = _genre.genreName;
    if (_genre.isParent) {
        cell.indentationLevel = 3;
    } else {
        cell.indentationLevel = 4;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == indexSelected) {
        //cell.contentView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        cell.contentView.backgroundColor = RGBA(34, 46, 51, 0.4);
    } else {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *tempArr = _arrayMainGenres;
    Genre *genre = [_arrayMainGenres objectAtIndex:indexPath.row];
    if (genre.isParent) {
        BOOL isTableExpanded = NO;
        for (Genre *child in genre.childGenres) {
            NSInteger index = [genre.childGenres indexOfObjectIdenticalTo:child];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        if (isTableExpanded) {
            [self collapseRows:(NSMutableArray*)genre.childGenres inIndexPath:indexPath];
        } else {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(Genre *innerG in genre.childGenres)
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:indexPath.section]];
                [tempArr insertObject:innerG atIndex:count++];
            }
            [tbMain insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationTop];
        }
    } else {
        indexSelected = (int)indexPath.row;
        [tbMain reloadData];
        [[APIController sharedInstance]getListChannelsWithGenreId:genre.genreId type:_type pageIndex:1 pageSize:kDefaultPageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
            if (results) {
                NSDictionary *dict = @{@"listChannelByGenre":results,@"genre":genre};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"didLoadChannelByGenre" object:nil userInfo:dict];
            } else if (code == kAPI_DATA_EMPTY) {
                results = [[NSMutableArray alloc]init];
                NSDictionary *dict = @{@"listChannelByGenre":results,@"genre":genre};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"didLoadChannelByGenre" object:nil userInfo:dict];
                [APPDELEGATE showToastWithMessage:@"Chưa có dữ liệu" position:@"top" type:errorImage];
            }
        } failed:^(NSError *error) {
            
        }];
        [self.sideMenuViewController hideMenuViewController];
    }
}

- (void)collapseRows:(NSMutableArray*)ar inIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray *tempArr = _arrayMainGenres;
    if (_genre.isParent) {
        for (Genre *g in _genre.childGenres) {
            NSUInteger indexToRemove=[tempArr indexOfObjectIdenticalTo:g];
            
            if([tempArr indexOfObjectIdenticalTo:g]!=NSNotFound)
            {
                [tempArr removeObjectIdenticalTo:g];
                [tbMain deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                          [NSIndexPath indexPathForRow:indexToRemove inSection:indexPath.section]
                                                          ]
                                        withRowAnimation:UITableViewRowAnimationTop];
            }
        }
    }
}
@end
