//
//  TSMiniWebBrowser.m
//  TSMiniWebBrowserDemo
//
//  Created by Toni Sala Echaurren on 18/01/12.
//  Copyright 2012 Toni Sala. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TSMiniWebBrowser.h"
@implementation TSMiniWebBrowser{
    int seconds;
}

@synthesize delegate;
@synthesize mode;
@synthesize showURLStringOnActionSheetTitle;
@synthesize showPageTitleOnTitleBar;
@synthesize showReloadButton;
@synthesize showActionButton;
@synthesize barStyle;
@synthesize modalDismissButtonTitle;
@synthesize showFullScreen;
#define kToolBarHeight  44
#define kTabBarHeight   49

#define kSafariButtonIndex 0
#define kChromeButtonIndex 1

#pragma mark - Private Methods


-(void) toggleBackForwardButtons {
    buttonGoBack.enabled = webView.canGoBack;
    buttonGoForward.enabled = webView.canGoForward;
}

-(void)showActivityIndicators {
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideActivityIndicators {
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void) dismissController {
    if ( webView.loading ) {
        [webView stopLoading];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Notify the delegate
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(tsMiniWebBrowserDidDismiss)]) {
        [delegate tsMiniWebBrowserDidDismiss];
    }
}

//Added in the dealloc method to remove the webview delegate, because if you use this in a navigation controller
//TSMiniWebBrowser can get deallocated while the page is still loading and the web view will call its delegate-- resulting in a crash
-(void)dealloc
{
    [webView setDelegate:nil];
}

#pragma mark - Init


-(void) initToolBar {
    if (mode == TSMiniWebBrowserModeNavigation) {
        self.navigationController.navigationBar.barStyle = barStyle;
    }
    
    CGSize viewSize = self.view.frame.size;
    if (mode == TSMiniWebBrowserModeTabBar) {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, viewSize.width, kToolBarHeight)];
    } else {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height-kToolBarHeight, viewSize.width, kToolBarHeight)];
    }
    
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    toolBar.barStyle = UIBarStyleBlackOpaque; //barStyle;
    [self.view addSubview:toolBar];
    
    buttonGoBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchUp:)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 30;
    
    buttonGoForward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonTouchUp:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *buttonReload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadButtonTouchUp:)];
    
    UIBarButtonItem *fixedSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace2.width = 20;
    
    UIBarButtonItem *buttonAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonActionTouchUp:)];
    
    // Activity indicator is a bit special
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(11, 7, 20, 20);
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 33)];
    [containerView addSubview:activityIndicator];
    UIBarButtonItem *buttonContainer = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    // Add butons to an array
    NSMutableArray *toolBarButtons = [[NSMutableArray alloc] init];
    [toolBarButtons addObject:buttonGoBack];
    [toolBarButtons addObject:fixedSpace];
    [toolBarButtons addObject:buttonGoForward];
    [toolBarButtons addObject:flexibleSpace];
    [toolBarButtons addObject:buttonContainer];
        
    if (showReloadButton) { 
        [toolBarButtons addObject:buttonReload];
    }
    if (showActionButton) {
        [toolBarButtons addObject:fixedSpace2];
        [toolBarButtons addObject:buttonAction];
    }

    modalDismissButtonTitle = @"Done";
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithTitle:modalDismissButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(dismissController)];
    [toolBarButtons addObject:buttonDone];

    // Set buttons to tool bar
    [toolBar setItems:toolBarButtons animated:YES];
}

-(void) initWebView {
    float toolBarHeight = kToolBarHeight;
    if (self.showFullScreen) {
        toolBarHeight = 0;
    }else if (mode == TSMiniWebBrowserModeModal){
        toolBarHeight = ORIGIN_Y;
    }
    CGSize viewSize = self.view.frame.size;
    if (mode == TSMiniWebBrowserModeModal) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, toolBarHeight, viewSize.width, viewSize.height-toolBarHeight - (self.showFullScreen ? 0 : 44))];
    } else if(mode == TSMiniWebBrowserModeNavigation) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-toolBarHeight)];
    } else if(mode == TSMiniWebBrowserModeTabBar) {
        self.view.backgroundColor = [UIColor redColor];
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, toolBarHeight-1, viewSize.width, viewSize.height-toolBarHeight+1)];
    }
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
    
    webView.scalesPageToFit = YES;
    
    webView.delegate = self;
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)didShow{
    // Load the URL in the webView
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlToLoad];
    [webView loadRequest:requestObj];
    
    if (self.showFullScreen) {
        seconds = 3;
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    }
}

- (void)countDown:(NSTimer*)timer{
    NSString *strSeconds = [NSString stringWithFormat:@"%d", seconds];
    _btnClose.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _btnClose.contentEdgeInsets = UIEdgeInsetsMake(1, 1, 0, 0);
    [_btnClose setTitle:strSeconds forState:UIControlStateNormal];
    
    if(seconds == 0){
        [_btnClose setTitle:@"X" forState:UIControlStateNormal];
        _btnClose.enabled = YES;
        [timer invalidate];
        timer = nil;
    }
    seconds--;
}
#pragma mark -

