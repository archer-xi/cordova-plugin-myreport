/********* cordova-plugin-myreport.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "PDFModel.h"

@interface MyReport : CDVPlugin {
    // Member variables go here.
}

@property (nonatomic, retain) PDFModel *pdfModel;

- (void)generateReport:(CDVInvokedUrlCommand*)command;
@end

@implementation MyReport

- (void)generateReport:(CDVInvokedUrlCommand*)command
{
    NSDictionary* params = [command.arguments objectAtIndex:0];
    self.pdfModel = [[PDFModel alloc] initWithParams:params];
    [self.pdfModel generatewithCompletion:^(BOOL isFinish_, NSString *pdfPath_, NSString *errorMessage_) {
        CDVPluginResult* pluginResult = nil;
        if (isFinish_) {
            NSString *pdfPath = pdfPath_;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"pdfPath": pdfPath}];
            
        } else {
            NSLog(@"%@",errorMessage_);
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage_];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)dealloc
{
    self.pdfModel = nil;
}

@end

