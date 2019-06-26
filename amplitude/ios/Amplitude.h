//
//  Amplitude.h
//
//  Created by Vasiliy on 26.06.19.
//
//

#ifndef Amplitude_h
#define Amplitude_h

#include "core/object.h"

class GodotAmplitude : public Object {
    GDCLASS(GodotAmplitude, Object);

    static void _bind_methods();

public:
    GodotAmplitude();
    ~GodotAmplitude();

    void init(const String& apiKey, const String& userId);
    void setUserId(const String& userId);
    void logEvent(const String& event, const Dictionary& params);
    void setUserProperties(const Dictionary& params);
    void clearUserProperties();
    void uploadEvents();
    void logRevenue(const String& product, int quantity, double price);
};

#endif /* Amplitude_h */
