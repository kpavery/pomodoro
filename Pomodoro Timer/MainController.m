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
        
        [self.progressBar setHidden:NO];
        [self.status setHidden:NO];
        
        [self breakTimerFired];
    } else {
        NSLog(@"Timer removed.");
        [self.timer invalidate];
        self.timer = nil;
        [self.button setTitle:@"Go"];
        
        [self.progressBar setDoubleValue:0.0];
        [self.progressBar setHidden:YES];
        [self.status setStringValue:@"Not running"];
        [self.status setTextColor:[NSColor blackColor]];
        [self.status setHidden:YES];
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
    
    NSInteger breakTimeInSeconds = self.breakTime * 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:breakTimeInSeconds target:self selector:@selector(breakTimerFired) userInfo:nil repeats:NO];
    
    [self.status setStringValue:@"Break"];
    [self.status setTextColor:[NSColor greenColor]];
    [self.progressBar setDoubleValue:0.0];
    [self updateProgressBarForSeconds:breakTimeInSeconds];
    
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
    
    NSInteger intervalTimeInSeconds = self.intervalTime * 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:intervalTimeInSeconds target:self selector:@selector(intervalTimerFired) userInfo:nil repeats:NO];
    
    [self.status setStringValue:@"Interval"];
    [self.status setTextColor:[NSColor redColor]];
    [self.progressBar setDoubleValue:0.0];
    [self updateProgressBarForSeconds:intervalTimeInSeconds];
    
    [self getiTunes];
    if ([self.iTunes isRunning]) {
        if ([self.iTunes playerState] == iTunesEPlSPaused) {
            NSLog(@"Unpaused iTunes");
            [self.iTunes playpause];
        }
    }
}

- (void)updateProgressBarForSeconds:(NSInteger)seconds {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        for (int i = 1; i < seconds; i++) {
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.progressBar setDoubleValue:(double)i/((double)seconds-1.0)];
            });
        }
    });
}

@end
