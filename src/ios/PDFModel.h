//
//  PDFViewController.h
//  plugin-demo
//
//  Created by Archer on 2017/12/14.
//

#import <UIKit/UIKit.h>

@interface PDFModel : NSObject

- (instancetype) initWithParams:(NSDictionary *)params;
- (void)generatewithCompletion:(void (^)(BOOL isFinish_, NSString *pdfPath_, NSString *errorMessage_))reportFinish;
@end

