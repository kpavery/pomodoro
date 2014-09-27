//
//  MainController.m
//  Pomodoro Timer
//
//  Created by Keith Avery on 9/27/14.
//  Copyright (c) 2014 Keith Avery. All rights reserved.
//

#import "MainController.h"

@implementation MainController

- (IBAction)startTimer:(id)sender {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.intervalTime target:self selector:@selector(intervalTimerFired) userInfo:nil repeats:NO];
    [self.button setTitle:@"Stop"];
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.breakTime target:self selector:@selector(breakTimerFired) userInfo:nil repeats:NO];
    
    [self getiTunes];
    if ([self.iTunes isRunning]) {
        NSLog(@"Found iTunes running.");
        if ([self.iTunes playerState] == iTunesEPlSPlaying) {
            NSLog(@"Paused iTunes");
            [self.iTunes playpause];
        }
    }
}

- (void)breakTimerFired {
    NSLog(@"Break timer fired.");
    
    [self.button setTitle:@"Go"];
    
    [self getiTunes];
    if ([self.iTunes isRunning]) {
        NSLog(@"Found iTunes running.");
        if ([self.iTunes playerState] == iTunesEPlSPaused) {
            NSLog(@"Unpaused iTunes");
            [self.iTunes playpause];
        }
    }

}

@end
