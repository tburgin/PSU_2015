//
//  MechanismHelper.h
//  VerifyAuthPlugin
//
//  Created by Thomas Burgin on 6/19/15.
//  Copyright Thomas Burgin. All rights reserved.
//

#import "MechanismHelper.h"

@implementation MechanismHelper

+ (BOOL) MechanismValid:(const MechanismRecord *)mechanism {
    return (mechanism != NULL)
    && (mechanism->fMagic == kMechanismMagic)
    && (mechanism->fEngine != NULL)
    && (mechanism->fPlugin != NULL);
}

+ (NSString *)getUserName:(AuthorizationMechanismRef)inMechanism {
    MechanismRecord *mechanism;
    mechanism = (MechanismRecord *) inMechanism;
    assert([self MechanismValid:mechanism]);
    
    OSStatus                    err;
    const AuthorizationValue    *value;
    AuthorizationContextFlags   flags;
    NSString                    *userName = NULL;
    
    // Get the AuthorizationEnvironmentUsername
    err = noErr;
    NSLog(@"VerifyAuth:MechanismInvoke:getUserName [+] attempting to receive kAuthorizationEnvironmentUsername");
    err = mechanism->fPlugin->fCallbacks->GetContextValue(mechanism->fEngine, kAuthorizationEnvironmentUsername, &flags, &value);
    if (err == noErr) {
        if ((value->length > 0) && (((const char *) value->data)[value->length - 1] == 0)) {
            userName = [[NSString alloc] initWithUTF8String: (const char *) value->data];
            NSLog(@"VerifyAuth:MechanismInvoke:getUserName [+] kAuthorizationEnvironmentUsername [%@] was used.", userName);
        }
    } else {
        NSLog(@"VerifyAuth:MechanismInvoke:getUserName [!] kAuthorizationEnvironmentUsername was unreadable.");
    }
    
    return userName;

    
}

@end
