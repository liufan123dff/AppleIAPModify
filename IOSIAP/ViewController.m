//
//  ViewController.m
//  IOSIAP
//
//  Created by w99wen on 15/12/2.
//  Copyright © 2015年 com.longtugame. All rights reserved.
//

#import "ViewController.h"
#import "OSIOSIAPKit.h"

@interface ViewController ()<OSIOSIAPProtocal>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    [OSIOSIAPKit sharedInstance].delegate = self;
    [OSIOSIAPKit fetchProductInformationForIds:[self DataTOjsonString:@{@"productIds":@[@"doudizhu_test001",@"doudizhu_test002"]}]];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    [btn1 setTitle:@"支付1" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    [btn2 setTitle:@"支付2" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
-(void)btn1Pressed{
    NSLog(@"btn1Pressed");
    [OSIOSIAPKit buy:@"doudizhu_test001"];
}
-(void)btn2Pressed{
    NSLog(@"btn2Pressed");
    [OSIOSIAPKit buy:@"doudizhu_test002"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onPaymentResult:(OSIOSIAPResult)result info:(NSDictionary *)info{
    NSLog(@"onPaymentResult : result = %ld,info = %@",(long)result,[info description]);
}
-(void)onProductRequestResult:(OSIOSIAPResult)result info:(NSDictionary *)info{
    NSLog(@"onProductRequestResult : result = %ld,info = %@",(long)result,[info description]);
}
@end
