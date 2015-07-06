//
//  PromptWindowController.m
//  VerifyAuthPlugin
//
//  Created by Thomas Burgin on 6/19/15.
//  Copyright Thomas Burgin. All rights reserved.
//

#import "PromptWindowController.h"

// Define Required Text Constants
static NSString *const kTextTitleRequired          = @"Admin Account Login Detected";
static NSString *const kTextSubRequired            = @"Policy does not allow this account to login interactively";
static NSString *const kTextInstructionsRequired   = @"Login with a Standard Account";
static NSString *const kTextHelpDeskRequired       = @"If you need assistance, please contact the Helpdesk";
static NSString *const kTextActionRequired         = @"You will not be allowed to continue";
static NSString *const kTTSRequired                = @"/Library/Security/SecurityAgentPlugins/VerifyAuthPlugin.bundle/Contents/Resources/shallnotpass.mp3";;

// Setup Mechanism Ref
static void *lastMechanismRef;

// Define initializePromptWindowController
OSStatus initializePromptWindowController(AuthorizationMechanismRef inMechanism, BOOL isWarning);

// Implement initializePromptWindowController
OSStatus initializePromptWindowController(AuthorizationMechanismRef inMechanism, BOOL isWarning)
{
    // Set the subclass to none. New instance every time.
    // Allows the window to be laucnhed over and over while
    // at the same LoginWindow
    // Launch Warning App
    PromptWindowController *promptWindowController = nil;

    if (!promptWindowController)
    {
        promptWindowController = [[PromptWindowController alloc] init];
        [promptWindowController setRef:inMechanism];
        [promptWindowController setIsWarned:isWarning];
        [NSApp runModalForWindow:[promptWindowController window]];
    }
    
    return 0;
}


@interface PromptWindowController ()

@end

@implementation PromptWindowController

- (void)setRef:(void *)ref
{
    mMechanismRef = ref;
    lastMechanismRef = ref;
}

- (id)init
{
    if ([super init])
        self = [super initWithWindowNibName:@"PromptWindowController"];
    return self;
}

