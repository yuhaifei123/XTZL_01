//
//  AppDelegate.m
//  XTZL
//
//  Created by 虞海飞 on 16/7/5.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Url.h"
#import "AllNSLog.h"
#import "GetHttp.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  //  [self autoLogin];

    //页面加载中，就把服务器返回值删除
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];

    if([as stringForKey:@"name"]!=nil){
        [as removeObjectForKey:@"name"];
        [as synchronize];
    }

    /***************  face++ **********/
    [FaceppAPI initWithApiKey:@"75e26ab2c0415e91f88569582d26a1be" andApiSecret:@"QLyELNAZtyp-9Y-qdohBgOzTiOgwwKDN"
                    andRegion:APIServerRegionCN];
    [FaceppAPI setDebugMode:YES];

    /**************** 百度地图初始化 *********************/
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"8cFhQ8F5lBWpCPVjn7xI8ncK9tBarE6x"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    return YES;
}



//自动登录
- (void) autoLogin{

    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *data = [as stringForKey:@"autologin"];

    [AllNSLog NSlog:data];

    //如果是，就自己登录
    if([data isEqualToString:@"1"]){

        //网络请求数据
        //拿数据
        //aft.. 有框架提交到服务器
//        AFHTTPRequestOperationManager *afh = [AFHTTPRequestOperationManager manager];
//        afh.responseSerializer = [AFJSONResponseSerializer serializer];

        //根路径
        NSString *url = [Url url_Login];

        NSString *name = nil;
        NSString *pass = nil;
        NSString *flag = nil;

        if([as stringForKey:@"username"]!=nil && [as stringForKey:@"passWord"]!=nil && [as stringForKey:@"flag"]!=nil){

            name = [as stringForKey:@"username"];
            pass = [as stringForKey:@"passWord"];
            flag = [as stringForKey:@"flag"];
        }

        NSDictionary *dic = @{@"username":name,@"password":pass,@"flag":flag};


        //get  方式
        [GetHttp afhGetHttp_Url:url Parameters:dic DicData:^(id data) {

            NSString *text = data[@"text"];
            NSString *code = data[@"code"];
            if(code.intValue > -1){

                NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];

                NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];

                //  [afh.requestSerializer setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>]

                [accountDefaults setObject: cookiesData forKey: @"sessionCookies"];
                [accountDefaults setObject: text forKey: @"text"];
                //放到磁盘里面
                [accountDefaults synchronize];

                [MBProgressHUD showSuccess:@"登录成功"];
            }
            else{

                [MBProgressHUD showSuccess:@"登录失败"];
                return ;
            }

        }];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//当程序将要退出
- (void)applicationWillTerminate:(UIApplication *)application {

    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    [as setObject:@"" forKey:@"name"];
    //放到磁盘里面
    
    NSLog(@"我下班了啊");
    [as synchronize];
}

@end
