//
//  SummerViewController.m
//  YXLTitlePanelDemo
//
//  Created by Tangtang on 16/5/28.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "SummerViewController.h"

@interface SummerViewController ()

@end

@implementation SummerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    NSLog(@"%@", self.title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
