//
//  MainController.m
//  Pomodoro Timer
//
//  Created by Keith Avery on 9/27/14.
//  Copyright (c) 2014 Keith Avery. All rights reserved.
//

#import "MainController.h"

@implementation MainController

- (id)init {
    self = [super init];
    if (self) {
        self.intervalTime = 25;
        self.breakTime = 5;
    }
    return self;
}

- (IBAction)buttonPressed:(id)sender {
    if (!self.timer) {
        [self.button setTitle:@"Stop"];
        [self breakTimerFired];
    } else {
        NSLog(@"Timer removed.");
        [self.timer invalidate];
        self.timer = nil;
        [self.button setTitle:@"Go"];
    }
}

- (IBAction)takeIntegerValueForIntervalFrom:(id)sender {
    self.intervalTime = [sender intValue];
    [self updateUserInterface];
}

- (IBAction)takeIntegerValueForBreakFrom:(id)sender {
    self.breakTime = [sender intValue];
    [self updateUserInterface];
}

- (void)updateUserInterface {
    [self.intervalField setIntegerValue:self.intervalTime];
    [self.intervalStepper setIntegerValue:self.intervalTime];
    
    [self.breakField setIntegerValue:self.breakTime];
    [self.breakStepper setIntegerValue:self.breakTime];
}

- (void)getiTunes {
    if (!self.iTunes) {
        NSLog(@"Getting iTunes");
        self.iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    }
}

- (void)intervalTimerFired {
    NSLog(@"Interval timer fired.");
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.breakTime*60) target:self selector:@selector(breakTimerFired) userInfo:nil repeats:NO];
    
    [self getiTunes];
    if ([self.iTunes isRunning]) {
        if ([self.iTunes playerState] == iTunesEPlSPlaying) {
            NSLog(@"Paused iTunes");
            [self.iTunes playpause];
        }
    }
}

- (void)breakTimerFired {
    NSLog(@"Break timer fired.");
    
    [self getiTunes];
    if ([self.iTunes isRunning]) {
        if ([self.iTunes playerState] == iTunesEPlSPaused) {
            NSLog(@"Unpaused iTunes");
            [self.iTunes playpause];
        }
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.intervalTime*60) target:self selector:@selector(intervalTimerFired) userInfo:nil repeats:NO];
}

@end
