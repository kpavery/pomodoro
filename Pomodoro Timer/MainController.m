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
		self.notifications = YES;
    }
    return self;
}

- (IBAction)buttonPressed:(id)sender {
    if (!self.timer) {
        [self.button setTitle:@"Stop"];
        
        [self.progressBar setHidden:NO];
        [self.status setHidden:NO];
		
		[self.intervalField setEnabled:NO];
		[self.intervalStepper setEnabled:NO];
		[self.breakField setEnabled:NO];
		[self.breakStepper setEnabled:NO];
		[self.notificationsButton setEnabled:NO];
        
        [self breakTimerFired];
		[self progressBarUpdater];
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
		
		[self.intervalField setEnabled:YES];
		[self.intervalStepper setEnabled:YES];
		[self.breakField setEnabled:YES];
		[self.breakStepper setEnabled:YES];
		[self.notificationsButton setEnabled:YES];
		
		NSUserNotificationCenter* center = [NSUserNotificationCenter defaultUserNotificationCenter];
		[center removeAllDeliveredNotifications];
    }
}

- (IBAction)toggleNotifications:(id)sender {
	self.notifications = !self.notifications;
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
	self.startTime = [NSDate timeIntervalSinceReferenceDate];
	self.endTime = self.startTime + breakTimeInSeconds;
    
    [self.status setStringValue:@"Break"];
    [self.status setTextColor:[NSColor colorWithCalibratedRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
    [self.progressBar setDoubleValue:0.0];
	
	NSUserNotification* notification = [[NSUserNotification alloc] init];
	[notification setTitle:@"Break"];
	[notification setInformativeText:[NSString stringWithFormat:@"Rest for %li minutes.",(long)self.breakTime]];
	
	NSUserNotificationCenter* center = [NSUserNotificationCenter defaultUserNotificationCenter];
	[center removeAllDeliveredNotifications];
	if (self.notifications) {
		[center deliverNotification:notification];
	}
	
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
	self.startTime = [NSDate timeIntervalSinceReferenceDate];
	self.endTime = self.startTime + intervalTimeInSeconds;
    
    [self.status setStringValue:@"Interval"];
    [self.status setTextColor:[NSColor colorWithCalibratedRed:0.5 green:0.0 blue:0.0 alpha:1.0]];
    [self.progressBar setDoubleValue:0.0];
	
	NSUserNotification* notification = [[NSUserNotification alloc] init];
	[notification setTitle:@"Interval"];
	[notification setInformativeText:[NSString stringWithFormat:@"Work for %li minutes.",(long)self.breakTime]];
	
	NSUserNotificationCenter* center = [NSUserNotificationCenter defaultUserNotificationCenter];
	[center removeAllDeliveredNotifications];
	if (self.notifications) {
		[center deliverNotification:notification];
	}
	
    [self getiTunes];
    if ([self.iTunes isRunning]) {
        if ([self.iTunes playerState] == iTunesEPlSPaused) {
            NSLog(@"Unpaused iTunes");
            [self.iTunes playpause];
        }
    }
}

- (void)progressBarUpdater {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        while (self.timer) {
            sleep(1);
			int length = self.endTime - self.startTime;
			int position = [NSDate timeIntervalSinceReferenceDate] - self.startTime;
			double newProgress = (double)position/(double)length;
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.progressBar setDoubleValue:newProgress];
            });
        }
    });
}

@end
