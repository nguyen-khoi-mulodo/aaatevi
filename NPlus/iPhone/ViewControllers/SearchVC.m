//
//  SearchVC.m
//  NPlus
//
//  Created by Anh Le Duc on 8/1/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "SearchVC.h"
#import "SearchHistory.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "SearchAllVC.h"
#import "SearchTypeVC.h"
#import "SearchTypeEntertaimentVC.h"
#define kSECTION_SEARCH_KEY 0
#define kSECTION_KEY_HOT    1
@interface SearchVC ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    UIView *_viewSearchKey;
    UIView *_viewKeyHot;
    NSMutableArray *_lstSearchKey;
    NSMutableArray *_lstKeyHot;
    float heightSectionSearch;
    float heightSectionHot;
    
}
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end

@implementation SearchVC
@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;
-(NSString *)screenNameGA{
    return @"Search";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) didRotate:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
    {
        if (APPDELEGATE.nowPlayerVC.isShowNowPlaying){
            [self.txtSearch resignFirstResponder];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BACKGROUND_COLOR;
//    self.navigationController.navigationBarHidden = YES;
    _viewHeader.translatesAutoresizingMaskIntoConstraints = YES;
    _viewHeader.backgroundColor = [UIColor clearColor];
    CGRect f = _viewHeader.frame;
    f.size.width = SCREEN_SIZE.width;
    _viewHeader.frame = f;
    self.navigationItem.titleView = _viewHeader;
    self.navigationItem.hidesBackButton = YES;
    
    self.viewResults.frame = CGRectMake(0, ORIGIN_Y + 44, SCREEN_WIDTH, SCREEN_SIZE.height - ORIGIN_Y - 44);
    [self.view insertSubview:self.viewResults belowSubview:self.tbMain];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.viewContainer addSubview:self.pageViewController.view];
    [self.pageControl setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [self.pageControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    self.pageControl.backgroundColor = [UIColor whiteColor];
    self.pageControl.textColor = RGB(68, 68, 68);
    self.pageControl.selectionIndicatorColor = COLOR_MAIN_BLUE;
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.selectedTextColor = COLOR_MAIN_BLUE;
    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.pageControl.verticalDividerColor = RGB(232, 232, 232);
    self.pageControl.showVerticalDivider = YES;
    
    [self.viewContainer setFrame:CGRectMake(0, self.pageControl.frame.origin.y + 35, SCREEN_WIDTH, self.viewResults.bounds.size.height - 35)];
    self.viewContainer.backgroundColor = RGB(235, 235, 235);
    
    
    
//    CGRect frame = _tbMain.frame;
//    frame.origin.y = SCREEN_SIZE.height;
//    frame.size.height = SCREEN_SIZE.height - ORIGIN_Y - 44;
//    _tbMain.frame = frame;
    _lstSearchKey = [[NSMutableArray alloc] init];
    _lstKeyHot = [[NSMutableArray alloc] init];
    heightSectionSearch = 0;
    heightSectionHot = 0;
    _txtSearch.layer.cornerRadius = 15.0f;
    _txtSearch.backgroundColor = RGB(58, 58, 58);
    UIImageView *iconSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 18)];
    [iconSearch setImage:[UIImage imageNamed:@"search_icon_khungsearch"]];
    _txtSearch.placeholder = @"Tìm kiếm";
    _txtSearch.delegate = self;
    [_txtSearch setLeftView:iconSearch];
    [_txtSearch setLeftViewMode:UITextFieldViewModeAlways];
    
    _btnCancel.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    _viewSearchKey = [[UIView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 300)];
    _viewSearchKey.layer.cornerRadius = 1.0f;
    _viewSearchKey.layer.borderWidth = 0.5f;
    _viewSearchKey.layer.borderColor = RGB(206, 206, 206).CGColor;
    _viewSearchKey.backgroundColor = [UIColor whiteColor];
    _viewKeyHot = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 300)];
    _viewKeyHot.layer.cornerRadius = 1.0f;
    _viewKeyHot.layer.borderWidth = 0.5f;
    _viewKeyHot.layer.borderColor = RGB(206, 206, 206).CGColor;
    _viewKeyHot.backgroundColor = [UIColor whiteColor];
    
    _tbMain.delegate = self;
    _tbMain.dataSource = self;
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbMain.backgroundColor = BACKGROUND_COLOR;
    _tbMain.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tbMain.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [self.pageControl setIndexChangeBlock:^(NSInteger index) {
//        NSLog(@"change: %lu", index);
//        if (index < self.pages.count) {
//            
//        }
    }];
    
    [self loadData];
    
}

