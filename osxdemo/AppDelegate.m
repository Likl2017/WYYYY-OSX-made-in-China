//
//  AppDelegate.m
//  osxdemo
//
//  Created by openthread on 11/4/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface AppDelegate () <NSWindowDelegate>
@property (nonatomic, retain) WebView *webView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect frame = [self.window frame];
    frame.size = CGSizeMake(1280, 768);
    [self.window setFrame:frame display:YES animate:NO];
    
    self.window.delegate = self;
    
    self.webView = [[WebView alloc] initWithFrame:CGRectZero];
    [self.webView setMainFrameURL:@"http://music.163.com"];
    [self.window.contentView addSubview:self.webView];
    [self windowDidResize:nil];
}

- (void)windowDidResize:(NSNotification *)notification
{
    CGSize windowSize = self.window.frame.size;
    windowSize.height -= 20;
    self.webView.frame = (CGRect){CGPointZero, windowSize};
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
    return YES;
}


@end
