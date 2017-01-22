//
//  AppDelegate.m
//  osxdemo
//
//  Created by openthread on 11/4/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface WebPreferences (WebPreferencesPrivate)
- (void)_setLocalStorageDatabasePath:(NSString *)path;
- (void)setLocalStorageEnabled:(BOOL)localStorageEnabled;
@end

@interface AppDelegate () <NSWindowDelegate, WebFrameLoadDelegate>
@property (nonatomic, strong) WebView *webView;
@property (nonatomic, strong) NSStatusItem *statusBar;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect frame = [self.window frame];
    frame.size = CGSizeMake(1050, 768);
    [self.window setFrame:frame display:YES animate:NO];
    
    self.window.delegate = self;
    
    self.webView = [[WebView alloc] initWithFrame:CGRectZero];
    self.webView.frameLoadDelegate = self;
    [self.webView setMainFrameURL:@"https://www.huobi.com/market/cny_btc"];
    [self.window.contentView addSubview:self.webView];
    [self windowDidResize:nil];
    
    [self initStatusBar];
    
    WebPreferences* prefs = [WebPreferences standardPreferences];
    [prefs _setLocalStorageDatabasePath:@"~/Library/Application Support/HB"];
    [prefs setLocalStorageEnabled:YES];
    [self.webView setPreferences:prefs];
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

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame])
    {
        [[sender window] setTitle:title];
        NSString *statusBarTitle = [[self class] priceFromHuobiWebSiteTitle:title];
        [self updateStatusBarWithTitle:statusBarTitle];
    }
}

- (void)initStatusBar
{
    //Init status bar icon
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:83];
    self.statusBar.highlightMode = NO;
}

- (void)updateStatusBarWithTitle:(NSString *)title
{
    self.statusBar.title = title;
}

+ (NSString *)priceFromHuobiWebSiteTitle:(NSString *)huobiWebSiteTitle
{
    NSArray *array = [huobiWebSiteTitle componentsSeparatedByString:@" "];
    for (NSString *string in array)
    {
        if ([string integerValue] != 0)
        {
            return [@"￥" stringByAppendingString:string];
        }
        else if ([string hasPrefix:@"￥"])
        {
            return string;
        }
        else if ([string hasPrefix:@"$"])
        {
            return string;
        }
    }
    return @"loading...";
}

@end
