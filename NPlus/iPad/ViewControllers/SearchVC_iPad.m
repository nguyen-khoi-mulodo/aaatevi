//
//  SearchVC_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 11/3/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "SearchVC_iPad.h"
#import "Constant.h"

@interface SearchVC_iPad ()
@end
static NSArray* segments = nil;

@implementation SearchVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // init search bar
    [self.view setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [headerView setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
    [menuView setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
    [self addSearchField];
    [self addSegmentView];
    [self addResultView];
    
    mListType = video_type;
    [lbNotiSearch setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [self getDiscoveryData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setScreenName:@"iPad.Search"];
    [txtSearch becomeFirstResponder];
    
}

- (void) viewDidDisappear:(BOOL)animated{
}

- (void) addSearchField{
    // init search bar
    txtSearch.layer.cornerRadius = 15.0f;
    [txtSearch setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    UIImageView *iconSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 18)];
    [iconSearch setImage:[UIImage imageNamed:@"search_icon_khungsearch"]];
    
    [txtSearch setLeftView:iconSearch];
    [txtSearch setTextColor:UIColorFromRGB(0x212121)];
    UIColor *color = [UIColor lightGrayColor];
    txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tìm kiếm" attributes:@{NSForegroundColorAttributeName:color}];
    [txtSearch setLeftViewMode:UITextFieldViewModeAlways];
    [txtSearch setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 16.0f, 14.0f)];
    [myButton setImage:[UIImage imageNamed:@"clear_button"] forState:UIControlStateNormal];
    [myButton setImage:[UIImage imageNamed:@"clear_button"] forState:UIControlStateHighlighted];
    
    [myButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];
    
    txtSearch.rightView = myButton;
    txtSearch.rightViewMode = UITextFieldViewModeWhileEditing;
    
    
    UIImage *normalImage = [UIImage imageNamed:@"bgbtn_cuatui_normal"];
    UIImage *hightlightImage = [UIImage imageNamed:@"bgbtn_cuatui_hover"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    UIImage *stretchableNormalImage = [normalImage resizableImageWithCapInsets:insets];
    UIImage *stretchablehightlightImage = [hightlightImage resizableImageWithCapInsets:insets];
    [btnHuy setBackgroundImage:stretchableNormalImage forState:UIControlStateNormal];
    [btnHuy setBackgroundImage:stretchablehightlightImage forState:UIControlStateHighlighted];
    [btnHuy.titleLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapGesture.delegate = self;
    [maskView addGestureRecognizer:tapGesture];
}

- (void) doClear:(id) sender{
    [txtSearch setText:@""];
}

- (void) addSegmentView{
    segments = [NSArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"Video", @"Kênh", @"Nghệ sĩ", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(WIDTH_SEGMENT/3,HEIGHT_INDEX_SEGMENT)], @"size", @"border-tab-menu.png", @"button-image", @"border-tab-menu-press.png", @"button-highlight-image", @"line.png", @"divider-image", [NSNumber numberWithFloat:28.0], @"cap-width", nil], nil];
    
    NSDictionary* segmentData = [segments objectAtIndex:0];
    NSArray* segmentTitles = [segmentData objectForKey:@"titles"];
    segment = [[CustomSegmentedControl alloc] initWithSegmentCount:segmentTitles.count segmentsize:[[segmentData objectForKey:@"size"] CGSizeValue] dividerImage:[UIImage imageNamed:[segmentData objectForKey:@"divider-image"]] tag:TAG_VALUE  delegate:self];
    [self addView:segment itemscount:3];
    [menuView setHidden:YES];
}

- (void) addResultView{
    if (!contentVC) {
        contentVC = [[SearchListItemsVC alloc] initWithNibName:@"SearchListItemsVC" bundle:nil];
    }
    [contentVC setDelegate:self];
    [contentVC setScreenType:search_type];
    [contentVC.view setFrame:CGRectMake(0, menuView.frame.origin.y + menuView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - headerView.frame.size.height - menuView.frame.size.height)];
    [self.view insertSubview:contentVC.view belowSubview:defaultView];
    [contentVC.view setHidden:YES];
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [txtSearch resignFirstResponder];
    [maskView setHidden:YES];
}

- (void) drawItemsWithView:(UIScrollView*) pView andRowNum:(int) rows andColNum:(int) cols andListItems:(NSMutableArray*) list{
    for (UIView* view in pView.subviews) {
        [view removeFromSuperview];
    }
    
    int totalItem = (int)list.count;
    float dX = 10;
    float dY = 10;
    float wItem = (pView.frame.size.width - (cols + 1) * dX) / cols;
    float hItem = 21.0f;
    
    int index = 0;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j ++){
            if (index < totalItem) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake( dX * (j + 1) + wItem * j, dY * (i + 1) + hItem * i, wItem, hItem)];
                [btn setBackgroundColor:[UIColor clearColor]];
                [btn setTitle:[list objectAtIndex:index] forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [btn addTarget:self action:@selector(searchWithKey:) forControlEvents:UIControlEventTouchUpInside];
                [pView addSubview:btn];
                index ++;
            }
        }
    }
}

