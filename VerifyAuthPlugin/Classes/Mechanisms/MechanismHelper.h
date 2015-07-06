//
//  MechanismHelper.h
//  VerifyAuthPlugin
//
//  Created by Thomas Burgin on 6/19/15.
//  Copyright Thomas Burgin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorizationPlugin.h"

@interface MechanismHelper : NSObject

/**
 *  Checks to make sure the Mechanism is valid
 *
 *  @param mechanism MechanismRecord
 *
 *  @return BOOL
 */
+ (BOOL) MechanismValid:(const MechanismRecord *)mechanism;


/**
 *  Gets the authenticating username
 *
 *  @param inMechanism AuthorizationMechanismRef
 *
 *  @return NSString
 */
+ (NSString *)getUserName:(AuthorizationMechanismRef)inMechanism;

@end