- (id)initWithUrl:(NSURL*)url {
    self = [self init];
    if(self)
    {
        urlToLoad = url;
        
        // Defaults
        mode = TSMiniWebBrowserModeNavigation;
        self.showFullScreen = NO;
        showURLStringOnActionSheetTitle = YES;
        showPageTitleOnTitleBar = YES;
        showReloadButton = YES;
        showActionButton = YES;
        modalDismissButtonTitle = NSLocalizedString(@"Done", nil);
        forcedTitleBarText = nil;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Main view frame.
    if (mode == TSMiniWebBrowserModeTabBar) {
        CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - kTabBarHeight;
        if (![UIApplication sharedApplication].statusBarHidden) {
            viewHeight -= [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    
    // Store the current navigationBar bar style to be able to restore it later.
    if (mode == TSMiniWebBrowserModeNavigation) {
        originalBarStyle = self.navigationController.navigationBar.barStyle;
    }
    
    // Init tool bar
    if (!self.showFullScreen) {
        [self initToolBar];
    }
    
    
    // Init web view
    [self initWebView];
        
    // UI state
    
    if(self.showFullScreen){
        _btnClose.hidden = NO;
        [self.view bringSubviewToFront:_btnClose];
    }
    
    buttonGoBack.enabled = NO;
    buttonGoForward.enabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // Restore navigationBar bar style.
    if (mode == TSMiniWebBrowserModeNavigation) {
        self.navigationController.navigationBar.barStyle = originalBarStyle;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (IS_IPAD) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    return NO;
}

/* Fix for landscape + zooming webview bug.
 * If you experience perfomance problems on old devices ratation, comment out this method.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGFloat ratioAspect = webView.bounds.size.width/webView.bounds.size.height;
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
            // Going to Portrait mode
            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview 
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale/ratioAspect) animated:YES];
                }
            }
            break;
        default:
            // Going to Landscape mode
            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview 
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale *ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale *ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale*ratioAspect) animated:YES];
                }
            }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Sheet

- (void)showActionSheet
{
    NSURL *theURL = [webView.request URL];
    if (theURL == nil || [theURL isEqual:[NSURL URLWithString:@""]])
    {
        theURL = urlToLoad;
    }
    [[UIApplication sharedApplication] openURL:theURL];
    [self dismissViewControllerAnimated:YES completion: nil];
}

#pragma mark - Actions

- (void)backButtonTouchUp:(id)sender {
    [webView goBack];
    
    [self toggleBackForwardButtons];
}

- (void)forwardButtonTouchUp:(id)sender {
    [webView goForward];
    
    [self toggleBackForwardButtons];
}

- (void)reloadButtonTouchUp:(id)sender {
    [webView reload];
    
    [self toggleBackForwardButtons];
}

- (void)buttonActionTouchUp:(id)sender {
    [self showActionSheet];
}

#pragma mark - Public Methods

- (void)setFixedTitleBarText:(NSString*)newTitleBarText {
    forcedTitleBarText = newTitleBarText;
    showPageTitleOnTitleBar = NO;
}

- (void)loadURL:(NSURL*)url {
    [webView loadRequest: [NSURLRequest requestWithURL: url]];
    [self dismissViewControllerAnimated:YES completion:NO];
}

#pragma mark - UIWebViewDelegate


- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([[request.URL absoluteString] hasPrefix:@"sms:"])
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    
    if ([[request.URL absoluteString] hasPrefix:@"http://www.youtube.com/v/"] ||
        [[request.URL absoluteString] hasPrefix:@"http://itunes.apple.com/"] ||
        [[request.URL absoluteString] hasPrefix:@"https://itunes.apple.com/"] ||
        [[request.URL absoluteString] hasPrefix:@"https://phobos.apple.com/"] ||
        [[request.URL absoluteString] hasPrefix:@"http://phobos.apple.com/"]||
        [[request.URL absoluteString] hasPrefix:@"itms-services://"])
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    
    
    return YES;
}



- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self toggleBackForwardButtons];
    
    [self showActivityIndicators];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{    
    [self hideActivityIndicators];
    
    [self toggleBackForwardButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideActivityIndicators];
    // To avoid getting an error alert when you click on a link
    // before a request has finished loading.
    if ([error code] == NSURLErrorCancelled) {
        return;
    }

    // Show error alert
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not load page", nil)
//                                                    message:error.localizedDescription
//                                                   delegate:self
//                                          cancelButtonTitle:nil
//                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
//	[alert show];
}


- (IBAction)btnClose_Tapped:(id)sender {
    if (seconds > 0) {
        return;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
