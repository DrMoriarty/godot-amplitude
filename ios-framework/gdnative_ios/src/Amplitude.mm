//
//  Amplitude.mm
//
//  Created by Vasiliy on 26.06.19.
//
//

#import <Foundation/Foundation.h>
#import "Amplitude.hpp"
#import <Amplitude/Amplitude.h>

//#define DEBUG_ENABLED

using namespace godot;

NSDictionary *convertFromDictionary(const Dictionary& dict)
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for(int i=0; i<dict.keys().size(); i++) {
        Variant key = dict.keys()[i];
        Variant val = dict[key];
        if(key.get_type() == Variant::STRING) {
            String skey = key;
            NSString *strKey = [NSString stringWithUTF8String:skey.utf8().get_data()];
            if(val.get_type() == Variant::INT) {
                int i = (int)val;
                result[strKey] = @(i);
            } else if(val.get_type() == Variant::REAL) {
                double d = (double)val;
                result[strKey] = @(d);
            } else if(val.get_type() == Variant::STRING) {
                String sval = val;
                NSString *s = [NSString stringWithUTF8String:sval.utf8().get_data()];
                result[strKey] = s;
            } else if(val.get_type() == Variant::BOOL) {
                BOOL b = (bool)val;
                result[strKey] = @(b);
            } else if(val.get_type() == Variant::DICTIONARY) {
                NSDictionary *d = convertFromDictionary((Dictionary)val);
                result[strKey] = d;
            } else {
                ERR_PRINT("Unexpected type as dictionary value");
            }
        } else {
            ERR_PRINT("Non string key in Dictionary");
        }
    }
    return result;
}

AmplitudePlugin::AmplitudePlugin()
{
}

AmplitudePlugin::~AmplitudePlugin()
{
}

void AmplitudePlugin::_init()
{
}

void AmplitudePlugin::init(const String apiKey, const String userId)
{
    NSString *key = [NSString stringWithUTF8String:apiKey.utf8().get_data()];
    [[Amplitude instance] initializeApiKey:key];
}

void AmplitudePlugin::setUserId(const String userId)
{
    NSString *uid = [NSString stringWithUTF8String:userId.utf8().get_data()];
    [[Amplitude instance] setUserId:uid];
}

void AmplitudePlugin::logEvent(const String event, const Dictionary params)
{
    NSString *eventName = [NSString stringWithUTF8String:event.utf8().get_data()];
    if(params.size() > 0) {
        NSDictionary *dict = convertFromDictionary(params);
#ifdef DEBUG_ENABLED
        NSLog(@"Send Amplitude event: %@, %@", eventName, dict);
#endif
        [[Amplitude instance] logEvent:eventName withEventProperties:dict];
    } else {
#ifdef DEBUG_ENABLED
        NSLog(@"Send Amplitude event: %@", eventName);
#endif
        [[Amplitude instance] logEvent:eventName];
    }
}

void AmplitudePlugin::setUserProperties(const Dictionary params)
{
    NSDictionary *dict = convertFromDictionary(params);
    [[Amplitude instance] setUserProperties:dict];
}

void AmplitudePlugin::clearUserProperties()
{
    [[Amplitude instance] clearUserProperties];
}

void AmplitudePlugin::logRevenue(const String product, int quantity, double price, const String receipt, const String signature /* not used*/)
{
    NSString *pid = [NSString stringWithUTF8String:product.utf8().get_data()];
    NSString *rec = [NSString stringWithUTF8String:receipt.utf8().get_data()];
    AMPRevenue *revenue = [[[AMPRevenue revenue] setProductIdentifier:pid] setQuantity:quantity];
    [revenue setPrice:[NSNumber numberWithDouble:price]];
    [revenue setReceipt:[[NSData alloc] initWithBase64EncodedString:rec options:0]];
    [[Amplitude instance] logRevenueV2:revenue];
}

void AmplitudePlugin::_register_methods()
{
    register_method("_init", &AmplitudePlugin::_init);
    register_method("init", &AmplitudePlugin::init);
    register_method("setUserId", &AmplitudePlugin::setUserId);
    register_method("logEvent", &AmplitudePlugin::logEvent);
    register_method("setUserProperties", &AmplitudePlugin::setUserProperties);
    register_method("clearUserProperties", &AmplitudePlugin::clearUserProperties);
    register_method("logRevenue", &AmplitudePlugin::logRevenue);
}

