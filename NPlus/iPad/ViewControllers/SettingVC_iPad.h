
#import "BaseVC.h"


@protocol SettingDelegate <NSObject>
- (void) showLoginWithTask:(NSString*) task andObject:(id) item;
- (void) showRegisterView;
- (void) showForgetPassword;
- (void) showSettingView:(BOOL) isShow;
@end

@interface SettingVC_iPad : BaseVC<FacebookLoginTaskDelegate>
@property (nonatomic, strong) id <SettingDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnStore_Tapped:(id)sender;
- (IBAction)btnBack_Tapped:(id)sender;
- (IBAction)btnLogin_Tapped:(id)sender;

@end
