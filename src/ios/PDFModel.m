//
//  PDFViewController.m
//  plugin-demo
//
//  Created by Archer on 2017/12/14.
//

#import "PDFModel.h"
#import <iReportEngine/iReportEngine.h>
@interface PDFModel ()
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, copy)void (^reportFinsh)(BOOL isFinish_, NSString *pdfPath_, NSString *errorMessage_);
@end

@implementation PDFModel

- (instancetype) initWithParams:(NSDictionary *)params
{
    if (self = [super init]) {
        self.params = params;
    }
    return self;
}

- (void)dealloc
{
    self.params = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)generatewithCompletion:(void (^)(BOOL isFinish_, NSString *pdfPath_, NSString *errorMessage_))reportFinish
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iReportFinishHandler:)
                                                 name:@"IREPORTENGINE_NOTIFICATION_FINISH"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iReportErrorHandler:)
                                                 name:@"IREPORTENGINE_NOTIFICATION_ERROR"
                                               object:nil];
    self.reportFinsh = reportFinish;
    NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.%@", [[NSDate date] timeIntervalSince1970],@"pdf"]];
    NSURL *pdf = [NSURL fileURLWithPath:tmpPath];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.params[@"hiDic"] forKey:@"ht"];
    //    [parameters setObject:self.params[@"dataSource"] forKey:@"dataEducation"];
    [parameters setObject:@"" forKey:@"SUBREPORT_DIR"];
    [parameters setObject:@"" forKey:@"IMG_FOLDER"];
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.params[@"name"] ofType:@"jrxml"];
    NSString *xml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&
                     error];
    [iReportEngine pdfWithTemplate:xml url:pdf params:parameters];
    
}

- (void)iReportFinishHandler:(NSNotification *)n
{
    NSString *pdfPath = [n.userInfo objectForKey:@"result"];
    self.reportFinsh(YES, pdfPath, nil);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)iReportErrorHandler:(NSNotification *)n
{
    self.reportFinsh(NO, nil, [n.userInfo objectForKey:@"result"]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end

