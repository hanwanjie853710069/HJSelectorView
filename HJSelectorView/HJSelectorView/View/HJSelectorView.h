//
//  HJSelectorView.h
//  HJSelector
//
//  Created by 王木木 on 2018/3/26.
//  Copyright © 2018年 Mr.H. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HJSelectorView;

//协议
@protocol HJSelectorViewDelegate <NSObject>

@optional

/**
 视图消失的时候调用

 @param actionSelector HJSelectorView
 */
- (void)actionSelectorCancel:(HJSelectorView *)actionSelector;


/**
 点击确定

 @param actionSelector HJSelectorView
 @param dataArray 选中的数据源
 */
- (void)actionSelector:(HJSelectorView *)actionSelector didDismissWithDataArray:(NSMutableArray *)dataArray;

@end

@interface HJSelectorView : UIView

/**
 初始化选择器
 
 @param dataArray 数据源
 @param delegate 代理
 @return 对象
 */
-(id)initWithDataArray:(NSMutableArray *)dataArray
            delegate:(id<HJSelectorViewDelegate>)delegate;


/**
 初始化选择器

 @param confirmButtonTitle 确定名称
 @param cancelButtonTitle 取消名称
 @param dataArray 数据源
 @param delegate 代理
 @return 对象
 */
-(id)initWithConfirm:(NSString *)confirmButtonTitle
              cancel:(NSString *)cancelButtonTitle
           dataArray:(NSMutableArray *)dataArray
            delegate:(id<HJSelectorViewDelegate>)delegate;

/**
 显示
 */
-(void)show;

/**
 取消
 */
-(void)cancel;

@end