- (void) searchWithKey:(id) sender{
    UIButton* btn = (UIButton*) sender;
    [txtSearch resignFirstResponder];
    [txtSearch setText:btn.titleLabel.text];
    [defaultView setHidden:YES];
    [maskView setHidden:YES];
//    [[SearchHistory sharedInstance] addObject:txtSearch.text];
    // load data with key
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [defaultView setHidden:NO];
    [maskView setHidden:NO];
    return YES;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(sendSearchRequest:) withObject:theTextField.text afterDelay:0.5f];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [txtSearch resignFirstResponder];
    [defaultView setHidden:YES];
    [menuView setHidden:NO];
    [contentVC.view setHidden:NO];
    [maskView setHidden:YES];
//    if (![txtSearch.text isEqualToString:@""]) {
//        [[SearchHistory sharedInstance] addObject:txtSearch.text];
//    }
    // load data with key
    [contentVC loadDataWithKeyWord:txtSearch.text andListType:mListType];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [maskView setHidden:YES];
    return YES;
}

- (void) sendSearchRequest:(NSString*) text{
    [defaultView setHidden:YES];
    [menuView setHidden:NO];
    [contentVC.view setHidden:NO];
    // load data with key
    [contentVC loadDataWithKeyWord:text andListType:mListType];
}


- (IBAction) doClose:(id) sender{
    [self closeSearchView];
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
    NSUInteger dataOffset = segmentedControl.tag - TAG_VALUE ;
    NSDictionary* data = [segments objectAtIndex:dataOffset];
    NSArray* titles = [data objectForKey:@"titles"];
    
    CapLocation location;
    if (segmentIndex == 0)
        location = CapLeft;
    else if (segmentIndex == titles.count - 1)
        location = CapRight;
    else
        location = CapMiddle;
    
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    
    CGFloat capWidth = [[data objectForKey:@"cap-width"] floatValue];
    CGSize buttonSize = [[data objectForKey:@"size"] CGSizeValue];
    
    if (location == CapLeftAndRight)
    {
        buttonImage = [[UIImage imageNamed:[data objectForKey:@"button-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
        buttonPressedImage = [[UIImage imageNamed:[data objectForKey:@"button-highlight-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    }
    else
    {
        buttonImage = [self image:[[UIImage imageNamed:[data objectForKey:@"button-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonSize.width];
        buttonPressedImage = [self image:[[UIImage imageNamed:[data objectForKey:@"button-highlight-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonSize.width];
    }
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonSize.width, buttonSize.height);
    [button setTitle:[titles objectAtIndex:segmentIndex] forState:UIControlStateNormal];
    [button setTitleColor:kSelectedColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    [button.titleLabel setTextColor:[UIColor blackColor]];
    if (segmentIndex == 0)
        button.selected = YES;
    return button;
}

- (void) touchUpInsideSegmentIndex:(NSUInteger)segmentIndex{
    int index = (int) segmentIndex;
    if (index == 0) {
        mListType = video_type;
    }else if(index == 1){
        mListType = channel_type;
    }else if(index == 2){
        mListType = artist_type;
    }
    [contentVC loadDataWithKeyWord:txtSearch.text andListType:mListType];
}

-(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
    
    if (location == CapLeft)
        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapRight)
        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
        [image drawInRect:CGRectMake(0.0 - capWidth, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapMiddle)
        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
        [image drawInRect:CGRectMake(0.0 - capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

-(void)addView:(UIView*)subView itemscount:(int) count
{
    [subView setFrame:CGRectMake((menuView.frame.size.width - WIDTH_SEGMENT)/2, 12, WIDTH_SEGMENT, HEIGHT_INDEX_SEGMENT)];
    [menuView addSubview:subView];
}

-(void) showTopKeys{
    float dY = 18;
    float H = 24;
    float W = topKeysSubView.frame.size.width;
    for (int i = 0; i < 5; i++){
        UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, (H + dY)*i, 24, H)];
        [imgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"top-keyword-%d-v2", i + 1]]];
        [topKeysSubView addSubview:imgV];
        
        UILabel* lbKey = [[UILabel alloc] initWithFrame:CGRectMake(34, (H + dY) * i, W - 34, H)];
        [lbKey setBackgroundColor:[UIColor clearColor]];
        [topKeysSubView addSubview:lbKey];
        
        TopKeyword* topKeyWord = [arrTopKeys objectAtIndex:i];
        [lbKey setText:topKeyWord.title];
        [lbKey setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        [lbKey setTextColor:UIColorFromRGB(0xa4a4a4)];
        [lbKey setTextAlignment:NSTextAlignmentLeft];
    }
}

#pragma Load Data
- (void) getDiscoveryData {
    if (APPDELEGATE.internetConnnected) {
        //        [loadingTopKeys startAnimating];
        [[APIController sharedInstance] getTopKeyWordsCompleted:^(int code, NSArray *results) {
            if (code == kAPI_SUCCESS) {
                arrTopKeys = results;
                [self showTopKeys];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}

@end