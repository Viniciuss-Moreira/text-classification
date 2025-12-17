//
//  ChatModule.m
//  TextClassificationApp
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ChatModule, NSObject)

// MARK: - func for retrieve message
RCT_EXTERN_METHOD(getMessages:(NSString *)sessionId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// MARK: - func send message
RCT_EXTERN_METHOD(sendMessage:(NSString *)sessionId
                  text:(NSString *)text
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// MARK: - func create session
RCT_EXTERN_METHOD(createSession:(NSString *)title
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// MARK: - func get sessions
RCT_EXTERN_METHOD(getAllSessions:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// MARK: - func delete session
RCT_EXTERN_METHOD(deleteSession:(NSString *)sessionId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updateSessionTitle:(NSString *)sessionId
                  title:(NSString *)title
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
