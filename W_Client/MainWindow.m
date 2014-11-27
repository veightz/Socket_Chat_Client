//
//  MainWindow.m
//  W_Client
//
//  Created by Veight Zhou on 11/14/14.
//  Copyright (c) 2014 Veight Zhou. All rights reserved.
//

#import "MainWindow.h"

#include <stdio.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

@interface MainWindow () {
    struct sockaddr_in server_addr;
    int server_socket;
    BOOL connectState;
}

@end

@implementation MainWindow

- (void)awakeFromNib {
    [self.textView setEditable:NO];
    connectState = NO;
}


- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    
//    [self.addr setStringValue:@"127.0.0.1"];
//    [self.port setStringValue:@"11332"];
    return self;
}



- (IBAction)connectAction:(id)sender {
    server_addr.sin_len = sizeof(struct sockaddr_in);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons([self.port.stringValue intValue]);
    server_addr.sin_addr.s_addr = inet_addr([self.addr.stringValue UTF8String]);
    bzero(&(server_addr.sin_zero),8);
    
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    
    if (server_socket == -1) {
        perror("socket error");
//        return 1;
        return;
    }
//    char recv_msg[1024];
//    char reply_msg[1024];
    
    if (connect(server_socket, (struct sockaddr *)&server_addr, sizeof(struct sockaddr_in))==0)     {
        //connect 成功之后，其实系统将你创建的socket绑定到一个系统分配的端口上，且其为全相关，包含服务器端的信息，可以用来和服务器端进行通信。
//        while (1) {
//            bzero(recv_msg, 1024);
//            bzero(reply_msg, 1024);
//            long byte_num = recv(server_socket,recv_msg,1024,0);
//            recv_msg[byte_num] = '\0';
//            printf("server said:%s\n",recv_msg);
            
//            printf("reply:");
//            scanf("%s",reply_msg);
//            if (send(server_socket, reply_msg, 1024, 0) == -1) {
//                perror("send error");
//            }
//        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (1) {
                char recv_msg[1024];
                char *recv_msg_point = recv_msg;
                bzero(recv_msg, 1024);
                long byte_num = recv(server_socket,recv_msg,1024,0);
                recv_msg[byte_num] = '\0';
                printf("server said:%s\n",recv_msg);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.textView setEditable:YES];
                    self.textView.string = [self.textView.string stringByAppendingString:@"Server:"];
                    NSString *str = [NSString stringWithCString:recv_msg_point encoding:NSUTF8StringEncoding];
                    self.textView.string = [self.textView.string stringByAppendingString:str];
                    self.textView.string = [self.textView.string stringByAppendingString:@"\n"];
                    [self.textView setEditable:NO];
                });
            }
        });
        
        connectState = YES;
        printf("Connect Successfully.");
        [self.textView setEditable:YES];
        self.textView.string = [self.textView.string stringByAppendingString:@"连接成功"];
        self.textView.string = [self.textView.string stringByAppendingString:@"\n"];
        [self.textView setEditable:NO];
    } else {
        printf("Connect Failed.");
        [self.textView setEditable:YES];
        self.textView.string = [self.textView.string stringByAppendingString:@"连接失败\n"];
        [self.textView setEditable:NO];
    }
    
}

- (IBAction)sendAction:(id)sender {
    if ([self.sendTextField.stringValue  isEqualToString:@""]) {
        return;
    }
    char reply_msg[1024];
    char *reply_msg_point;
    reply_msg_point = reply_msg;
    reply_msg_point = (char *)self.sendTextField.stringValue.UTF8String;
    
    [self.textView setEditable:YES];
    self.textView.string = [self.textView.string stringByAppendingString:@"Me:"];
    self.textView.string = [self.textView.string stringByAppendingString:self.sendTextField.stringValue];
    self.textView.string = [self.textView.string stringByAppendingString:@"\n"];
    [self.textView setEditable:NO];
    [self.sendTextField setStringValue:@""];
    
    
    NSLog(@"%s", reply_msg_point);
    
    if (connectState) {
        if (send(server_socket, reply_msg_point, 1024, 0) == -1) {
            perror("send error");
        }
    }
}

#pragma mark - Callback Methods

#pragma mark - Text Field Delegate


@end
