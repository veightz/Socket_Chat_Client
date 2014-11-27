//
//  MainWindow.h
//  W_Client
//
//  Created by Veight Zhou on 11/14/14.
//  Copyright (c) 2014 Veight Zhou. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindow : NSWindow <NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *addr;
@property (weak) IBOutlet NSTextField *port;
@property (weak) IBOutlet NSButton *connectButton;
@property (weak) IBOutlet NSButton *sendButton;
@property (weak) IBOutlet NSTextField *sendTextField;
@property (unsafe_unretained, atomic) IBOutlet NSTextView *textView;

- (IBAction)connectAction:(id)sender;
- (IBAction)sendAction:(id)sender;


@end
