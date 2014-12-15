//
// Created by Agens AS for IVY
//

#import "AGSTimeProfile.h"
#include <stdlib.h>
#import <QuartzCore/QuartzCore.h>

static void (^s_logger)(NSString *log);
static BOOL s_enabled = NO;

@interface AGSTimeProfile ()

@property (nonatomic, strong, readwrite) NSMutableArray *marks;
@property (nonatomic, strong, readwrite) NSString *label;
@property (nonatomic, assign, readwrite, getter = isEnded) BOOL ended;
@property (nonatomic, assign, readwrite, getter = isMainThreadReady) BOOL mainThreadReady;
@property (nonatomic, assign, readwrite) NSTimeInterval threshold;
@property (nonatomic, assign, readwrite) NSTimeInterval startTime;

@end

@implementation AGSTimeProfile

+ (void)initialize
{
    s_logger =  [^(NSString *log){
        NSLog(@"%@", log);
    } copy];
}

+ (void)setLogger:(void (^)(NSString *log))logger
{
    s_logger = [logger copy];
}

+ (instancetype)start:(NSString *)label
{
    if(s_enabled)
    {
        AGSTimeProfile *instance = [[self alloc] init];
        instance.label = label;
        instance.marks = [NSMutableArray new];
        [instance.marks addObject:@(CACurrentMediaTime())];
        return instance;
    }
    else
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *log = [NSString stringWithFormat:@"Instance of %@ is not created. It has not been enabled. This message is only logged once.", NSStringFromClass([self class])];
            s_logger(log);
        });
        return nil;
    }
}

- (NSTimeInterval)mark
{
    NSNumber *prevMark = [self.marks lastObject];
    NSNumber *currentMark = @(CACurrentMediaTime());
    [self.marks addObject:currentMark];
    NSTimeInterval diffLast = [currentMark doubleValue] - [prevMark doubleValue];
    return diffLast;
}

- (NSTimeInterval)diffLast
{
    NSNumber *prevMark = self.marks[self.marks.count - 2];
    NSNumber *currentMark = [self.marks lastObject];
    NSTimeInterval diffLast = [currentMark doubleValue] - [prevMark doubleValue];
    return diffLast;
}

- (NSTimeInterval)diffTotal
{
    NSNumber *firstMark = self.marks[0];
    NSNumber *currentMark = [self.marks lastObject];
    NSTimeInterval diffTotal = [currentMark doubleValue] - [firstMark doubleValue];
    return diffTotal;
}

- (void)logMarkAtIndex:(NSUInteger)index tag:(NSString *)tag
{
    NSNumber *firstMark = self.marks[0];
    NSNumber *prevMark = self.marks[index - 1];
    NSNumber *currentMark = self.marks[index];
    NSTimeInterval diffLast = [currentMark doubleValue] - [prevMark doubleValue];
    NSTimeInterval diffTotal = [currentMark doubleValue] - [firstMark doubleValue];
    NSString *logString = [NSString stringWithFormat:@"[TIME] %@ | Diff last %.3fs | Diff total %.3fs | %i %@", self.label, diffLast, diffTotal, (int)index, tag];
    s_logger(logString);
}

- (void)logAllMarks
{
    for(int i = 1; i < self.marks.count; i++)
    {
        if(i == 1)
        {
            [self logMarkAtIndex:i tag:@"START"];
        }
        else if(i < self.marks.count - 1)
        {
            [self logMarkAtIndex:i tag:@"MARK"];
        }
        else
        {
            [self logMarkAtIndex:i tag:self.mainThreadReady ? @"END - MAIN THREAD READY" : @"END"];
        }
    }
}

- (NSTimeInterval)end
{
    NSTimeInterval diff = [self mark];
    self.ended = YES;
    return diff;
}

- (void)endWhenMainThreadIsReady:(void(^)(AGSTimeProfile *instance))onEnded
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mainThreadReady = YES;
        [self end];
        if(onEnded)
        {
            onEnded(self);
        }
    });
}

+ (void)setEnabled:(BOOL)enabled
{
    s_enabled = enabled;
}

@end