- (void) awakeFromNib {
    
    NSLog(@"VerifyAuth:MechanismInvoke:PromptWindowController [+] awakeFromNib.");
    
    CFPropertyListRef value;
    NSString *textSubWarningFromPref;
    NSString *textSubRequiredFromPref;
    NSString *textHelpDeskFromPref;
    
    // Initialize the Remote Logging Option String
    value = CFPreferencesCopyValue(CFSTR("SubTitleWarning"), CFSTR("com.burginsystems.VerifyAuthPlugin"), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    if (value && CFGetTypeID(value) == CFStringGetTypeID()) {
        textSubWarningFromPref = [NSString stringWithString:(__bridge NSString *)value];
    }
    if ( value ) CFRelease(value);
    
    // Initialize the Remote Logging Option String
    value = CFPreferencesCopyValue(CFSTR("SubTitleEnforced"), CFSTR("com.burginsystems.VerifyAuthPlugin"), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    if (value && CFGetTypeID(value) == CFStringGetTypeID()) {
        textSubRequiredFromPref = [NSString stringWithString:(__bridge NSString *)value];
    }
    if ( value ) CFRelease(value);
    
    // Initialize the Remote Logging Option String
    value = CFPreferencesCopyValue(CFSTR("BannerHelpDesk"), CFSTR("com.burginsystems.VerifyAuthPlugin"), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    if (value && CFGetTypeID(value) == CFStringGetTypeID()) {
        textHelpDeskFromPref = [NSString stringWithString:(__bridge NSString *)value];
    }
    if ( value ) CFRelease(value);
    
    // Set text on all fields for the type of alert
    [_textTitle setStringValue:kTextTitleRequired];
    [_textSubTitle setStringValue:(textSubRequiredFromPref != nil && [textSubRequiredFromPref length] > 0) ? textSubRequiredFromPref : kTextSubRequired];
    [_textInstructions setStringValue:kTextInstructionsRequired];
    [_textHelpDesk setStringValue:(textHelpDeskFromPref != nil && [textHelpDeskFromPref length] > 0) ? textHelpDeskFromPref : kTextHelpDeskRequired];
    [_textAction setStringValue:kTextActionRequired];
    
    // Get the Main Screen's size
    NSRect screenRect = [[NSScreen mainScreen] frame];
    // Make a copy for editing
    NSRect windowRect = screenRect;
    // Create a starting location and Main Window size
    // Squish the height by 60. A nice expantion animation
    // Center the Window. Offset y axis by 60.
    // This will give a nice and slow upwards movement
    NSRect startSize;
    startSize.size.width = 610.0;
    startSize.size.height = 400.0;
    startSize.origin.x = windowRect.size.width / 2 - 305;
    startSize.origin.y = windowRect.size.height / 2 - 210;
    
     // Make the changes
    [[self window] setFrame:startSize display:TRUE];

    // Make the window visible at the LoginWindow
    // Set the order so the Main Window will
    // be ontop of the BackdropWindow
    [[self window] setCanBecomeVisibleWithoutLogin:TRUE];
    [[self window] setLevel:NSScreenSaverWindowLevel + 1];
    [[self window] orderFrontRegardless];
    
    // Set the final destination of the Main Window
    // Centered on x
    // y offset by 80 towards the top of the display
    windowRect.origin.x = windowRect.size.width / 2 - 305;
    windowRect.origin.y = windowRect.size.height / 2 - 150;
    windowRect.size.width = 610.0;
    windowRect.size.height = 460.0;
    
    // First animation moves to Main Window up
    // into the final position.
    NSDictionary *mainWindowAnimationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [self window], NSViewAnimationTargetKey,\
                                           [NSValue valueWithRect:startSize], NSViewAnimationStartFrameKey, \
                                           [NSValue valueWithRect:windowRect], NSViewAnimationEndFrameKey, nil];
    
    // Start the animation on NonblockingThread. This allows both the Main Window
    // and Backdrop Window to animate at the same time.
    NSViewAnimation *windowAnimation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:mainWindowAnimationDict, nil]];
    [windowAnimation setDuration:0.6];
    [windowAnimation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
    [windowAnimation startAnimation];

    // Get BannerDim preference
    BOOL bannerDim = FALSE;
    value = CFPreferencesCopyValue(CFSTR("BannerDim"), CFSTR("com.burginsystems.VerifyAuthPlugin"), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    if (value && CFGetTypeID(value) == CFBooleanGetTypeID()) {
        bannerDim = CFBooleanGetValue(value);
    }
    if (value) CFRelease(value);
    
    bannerDim = TRUE;
    if (bannerDim) {
        
        // Create the fading grey backdrop
        [_backdropWindow setCanBecomeVisibleWithoutLogin:TRUE];
        [_backdropWindow setFrame:screenRect display:TRUE];
        NSColor *translucentColor = [[NSColor blackColor] colorWithAlphaComponent:0.65];
        [_backdropWindow setBackgroundColor:translucentColor];
        [_backdropWindow setOpaque:FALSE];
        [_backdropWindow setIgnoresMouseEvents:FALSE];
        [_backdropWindow setAlphaValue:0.0];
        [_backdropWindow orderFrontRegardless];

        // Second animation for the fading grey backdrop.
        // This NSViewAnimationFadeInEffect simply calls the setAlphaValue on the window over and over.
        // So we setAlphaValue to 0 initially.
        // Then the animation will fade in the window to alpha 1.
        NSDictionary *backdropWindowAnimationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 _backdropWindow, NSViewAnimationTargetKey,\
                                                 [NSValue valueWithRect:screenRect], NSViewAnimationStartFrameKey, \
                                                 [NSValue valueWithRect:screenRect], NSViewAnimationEndFrameKey, \
                                                  NSViewAnimationFadeInEffect, NSViewAnimationEffectKey,nil];
        
        NSViewAnimation *backdropWindowAnimation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:backdropWindowAnimationDict, nil]];
        [backdropWindowAnimation setDuration:1.5];
        [backdropWindowAnimation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
        [backdropWindowAnimation startAnimation];
    }
    
    NSLog(@"VerifyAuth:MechanismInvoke:PromptWindowController [+] TTS kTTSRequired");
    _tts = [[NSSound alloc] initWithContentsOfFile:kTTSRequired byReference:FALSE];
    [_tts play];
    
};


- (IBAction)okayButton:(id)sender {
    [self close];
    [_backdropWindow close];
}


- (void) windowWillClose:(NSNotification *)notification {
    if (_tts != NULL) {
        [_tts stop];
    }
    [NSApp abortModal];
}

@end
