//
//  ZJTGetModel.h
//  HappyBJL
//
//  Created by chen minyue on 2018/6/17.
//  Copyright © 2018年 B. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJTResult;

@interface ZJTGetModel : NSObject

@property(nonatomic,assign)NSInteger code;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,strong)ZJTResult *result;

@end


@interface ZJTResult : NSObject

@property(nonatomic,copy)NSString *iconimage;
@property(nonatomic,assign)NSInteger show_icon;
@property(nonatomic,copy)NSString *app_id;


@end
