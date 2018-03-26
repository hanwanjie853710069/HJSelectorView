//
//  ViewController.m
//  HJSelectorView
//
//  Created by 王木木 on 2018/3/26.
//  Copyright © 2018年 Mr.H. All rights reserved.
//

#import "ViewController.h"
#import "HJSelectorView.h"
@interface ViewController ()<HJSelectorViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    
    label.text = @"请点击屏幕";
    
    label.font = [UIFont systemFontOfSize:30];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor redColor];
    
    [self.view addSubview:label];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
        NSMutableArray *arry =  [NSMutableArray new];
    
        [arry addObject:@[@"你好王木木",@"你好王木木",@"你好王木木",@"你好王木木",@"你好王木木"]];
    
        HJSelectorView *view = [[HJSelectorView alloc] initWithDataArray:arry delegate:self];
    
        [view show];
    
}

#pragma HJSelectorViewDelegate 代理
- (void)actionSelectorCancel:(HJSelectorView *)actionSelector {
    
    NSLog(@"取消");
    
}

- (void)actionSelector:(HJSelectorView *)actionSelector didDismissWithDataArray:(NSMutableArray *)dataArray {
    
    for (NSString *str in dataArray) {
        
        NSLog(@"%@",str);
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
