//
//  MyUIDevice.m
//  keychainudidtest
//
//  Created by zhlifly on 13-9-25.
//  Copyright (c) 2013年 URoadPlus. All rights reserved.
//

#import "MyUIDevice.h"

#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import <Security/Security.h>

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <net/if.h>
#import <net/if_dl.h>

static NSString * AKeyChainUUIDSessionCache = nil;
static NSString * const aKeyChainUUIDIdentifier = @"com.uroad.GaoSuTongFullVersionFromUroadPlus";
static NSString * const aKeyChainUUIDKey = @"GaoSuTongFullVersionFromUroadPlus";

@implementation MyUIDevice

// UUID Value
+ (NSString*)uuidValue
{
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    CGFloat version = [sysVersion floatValue];
    
    // 1. Check Cache
    if (AKeyChainUUIDSessionCache != nil) {     // if exist return cache
        return AKeyChainUUIDSessionCache;
    }
    
    
    
    // 2. try get from keychain
    AKeyChainUUIDSessionCache = [MyUIDevice getKeyChainUUID];
    if (AKeyChainUUIDSessionCache != nil) return AKeyChainUUIDSessionCache;
    
    // 3. no Cache, get from differe place base on ios version
    if (version >= 7.0) {
        
        // 4. generate UUID by identifierForVendor and do sha1 hash then save in keychain
        NSMutableDictionary *KeyChainUUIDPairs = [NSMutableDictionary dictionary];
        [KeyChainUUIDPairs setObject:[MyUIDevice sha1Hash:[[[UIDevice currentDevice] identifierForVendor] UUIDString]] forKey:aKeyChainUUIDKey];
        [MyUIDevice saveObject:KeyChainUUIDPairs];
        
    } else {
        
        // 4. generate UUID by identifierForVendor and do sha1 hash then save in keychain
        NSMutableDictionary *KeyChainUUIDPairs = [NSMutableDictionary dictionary];
        [KeyChainUUIDPairs setObject:[MyUIDevice sha1Hash:[MyUIDevice fetchMacAddress]] forKey:aKeyChainUUIDKey];
        [MyUIDevice saveObject:KeyChainUUIDPairs];
        
    }
    
    // 5. again,get from KeyChain
    AKeyChainUUIDSessionCache = [MyUIDevice getKeyChainUUID];
    return AKeyChainUUIDSessionCache;
}

// Mac Address
+ (NSString*)fetchMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
#ifdef DEBUG
        NSLog(@"Error: %@", errorFlag);
#endif
        errorFlag = @"failed get mac address";
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
#ifdef DEBUG
    NSLog(@"Mac Address: %@", macAddressString);
#endif
    
    return macAddressString;
}

+(NSString *)sha1Hash:(NSString *)toHashString
{
    const char *cStr = [toHashString UTF8String];
    unsigned char result[20];
    CC_SHA1(cStr, strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19]
                   ];
    return s;
}

// Delete KeyChain UUID
+ (void)Renew
{
    [MyUIDevice deleteKeychain:aKeyChainUUIDIdentifier];
}

+ (NSString *)getKeyChainUUID
{
    NSMutableDictionary *KeyChainUUIDPairs = (NSMutableDictionary *)[MyUIDevice loadKeychainData:aKeyChainUUIDIdentifier];
    if (KeyChainUUIDPairs == nil) return nil;                 // is nil
//    NSString*returnKey=[KeyChainUUIDPairs objectForKey:aKeyChainUUIDKey];
//    return returnKey;    
    return [KeyChainUUIDPairs objectForKey:aKeyChainUUIDKey];
}



// Save Objec to KeyChain
+ (void)saveObject:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self makeKeychain:aKeyChainUUIDIdentifier];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

// Make Keychain
+ (NSMutableDictionary *)makeKeychain:(NSString *)Identifier {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            Identifier, (__bridge id)kSecAttrService,
            Identifier, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

// Load Keychain
+ (id)loadKeychainData:(NSString *)Identifier
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self makeKeychain:Identifier];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
        } @finally { }
    }
    if (keyData) CFRelease(keyData);
    return ret;
}

// Delete Keychain
+ (void)deleteKeychain:(NSString *)Identifier
{
    NSMutableDictionary *keychainQuery = [self makeKeychain:Identifier];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end
