//
// Created by Agens AS for IVY
//

#import <Foundation/Foundation.h>

@interface AGSTimeProfile : NSObject

@property (nonatomic, strong, readonly) NSString *label;
@property (nonatomic, assign, readonly) NSTimeInterval diffLast;
@property (nonatomic, assign, readonly) NSTimeInterval diffTotal;

/// Defaults to NSLog
+ (void)setLogger:(void (^)(NSString *log))logger;

/// When not enabled no instances will be created
/// Defaults to NO (not enabled)
+ (void)setEnabled:(BOOL)enabled;

+ (instancetype)start:(NSString *)label;
- (NSTimeInterval)mark;
- (NSTimeInterval)end;

- (void)endWhenMainThreadIsReady:(void(^)(AGSTimeProfile *instance))onEnded;
- (void)endWhenMainThreadIsReadyAndLogAllMarks;
- (void)endAndLogAllMarks;

- (void)logAllMarks;

@end