-(void)loadData{
    _lstSearchKey = [[SearchHistory sharedInstance] searchHistory];
    [self addObjects:_lstSearchKey toView: _viewSearchKey inSection:kSECTION_SEARCH_KEY];
    
    [[APIController sharedInstance] getHotKeywordCompleted:^(NSArray *results) {
        [_lstKeyHot removeAllObjects];
        [_lstKeyHot addObjectsFromArray:results];
        [self addObjects:_lstKeyHot toView: _viewKeyHot inSection:kSECTION_KEY_HOT];
        [_tbMain reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

- (void)updateSegmentControl{
    if ([self.pages count]>0) {
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
    }
    [self updateTitleLabels];
    [self.pageControl setSelectedSegmentIndex:0];
}

#pragma mark - Setup

- (void)updateTitleLabels
{
    [self.pageControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels
{
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            [titles addObject:vc.title ? vc.title : @"No Title"];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        if (hidden) {
            self.pageControl.alpha = 0.0f;
        } else {
            self.pageControl.alpha = 1.0f;
        }
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController
{
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    UIPageViewControllerNavigationDirection direction = [self.pageControl selectedSegmentIndex] > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[[self selectedController]]
                                      direction:direction
                                       animated:NO
                                     completion:NULL];
}

- (void) addObjects:(NSMutableArray *) data toView: (UIView *) sview inSection: (NSInteger ) section
{
    for (UIView *view in [sview subviews])
    {
        [view removeFromSuperview];
    }
    int k = 0;
    float dY = 30.0f;
    
    for (int i = 0; i < data.count; i++)
    {
        id obj = [data objectAtIndex:i];
        float delta = 0.214f;
        float button_width = (SCREEN_WIDTH - 40)/2;
        float button_height = button_width * delta;
        float dX = 10.0f;
        
        
        NSString *item = (NSString *) obj;
        
        UILabel *lbSection = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 180, 15)];
        lbSection.text = (section == 0) ? @"Lịch sử tìm kiếm" : @"Tìm kiếm nhiều nhất";
        lbSection.textColor = RGB(148, 148, 148);
        lbSection.backgroundColor = [UIColor clearColor];
        lbSection.font = [UIFont systemFontOfSize:14.0f];
        [sview addSubview:lbSection];
        
        if (section == 0) {
            UIButton *clearHis = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 7, 100, 15)];
            [clearHis setTitle:@"Xoá lịch sử" forState:UIControlStateNormal];
            [clearHis setTitleColor:RGB(255, 153, 44) forState:UIControlStateNormal];
            clearHis.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [clearHis addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
            [sview addSubview:clearHis];
        }
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH - 30, 1)];
        sep.backgroundColor = RGB(231, 231, 231);
        [sview addSubview:sep];
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i + 1;
        button.titleLabel.tag = section + 1;
        [button addTarget:self action:@selector(cateTap:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor clearColor]];
        
        UILabel *name = [[UILabel alloc] init];
        name.frame = CGRectMake(0, 0, button_width, button_height);
        name.numberOfLines = 1;
        name.textAlignment = NSTextAlignmentLeft;
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = RGB(62, 62, 62);
        name.backgroundColor = [UIColor clearColor];
        name.text = item;
        [button addSubview:name];
        
        if (i % 2 == 0 && i != 0)
        {
            dY = dY + button_height + 5;
            k = 0;
        }
        
        CGRect frame = CGRectMake(dX + (k) * (button_width + dX), dY, button_width , button_height);
        [button setFrame:frame];
        k++;
        if (section == 0) {
            heightSectionSearch = dY + button_height;
        }else{
            heightSectionHot = dY + button_height;
        }
        
        [sview addSubview:button];
        
        
    }
    
    _viewSearchKey.frame = CGRectMake(5, 5, SCREEN_WIDTH - 10, heightSectionSearch);
    _viewKeyHot.frame = CGRectMake(5, 5, SCREEN_WIDTH - 10, heightSectionHot);
}

- (void) cateTap: (UIButton *) sender
{
    NSInteger type = sender.titleLabel.tag - 1;
    NSInteger index = sender.tag - 1;
    if (type == kSECTION_SEARCH_KEY) {
        NSString *keyword = [_lstSearchKey objectAtIndex:index];
        _txtSearch.text = keyword;
        [_txtSearch resignFirstResponder];
        [self search:keyword];
    }else if(type == kSECTION_KEY_HOT){
        NSString *keyword = [_lstKeyHot objectAtIndex:index];
        _txtSearch.text = keyword;
        [_txtSearch resignFirstResponder];
        [[SearchHistory sharedInstance] addObject:keyword];
        [self addObjects:_lstSearchKey toView: _viewSearchKey inSection:kSECTION_SEARCH_KEY];
        [_tbMain reloadData];
        [self search:keyword];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.akTabBarController hideTabBarAnimated:NO];
    if (_txtSearch.text.length == 0) {
        [self animStart];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)animStart{
    _txtSearch.translatesAutoresizingMaskIntoConstraints = YES;
//    _btnCancel.translatesAutoresizingMaskIntoConstraints = YES;
    _txtSearch.placeholder = @"";
    _txtSearch.leftView.hidden = YES;
    CGRect frame = _txtSearch.frame;
    frame.origin.x = 12;
    frame.size.width = SCREEN_WIDTH - 100;
    _txtSearch.frame = frame;
    _btnCancel.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _btnCancel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        _txtSearch.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            _txtSearch.leftView.hidden = NO;
            _txtSearch.placeholder = @"Tìm kiếm phim, hài kịch, âm nhạc";
            _txtSearch.textColor = [UIColor whiteColor];
            [_txtSearch becomeFirstResponder];
        }
    }];
}

