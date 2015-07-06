//
//  PromptWindowController.h
//  VerifyAuthPlugin
//
//  Created by Thomas Burgin on 6/19/15.
//  Copyright Thomas Burgin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <Security/AuthorizationPlugin.h>

@interface PromptWindowController : NSWindowController <NSWindowDelegate> {
    void *mMechanismRef;
}

/**
 *  Sets the AuthorizationMechanismRef for callbacks or future data needs
 *
 *  @param ref AuthorizationMechanismRef
 */
- (void)setRef:(void *)ref;

/**
 *  Default window method
 */
- (void) awakeFromNib;

@property (nonatomic, strong) NSSound *tts;
@property (nonatomic) BOOL isWarned;
@property (weak) IBOutlet NSTextField *textTitle;
@property (weak) IBOutlet NSTextField *textSubTitle;
@property (weak) IBOutlet NSTextField *textInstructions;
@property (weak) IBOutlet NSTextField *textHelpDesk;
@property (weak) IBOutlet NSTextField *textAction;
@property (weak) IBOutlet NSWindow *backdropWindow;
@property (weak) IBOutlet NSButton *okayButtonOutlet;

- (IBAction)okayButton:(id)sender;


@end
