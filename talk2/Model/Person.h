//
//  Person.h
//  5.1作业 Demo
//
//  Created by 刘森 on 16/4/30.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "JSONModel.h"
#define PRO(key) @property (copy,nonatomic)NSString<Optional>*key
@interface Person : JSONModel
PRO(name);
PRO(iconName);
PRO(nickname);

+(Person*) PersonWithName:(NSString*)name;
@end
