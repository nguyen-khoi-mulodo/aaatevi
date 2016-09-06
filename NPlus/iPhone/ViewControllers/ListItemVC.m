//
//  ListItemVC.m
//  NPlus
//
//  Created by Anh Le Duc on 9/10/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "ListItemVC.h"
#import "RowTable.h"
#import "Genre.h"
@interface ListItemVC ()<RowTableDelegate>{
    NSMutableArray *_lstGenre;
    RowTable *_rowTable;
    NSString *_genreId;
}

@end

@implementation ListItemVC
@synthesize collectionType = _collectionType;
@synthesize delegate = _delegate;
@synthesize isHot = _isHot;
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
    _lstGenre = [[NSMutableArray alloc] init];
    _genreId = nil;
    self.view.clipsToBounds = NO;
    self.cvMain.clipsToBounds = NO;
    self.cvMain.contentInset = UIEdgeInsetsMake(64, 0, 50, 0);
    self.cvMain.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 50, 0);
}

-(NSString *)screenNameGA{
    return [self parent];
}

- (NSString*)parent{
    id parentVC = self.parentViewController.parentViewController;
    if (parentVC && [parentVC respondsToSelector:@selector(screenNameGA)]) {
        return [NSString stringWithFormat:@"%@", [parentVC screenNameGA]];
    }
    return @"NotSet";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)loadData{
    if (_genreId!=nil) {
        if (_delegate && [_delegate respondsToSelector:@selector(loadDataWithCurPage:withGenreId:withViewController:)]) {
            [_delegate loadDataWithCurPage:self.curPage withGenreId:_genreId withViewController:self];
        }
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(loadDataWithCurPage:withViewController:)]) {
        [_delegate loadDataWithCurPage:self.curPage withViewController:self];
    }
    if (_lstGenre.count==0 && !self.isHot) {
        if (_delegate && [_delegate respondsToSelector:@selector(loadGenreWithViewController:)]) {
            [_delegate loadGenreWithViewController:self];
        }
    }
}



-(void)setShowGenre:(NSArray *)lstGenre{
    if (lstGenre) {
        [_lstGenre removeAllObjects];
        [_lstGenre addObjectsFromArray:lstGenre];
        _rowTable = [[RowTable alloc] initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, 44) withTitle:nil withData:_lstGenre withSection:nil];
        _rowTable.delegate = self;
        [self.view addSubview:_rowTable];
        self.cvMain.contentInset = UIEdgeInsetsMake(108, 0, 50, 0);
        self.cvMain.scrollIndicatorInsets = UIEdgeInsetsMake(108, 0, 50, 0);
        [self scrollToTop];
//        _genreId = [[lstGenre firstObject] genre_id];
    }
}

-(void) scrollToTop
{
    if (self.dataSources.count > 0) {
        [self.cvMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    
//    if ([self numberOfSectionsInCollectionView:self.cvMain] > 0)
//    {
//        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
//        [self.cvMain scrollToItemAtIndexPath:top atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
//    }
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    kItemCollectionType type = [_delegate collectionSizeTypeHotViewController];
//    if (type == kItemCollectionTypeMovies) {
//        return CGSizeMake(95, 190);
//    }else{
//        return CGSizeMake(146, 185);
//    }
//    
//}

#pragma row table delegate
-(void)rowTable:(RowTable *)rowTable selected:(NSString *)key index:(NSInteger)index{
    if (index >= _lstGenre.count) {
        return;
    }
    Genre *genre = [_lstGenre objectAtIndex:index];
    //_genreId = [genre.genre_id copy];
    [self.dataSources removeAllObjects];
    [self.cvMain reloadData];
    self.curPage = kFirstPage;
    [self loadData];
    
}


@end
