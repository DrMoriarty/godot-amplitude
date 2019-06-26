//
//  Amplitude.mm
//
//  Created by Vasiliy on 26.06.19.
//
//

#import <Foundation/Foundation.h>
#import "./Amplitude.h"
#import <Amplitude/Amplitude.h>

NSDictionary *convertFromDictionary(const Dictionary& dict)
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for(int i=0; i<dict.size(); i++) {
        Variant key = dict.get_key_at_index(i);
        Variant val = dict.get_value_at_index(i);
        if(key.get_type() == Variant::STRING) {
            NSString *strKey = [NSString stringWithUTF8String:((String)key).utf8().get_data()];
            if(val.get_type() == Variant::INT) {
                int i = (int)val;
                result[strKey] = @(i);
            } else if(val.get_type() == Variant::REAL) {
                double d = (double)val;
                result[strKey] = @(d);
            } else if(val.get_type() == Variant::STRING) {
                NSString *s = [NSString stringWithUTF8String:((String)val).utf8().get_data()];
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

GodotAmplitude::GodotAmplitude()
{
}

GodotAmplitude::~GodotAmplitude()
{
}

void GodotAmplitude::init(const String& apiKey, const String& userId)
{
    NSString *key = [NSString stringWithUTF8String:apiKey.utf8().get_data()];
    [[Amplitude instance] initializeApiKey:key];
}

void GodotAmplitude::setUserId(const String& userId)
{
    NSString *uid = [NSString stringWithUTF8String:userId.utf8().get_data()];
    [[Amplitude instance] setUserId:uid];
}

void GodotAmplitude::logEvent(const String& event, const Dictionary& params)
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

void GodotAmplitude::setUserProperties(const Dictionary& params)
{
    NSDictionary *dict = convertFromDictionary(params);
    [[Amplitude instance] setUserProperties:dict];
}

void GodotAmplitude::clearUserProperties()
{
    [[Amplitude instance] clearUserProperties];
}

void GodotAmplitude::logRevenue(const String& product, int quantity, double price)
{
    NSString *pid = [NSString stringWithUTF8String:product.utf8().get_data()];
    AMPRevenue *revenue = [[[AMPRevenue revenue] setProductIdentifier:pid] setQuantity:quantity];
    [revenue setPrice:[NSNumber numberWithDouble:price]];
    [[Amplitude instance] logRevenueV2:revenue];
}


void GodotAmplitude::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("init", "apiKey", "userId"), &GodotAmplitude::init);
    ClassDB::bind_method(D_METHOD("setUserId", "userId"), &GodotAmplitude::setUserId);
    ClassDB::bind_method(D_METHOD("logEvent", "event", "params"), &GodotAmplitude::logEvent);
    ClassDB::bind_method(D_METHOD("setUserProperties", "params"), &GodotAmplitude::setUserProperties);
    ClassDB::bind_method(D_METHOD("clearUserProperties"), &GodotAmplitude::clearUserProperties);
    ClassDB::bind_method(D_METHOD("logRevenue", "product", "quantity", "price"), &GodotAmplitude::logRevenue);
}