-(void)animEnd{
    [self.view endEditing:YES];
    CGRect frame = _txtSearch.frame;
    frame.origin.x = 62;
    frame.size.width = SCREEN_WIDTH - 150;
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _btnCancel.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _txtSearch.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.akTabBarController showTabBarAnimated:NO];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
}

#pragma mark UITableView delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return heightSectionSearch + 10;
    }else{
        return heightSectionHot + 10;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)btableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSECTION_SEARCH_KEY)
    {
        static NSString *searchCellID		=   @"searchCellID";
        UITableViewCell *cell = [btableView dequeueReusableCellWithIdentifier:searchCellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:_viewSearchKey];
        }
        return cell;
    }
    else if (indexPath.section == kSECTION_KEY_HOT)
    {
        static NSString *hotCellID		=   @"hotCellID";
        UITableViewCell *cell = [btableView dequeueReusableCellWithIdentifier:hotCellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:_viewKeyHot];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancel_Tapped:(id)sender {
    [self animEnd];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64.0, 0.0, (keyboardSize.height) + ORIGIN_Y + 44, 0.0);
//    CGRect frame = _tbMain.frame;
//    frame.size.height -= keyboardSize.height;
//    _tbMain.frame = frame;
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        _tbMain.contentInset = contentInsets; // insert content inset value here
        _tbMain.scrollIndicatorInsets = contentInsets;// insert content inset value here
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    CGRect frame = _tbMain.frame;
//    frame.size.height = SCREEN_SIZE.height - ORIGIN_Y - 44;
//    _tbMain.frame = frame;
    _tbMain.contentInset = UIEdgeInsetsMake(ORIGIN_Y + 44, 0, 0, 0);
    _tbMain.scrollIndicatorInsets = UIEdgeInsetsZero;
//    [_tbMain layoutIfNeeded];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _tbMain.hidden = NO;
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [_txtSearch resignFirstResponder];
    
    NSString *keyword =  textField.text;
    [[SearchHistory sharedInstance] addObject:keyword];
    [self addObjects:_lstSearchKey toView: _viewSearchKey inSection:kSECTION_SEARCH_KEY];
    [_tbMain reloadData];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(seachView:willSearchWithKeyWord:)])
//    {
//        [self.delegate seachView:self willSearchWithKeyWord:keyword];
//    }
    
    [self search:keyword];
    
    return YES;
}

- (void)search:(NSString*)keyword{
    BOOL show = [[Util sharedInstance] hardcodeShowInfomation:keyword];
    if (show) {
        return;
    }
    
    if (self.pages) {
        [self.pages removeAllObjects];
        self.pages = nil;
    }
    _tbMain.hidden = YES;
    NSMutableArray *pages = [NSMutableArray new];
    SearchAllVC *searchVC = [[SearchAllVC alloc] initWithNibName:@"SearchAllVC" bundle:nil];
    searchVC.keyword = keyword;
    [pages addObject:searchVC];
    
    SearchTypeEntertaimentVC *searchEntertaiment = [[SearchTypeEntertaimentVC alloc] initWithNibName:@"SearchTypeEntertaimentVC" bundle:nil];
    searchEntertaiment.keyword = keyword;
    searchEntertaiment.title = @"Giải trí";
    [pages addObject:searchEntertaiment];
    
    SearchTypeVC *searchType = [[SearchTypeVC alloc] initWithNibName:@"SearchTypeVC" bundle:nil];
    searchType.keyword = keyword;
    searchType.type = @"cartoon";
    searchType.genre_id = @"5192";
    searchType.title = @"Hoạt hình";
    [pages addObject:searchType];
    
    searchType = [[SearchTypeVC alloc] initWithNibName:@"SearchTypeVC" bundle:nil];
    searchType.keyword = keyword;
    searchType.type = @"tvshow";
    searchType.genre_id = @"5162";
    searchType.title = @"TV Show";
    [pages addObject:searchType];
    
    searchType = [[SearchTypeVC alloc] initWithNibName:@"SearchTypeVC" bundle:nil];
    searchType.keyword = keyword;
    searchType.type = @"movie";
    searchType.genre_id = @"5177";
    searchType.title = @"Phim";
    [pages addObject:searchType];
    
    searchType = [[SearchTypeVC alloc] initWithNibName:@"SearchTypeVC" bundle:nil];
    searchType.keyword = keyword;
    searchType.type = @"music";
    searchType.genre_id = @"5194";
    searchType.title = @"Ca nhạc";
    [pages addObject:searchType];
    
    [self setPages:pages];
    [self updateSegmentControl];
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)clearHistory{
    [[SearchHistory sharedInstance] clearHistory];
    [_lstSearchKey removeAllObjects];
    heightSectionSearch = 0;
    [self addObjects:_lstSearchKey toView: _viewSearchKey inSection:kSECTION_SEARCH_KEY];
    [_tbMain reloadData];
}

@end
