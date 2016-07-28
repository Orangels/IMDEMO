//
//  Person.m
//  5.1作业 Demo
//
//  Created by 刘森 on 16/4/30.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "Person.h"

@implementation Person
+(Person*) PersonWithName:(NSString*)name{
    Person* per = [[Person alloc] init];
    per.name = name;
    per.iconName = @"Ape.jpg";
    per.nickname = @"码农";
    return per;
}
@end
