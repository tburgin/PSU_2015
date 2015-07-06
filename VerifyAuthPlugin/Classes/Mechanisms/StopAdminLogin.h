//
//  StopAdminLogin.h
//  VerifyAuthPlugin
//
//  Created by Thomas Burgin on 6/19/15.
//  Copyright Thomas Burgin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MechanismHelper.h"
#import "AuthorizationPlugin.h"
#import "PromptWindowController.h"

OSStatus initializePromptWindowController(AuthorizationMechanismRef inMechanism, BOOL isWarning);

@interface StopAdminLogin : NSObject

/**
 *  This is the mechanism for the plugin. It makes the authorization decisions.
 *
 *  Check for admin in the username.
 *  Stop the login if admin exists in the username.
 *
 *  @param inMechanism AuthorizationMechanismRef
 *
 *  @return OSStatus
 */
+ (OSStatus) runMechanism:(AuthorizationMechanismRef)inMechanism;

@end
