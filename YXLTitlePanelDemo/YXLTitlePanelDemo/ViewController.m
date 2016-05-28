//
//  ViewController.m
//  YXLTitlePanelDemo
//
//  Created by Tangtang on 16/5/28.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "ViewController.h"
#import "SpringViewController.h"
#import "SummerViewController.h"
#import "AutumnViewController.h"
#import "YXLWinterViewController.h"

#define YXLWidth    [UIScreen mainScreen].bounds.size.width
#define YXLHeight   [UIScreen mainScreen].bounds.size.height
#define YXLButtonUnSel [UIColor grayColor]
#define YXLButtonSel [UIColor colorWithRed:186 / 255.0 green:175 / 255.0 blue:58 / 255.0 alpha:1]

static CGFloat const kYXLTitleH = 44;
static CGFloat const kMaxScale = 1.3;
static int const kTag = 1;
static int const kNavBarH = 64;
static int const kButtonWidth = 70;
static int const kLineWidth = 50;

@interface ViewController ()<UIScrollViewDelegate>

//定义头部标题
@property (nonatomic, strong) UIScrollView  *titleScroller;
@property (nonatomic, strong) UIScrollView  *containScroller;

//当前选中的标题按钮
@property (nonatomic, strong) UIButton      *selectButton;

@property (nonatomic, strong) UIView        *bottomLine;

//添加的标题按钮集合
@property (nonatomic, strong) NSMutableArray <UIButton *> *titleButtons;

@end

@implementation ViewController

- (NSMutableArray <UIButton *> *)titleButtons {
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kYXLTitleH - 2, kLineWidth, 2)];
        _bottomLine.backgroundColor = YXLButtonSel;
    }
    return _bottomLine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self p_setupTitleScroller];
    [self p_setupContainScroller];
    [self p_setupChildViewController];
    [self p_setupTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.containScroller.contentSize = CGSizeMake(self.childViewControllers.count * YXLWidth, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置头部标题栏
- (void)p_setupTitleScroller {
    int y = self.navigationController ? kNavBarH : 0;
    
    self.titleScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, YXLWidth, kYXLTitleH)];
    self.titleScroller.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleScroller];
    
    [self.titleScroller addSubview:self.bottomLine];
}

#pragma mark - 设置内容
- (void)p_setupContainScroller {
    int navH = self.navigationController ? kNavBarH : 0;
    int y = navH + kYXLTitleH;
    
    self.containScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, YXLWidth, YXLHeight - y)];
    self.containScroller.backgroundColor = [UIColor whiteColor];
    self.containScroller.delegate = self;
    self.containScroller.pagingEnabled = YES;
    self.containScroller.showsHorizontalScrollIndicator = NO;
    self.containScroller.bounces = NO;
    [self.view addSubview:self.containScroller];
}

#pragma mark - 添加子控制器
- (void)p_setupChildViewController {
    SpringViewController *springVC = [[SpringViewController alloc] init];
    springVC.title = @"春";
    [self addChildViewController:springVC];
    
    SummerViewController *summerVC = [[SummerViewController alloc] init];
    summerVC.title = @"夏";
    [self addChildViewController:summerVC];
    
    AutumnViewController *autumVC = [[AutumnViewController alloc] init];
    autumVC.title = @"秋";
    [self addChildViewController:autumVC];
    
    YXLWinterViewController *winterVC = [[YXLWinterViewController alloc] init];
    winterVC.title = @"冬";
    [self addChildViewController:winterVC];
    
}

#pragma mark - 添加标题
- (void)p_setupTitle {
    NSUInteger icount = self.childViewControllers.count;
    
    CGFloat currentX = 0;
    CGFloat width = kButtonWidth;
    CGFloat height = kYXLTitleH;
    
    for (int index = 0; index < icount; index++) {
        UIViewController *VC = self.childViewControllers[index];
        currentX = index * width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(currentX, 0, width, height);
        button.tag = kTag * index;
        
        [button setTitle:VC.title forState:UIControlStateNormal];
        [button setTitleColor:YXLButtonUnSel forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.f];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScroller addSubview:button];
        [self.titleButtons addObject:button];
        
        if (index == 0) {
            [self buttonAction:button];
        }
        
    }
    self.titleScroller.contentSize = CGSizeMake(icount * width, 0);
    self.titleScroller.showsHorizontalScrollIndicator = NO;

}

#pragma mark - 按钮点击事件
- (void)buttonAction:(UIButton *)sender {
    [self p_selectButton:sender];
    
    NSUInteger index = sender.tag / kTag;
    [self p_setupOneChildController:index];
    
    self.containScroller.contentOffset = CGPointMake(index * YXLWidth, 0);
}

#pragma mark - 选中按钮进行的操作
- (void)p_selectButton:(UIButton *)button {
    [self.selectButton setTitleColor:YXLButtonUnSel forState:UIControlStateNormal];
    //将选中的button的transform重置
    self.selectButton.transform = CGAffineTransformIdentity;
    
    [button setTitleColor:YXLButtonSel forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(kMaxScale, kMaxScale);
    
    //添加按钮下面线的移动动画
    CGFloat x = button.frame.origin.x + (kButtonWidth * 0.15) + (kButtonWidth - kLineWidth) / 2.0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomLine.frame = CGRectMake(x, self.bottomLine.frame.origin.y, kLineWidth, self.bottomLine.frame.size.height);
    } completion:nil];
    
    self.selectButton = button;
    [self p_setupButtonCenter:button];
}

#pragma mark - 将当前选中的按钮置于中心
- (void)p_setupButtonCenter:(UIButton *)button {
    CGFloat offSet = button.center.x - YXLWidth * 0.5;
    CGFloat maxOffSet = self.titleScroller.contentSize.width - YXLWidth;
    if (offSet > maxOffSet) {
        offSet = maxOffSet;
    }
    
    if (offSet < 0) {
        offSet = 0;
    }
    
    [self.titleScroller setContentOffset:CGPointMake(offSet, 0) animated:YES];
}

#pragma mark - 添加一个子视图方法
- (void)p_setupOneChildController:(NSUInteger)index {
    CGFloat x = index * YXLWidth;
    UIViewController *VC = self.childViewControllers[index];
    
    //判断是否已经加上
    if (VC.view.superview) {
        return;
    }
    
    VC.view.frame = CGRectMake(x, 0, YXLWidth, YXLHeight - self.containScroller.frame.origin.y);
    
    [self.containScroller addSubview:VC.view];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger i = self.containScroller.contentOffset.x / YXLWidth;
    [self p_selectButton:self.titleButtons[i]];
    [self p_setupOneChildController:i];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSUInteger leftIndex = offset / YXLWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    UIButton *leftButton = self.titleButtons[leftIndex];
    UIButton *rightButton = nil;
    if (rightIndex < self.titleButtons.count) {
        rightButton = self.titleButtons[rightIndex];
    }
    
    CGFloat transScale = kMaxScale - 1;
    CGFloat rightScale = offset / YXLWidth - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    leftButton.transform = CGAffineTransformMakeScale(leftScale * transScale + 1, leftScale * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(rightScale * transScale + 1, rightScale * transScale + 1);
    
}

@end
