//
//  MainController.h
//  Pomodoro Timer
//
//  Created by Keith Avery on 9/27/14.
//  Copyright (c) 2014 Keith Avery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "iTunes.h"

@interface MainController : NSObject

@property (weak) IBOutlet NSTextField *intervalField;
@property (weak) IBOutlet NSStepper *intervalStepper;

@property (weak) IBOutlet NSTextField *breakField;
@property (weak) IBOutlet NSStepper *breakStepper;

@property (weak) IBOutlet NSButton *button;

@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (weak) IBOutlet NSButton *notificationsButton;

@property NSInteger intervalTime;
@property NSInteger breakTime;
@property BOOL notifications;

@property NSTimer *timer;

@property iTunesApplication *iTunes;

- (IBAction)takeIntegerValueForIntervalFrom:(id)sender;
- (IBAction)takeIntegerValueForBreakFrom:(id)sender;

- (void)updateUserInterface;
- (void)getiTunes;
- (void)intervalTimerFired;
- (void)breakTimerFired;

- (void)updateProgressBarForSeconds:(NSInteger)seconds;

@end
