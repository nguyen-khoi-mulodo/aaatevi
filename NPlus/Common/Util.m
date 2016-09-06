//
//  Util.m
//  NCT iPad
//
//  Created by Vo Chuong Thien on 1/19/15.
//  Copyright (c) 2015 thienvc. All rights reserved.
//

#import "Util.h"
#import "Constant.h"
#import "User.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "RC4Crypt.h"

@implementation Util

static Util * sharedInstance;
static TokenInfo* tokenInfo = nil;

+(Util*) sharedInstance {
    if (sharedInstance == nil)
        sharedInstance = [[self alloc] init];
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)saveToken:(TokenInfo*) info{
    if (info) {
        tokenInfo.token = info.token;
        tokenInfo.timeExpire = info.timeExpire;
    }else{
        NSLog(@"Cannot save token info is nil");
    }
}

- (TokenInfo*) getToken{
    return tokenInfo;
}

- (NSString*) decryptedSubtitle:(SubTitle*) sub{
    NSString *hexContentSub = [NSString stringWithContentsOfURL:[NSURL URLWithString:sub.subtitle_timed] encoding:NSUTF8StringEncoding error:nil];
    NSString *hexStringKey = [RC4Crypt stringToHex:sub.subtitle_decryptionKey];
    NSString *decryptedSub = [RC4Crypt doCipher:hexContentSub withKey:hexStringKey operation:kCCDecrypt];
    return decryptedSub;
}

- (BOOL) hardcodeShowInfomation:(NSString*) keyword{
    if ([[keyword lowercaseString] isEqualToString:@"vochuongthien"] || [[keyword lowercaseString] isEqualToString:@"yehi"]) {
        BOOL isRealServer = NO;
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([API_URL isEqualToString:kRealServer]) {
            isRealServer = YES;
        }
        
        BOOL isAppstore = YES;
        if (kBuildType == developement) {
            isAppstore = NO;
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"INFORMATION" message:[NSString stringWithFormat:@"VERSION: %@   SERVER: %@   BUILD: %@", version, (isRealServer) ? @"Live" : @"Dev", (isAppstore) ? @"Appstore" : @"Dev"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return YES;
    }
    return NO;
}

+ (CGFloat) heightForCellWithContent:(NSString *)text withFont:(UIFont*) font{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(349, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    rect.size.width = 349;
    if (rect.size.height < 28) {
        rect.size.height = 28;
    }
    return rect.size.height + 21;
}

+ (CGFloat)heightForContent:(NSString *)text withFont:(UIFont*) font andWidth:(float) width{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return rect.size.height;
}

+ (CGFloat) heightForContent:(NSString *)text withFont:(UIFont*) font andWidth:(float) width andHeight:(float) height{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return rect.size.height;
}

+ (NSString *) getDiskSpaceInfo{
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
    }else
        return nil;
    
    NSString *infostr = [NSString stringWithFormat:@"Tổng dung lượng %.2fGB/Khả dụng %.2fGB", ((totalSpace/1024.0f)/1024.0f)/1024.0f, ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f];
    return infostr;
    
}

+ (NSString *) getRatioWithBytesWritten:(double) bytesWritten BytesExpectedToWrite:(double) bytesExpectedToWrite{
    NSString* strBytesWritten = @"";
    if (((bytesWritten/1024.0f)/1024.0f) > 1024.0f) {
        strBytesWritten = [NSString stringWithFormat:@"%.1fGB", ((bytesWritten/1024.0f)/1024.0f)/1024.0f];
    }else{
        strBytesWritten = [NSString stringWithFormat:@"%.1fMB", ((bytesWritten/1024.0f)/1024.0f)];
    }
    
    NSString* strBytesExpectedToWrite = @"";
    if (((bytesExpectedToWrite/1024.0f)/1024.0f) > 1024.0f) {
        strBytesExpectedToWrite = [NSString stringWithFormat:@"%.1fGB", ((bytesExpectedToWrite/1024.0f)/1024.0f)/1024.0f];
    }else{
        strBytesExpectedToWrite = [NSString stringWithFormat:@"%.1fMB", ((bytesExpectedToWrite/1024.0f)/1024.0f)];
    }
    NSString *infostr = [NSString stringWithFormat:@"%@/%@", strBytesWritten, strBytesExpectedToWrite];
    return infostr;
}

+ (NSString *) getByteExecdtedWritten:(double) bytesExpectedToWrite{
    NSString* strBytesExpectedToWrite = @"";
    if (((bytesExpectedToWrite/1024.0f)/1024.0f) > 1024.0f) {
        strBytesExpectedToWrite = [NSString stringWithFormat:@"%.1fGB", ((bytesExpectedToWrite/1024.0f)/1024.0f)/1024.0f];
    }else{
        strBytesExpectedToWrite = [NSString stringWithFormat:@"%.1fMB", ((bytesExpectedToWrite/1024.0f)/1024.0f)];
    }
    return strBytesExpectedToWrite;
}
@end
