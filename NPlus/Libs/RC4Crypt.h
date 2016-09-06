//
//  RC4Crypt.h
//  NhacCuaTui
//
//  Created by TEVI Team on 3/24/15.
//  Copyright (c) 2015 ncnlam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface RC4Crypt : NSObject
+ (NSString *) stringToHex:(NSString *)str;
+ (NSString *)dataToStringHex:(NSData*)data;
+ (NSString *)doCipher:(NSString *)string withKey:(NSString *)key operation:(CCOperation)encryptOrDecrypt;
@end
