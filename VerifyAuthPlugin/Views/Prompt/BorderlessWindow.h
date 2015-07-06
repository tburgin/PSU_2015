//
//  BorderlessWindow.h
//  VerifyAuthPlugin
//
//  Created by Thomas Burgin on 6/19/15.
//  Copyright Thomas Burgin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BorderlessWindow : NSWindow

/**
 *  This is an optional visual feature. SmartCardBannerDim if the preference value that turns on or off this dimming backdrop.
 *
 *  @param contentRect   NSRect
 *  @param aStyle        unsigned int
 *  @param bufferingType NSBackingStoreType
 *  @param flag          BOOL
 *
 *  @return id
 */
- (id) initWithContentRect:(NSRect)contentRect
                 styleMask:(unsigned int)aStyle
                   backing:(NSBackingStoreType)bufferingType
                     defer:(BOOL)flag;

@end
