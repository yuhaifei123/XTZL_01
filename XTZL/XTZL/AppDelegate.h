//
//  AppDelegate.h
//  XTZL
//
//  Created by 虞海飞 on 16/7/5.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>{

    // UIWindow *window;
    UINavigationController *navigationController;
    BMKMapManager * _mapManager;
}



@property (strong, nonatomic) UIWindow *window;


@end
