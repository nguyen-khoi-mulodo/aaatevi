//
//  RC4Crypt.m
//  NhacCuaTui
//
//  Created by TEVI Team on 3/24/15.
//  Copyright (c) 2015 ncnlam. All rights reserved.
//

#import "RC4Crypt.h"

@implementation RC4Crypt
static NSData *hexStringToBytes(NSString *string) {
    NSMutableData *data = [NSMutableData data];
    for (int i = 0; i + 2 <= string.length; i += 2) {
        uint8_t value = (uint8_t)strtol([[string substringWithRange:NSMakeRange(i, 2)] UTF8String], 0, 16);
        [data appendBytes:&value length:1];
    }
    return data;
}

+ (NSString *)doCipher:(NSString *)string withKey:(NSString *)key operation:(CCOperation)encryptOrDecrypt{
    NSData *inBytes = hexStringToBytes(string);
    NSData *keyBytes = hexStringToBytes(key);
    
    NSMutableData *outBytes = [NSMutableData dataWithLength:[inBytes length]];
    size_t dataOutMoved = 0;
    
    CCCryptorStatus ccStatus = CCCrypt(encryptOrDecrypt,
                                       kCCAlgorithmRC4,
                                       0,
                                       [keyBytes bytes],
                                       [keyBytes length],
                                       NULL, // iv
                                       [inBytes bytes],
                                       [inBytes length],
                                       [outBytes mutableBytes],
                                       [outBytes length],
                                       &dataOutMoved);
    
    if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    if (ccStatus == kCCParamError) return @"PARAM ERROR";
    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:outBytes encoding:NSUTF8StringEncoding];
    }
    else
    {
        result = [self dataToStringHex:outBytes];
    }
    
    return result;
}

+ (NSString *) stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString;
}

+ (NSString *)dataToStringHex:(NSData*)data
{
    const unsigned char *dbytes = [data bytes];
    NSMutableString *hexStr =
    [NSMutableString stringWithCapacity:[data length]*2];
    int i;
    for (i = 0; i < [data length]; i++) {
        [hexStr appendFormat:@"%02x", dbytes[i]];
    }
    return [NSString stringWithString: hexStr];
}

//+ (NSString*) doCipher:(NSString*)plainText operation:(CCOperation)encryptOrDecrypt withKey:(NSString*)k{
//    
//    
//    const void *vplainText;
//    size_t plainTextBufferSize;
//    
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        NSData *EncryptData = hexStringToBytes(plainText);
//        plainTextBufferSize = [EncryptData length];
//        vplainText = [EncryptData bytes];
//    }
//    else
//    {
//        plainTextBufferSize = [plainText length];
//        vplainText = (const void *) [plainText UTF8String];
//    }
//    
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    
//    NSString *key = [self stringToHex:k];
//    NSData *keyBytes = hexStringToBytes(key);
//    
//    ccStatus = CCCrypt(encryptOrDecrypt,
//                       kCCAlgorithmRC4,
//                       0,
//                       [keyBytes bytes],
//                       [keyBytes length],
//                       NULL, //"init Vec", //iv,
//                       vplainText, //"Your Name", //plainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
//    /*else*/ if (ccStatus == kCCParamError) return @"PARAM ERROR";
//    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
//    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
//    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
//    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
//    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
//    
//    NSString *result;
//    
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        result = [[ NSString alloc ] initWithData: [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSASCIIStringEncoding];
//    }
//    else
//    {
//        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//        result = [myData base64Encoding];
//    }
//    
//    return result;
//    
//}

@end
