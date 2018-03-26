//
//  HJSelectorView.m
//  HJSelector
//
//  Created by 王木木 on 2018/3/26.
//  Copyright © 2018年 Mr.H. All rights reserved.
//

#import "HJSelectorView.h"

/** 功能按钮类型 */
typedef enum : NSUInteger {
    Type_cancel,   /** 取消 */
    Type_determine,/** 确定 */
} ItemType;

@interface HJSelectorView ()
<UIPickerViewDataSource,
UIPickerViewDelegate>
{
    
    CGFloat _screenWidth;        /** 屏幕的宽 */
    
    CGFloat _screenHeight;       /** 屏幕的高 */
    
    UIView * _itemsView;         /** 容器view */
    
    UIPickerView * _pickerView;  /** 选择器 */
    
    UIView * _toolView;          /** 功能view */
    
}

/** 当前弹出试图的 window */
@property (nonatomic,strong) UIWindow *window;

/** 数据源 */
@property (nonatomic,strong) NSMutableArray *dataArray;

/** 代理 */
@property (nonatomic,assign) id<HJSelectorViewDelegate>delegate;

@end

@implementation HJSelectorView

/**
 初始化window
 
 @return window
 */
-(UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.hidden = YES;
        [_window setExclusiveTouch:YES];
        UIEvent *event = [[UIEvent alloc] init];
        [_window sendEvent:event];
    }
    
    return _window;
}


-(id)initWithConfirm:(NSString *)confirmButtonTitle
              cancel:(NSString *)cancelButtonTitle
           dataArray:(NSMutableArray *)dataArray
            delegate:(id<HJSelectorViewDelegate>)delegate
{
    
    self = [super init];
    
    if (self) {
    
        if (delegate) { self.delegate = delegate; }
        
        [self bulidDataArray:dataArray];
    
        [self buildSelfAndTouchView];
        
        [self creatItemsView];
        
        [self animation];
        
    }
    
    [self.window addSubview:self];
    
    return self;
    
}

-(id)initWithDataArray:(NSMutableArray *)dataArray
              delegate:(id<HJSelectorViewDelegate>)delegate {
    
   return [self initWithConfirm:@"确定"
                         cancel:@"取消"
                      dataArray:dataArray
                       delegate:delegate];
}

/**
 构建数据源

 @param dataArray 外部传入的数据
 */
-(void)bulidDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = [NSMutableArray new];
    
    NSMutableArray *tempArray = dataArray ? dataArray : [NSMutableArray new];
    
    if (tempArray.count != 0) {
        
        id obj = tempArray[0];
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            [_dataArray addObject:tempArray];
            
        }else {
            
            _dataArray = dataArray;
            
        }
        
    }else {
        
        _dataArray = [NSMutableArray new];
        
    }
    
}

/**
 构建当前视图样式和视图点击事件
 */
-(void)buildSelfAndTouchView {
    
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.frame = CGRectMake(0, 0, _screenWidth, _screenHeight);
    
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    
    //背景点击
    UIButton *bgButton = [[UIButton alloc] initWithFrame:self.frame];
    
    [bgButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    bgButton.tag = 9995;
    
    [self addSubview:bgButton];
    
}


/**
 创建子视图
 */
-(void)creatItemsView {
    
    /// 底部view
    _itemsView = [[UIView alloc]initWithFrame:CGRectMake(0, _screenHeight, _screenWidth, 244)];
    
    _itemsView.backgroundColor = [UIColor grayColor];
    
    [self addSubview:_itemsView];
    
    /// 选择器view
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, _screenWidth, 200)];
    
    _pickerView.backgroundColor = [UIColor whiteColor];
    
    _pickerView.delegate = self;
    
    [_itemsView addSubview:_pickerView];
    
    /// 功能view
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 44)];
    
    _toolView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
     
    [_itemsView addSubview:_toolView];
    
    /// 确定和取消按钮
    UIButton *cancel = [self creatItemBtn:@"取消" type:Type_cancel];
    
    UIButton *determine = [self creatItemBtn:@"确定" type:Type_determine];
    
    [cancel addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [determine addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cancel.tag = 9996;
    
    determine.tag = 9997;
    
    [_itemsView addSubview:cancel];
    
    [_itemsView addSubview:determine];
    
}


/**
 创建功能按钮

 @param name 标题
 @param type 类型
 @return 对象
 */
- (UIButton *)creatItemBtn:(NSString *)name
                      type:(ItemType)type {
    
    CGRect frame = type == Type_cancel ?
    CGRectMake(0, 0, 60, 44) :
    CGRectMake(_screenWidth - 60 , 0, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    
    [btn setTitle:name forState:UIControlStateNormal];
    
    UIColor *color = type == Type_cancel ?
    [UIColor colorWithRed:0.70f green:0.70f blue:0.70f alpha:1.00f] :
    [UIColor colorWithRed:0.14f green:0.95f blue:1.00f alpha:1.00f];
    
    UIColor *colorSelect = type == Type_cancel ?
    [UIColor colorWithRed:0.70f green:0.70f blue:0.70f alpha:0.5f] :
    [UIColor colorWithRed:0.14f green:0.95f blue:1.00f alpha:0.5f];
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    
    [btn setTitleColor:colorSelect forState:UIControlStateHighlighted];
    
    return btn;
    
}

#pragma mark - pickerView协议方法

/// 几个分区
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return _dataArray.count;
    
}

/// 每个分区的个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   
    return [_dataArray[component] count];
    
}

/// 每个分区每行的数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = _dataArray[component][row];
    
    return str;
    
}

/// 选中的回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{}

/// 自定义view
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
//          forComponent:(NSInteger)component reusingView:(UIView *)view
//{ }

#pragma mark -- buttonClick
-(void)buttonClick:(UIButton *)btn
{
    
    if (btn.tag == 9995 || btn.tag == 9996) {
        
        [self cancel];
        
        return;
        
    }

    [self touchDetermine];
    
}

/// 点击确定按钮事件
-(void)touchDetermine {
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        NSInteger row = [_pickerView selectedRowInComponent:i];
        
        NSString *str = _dataArray[i][row];
        
        [array addObject:str];
        
    }
    
    for (NSString *str in array) {
        
        NSLog(@"%@",str);
        
    }
    
    CGRect frame = _itemsView.frame;
    frame.origin.y = _screenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        _itemsView.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.window.hidden = YES;
            [self removeFromSuperview];
            
            if ([self.delegate respondsToSelector:@selector(actionSelector:didDismissWithDataArray:)]) {
                
                [self.delegate actionSelector:self didDismissWithDataArray:array];
                
            }
            
        }];
    }];
    
}

#pragma mark -- 弹出动画
-(void)animation
{
    CGRect frame = _itemsView.frame;
    
    frame.origin.y = _screenHeight - _itemsView.frame.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        
        _itemsView.frame = frame;
        
    }];
    
}

#pragma mark -- Cancel
-(void)cancel
{
    CGRect frame = _itemsView.frame;
    
    frame.origin.y = _screenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _itemsView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            self.window.hidden = YES;
            
            [self removeFromSuperview];
            
            if ([self.delegate respondsToSelector:@selector(actionSelectorCancel:)]) {
                
                [self.delegate actionSelectorCancel:self];
                
            }
            
        }];
    }];
}

-(void)show
{
    self.window.hidden = NO;
}

-(void)dealloc
{
//    NSLog(@"释放了");
}

@end
