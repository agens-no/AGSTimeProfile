//
// Created by Agens AS for IVY
//

#import <Foundation/Foundation.h>

@interface AGExecutionTime : NSObject

@property (nonatomic, strong, readonly) NSString *label;
@property (nonatomic, assign, readonly) NSTimeInterval diffLast;
@property (nonatomic, assign, readonly) NSTimeInterval diffTotal;

+ (instancetype)start:(NSString *)label;
- (NSTimeInterval)mark;
- (NSTimeInterval)end;
- (void)endWhenMainThreadIsReady:(void(^)(AGExecutionTime *instance))onEnded;

- (void)logAllMarks;
+ (void)setLogger:(void (^)(NSString *log))logger;

@end
