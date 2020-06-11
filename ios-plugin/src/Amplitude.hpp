//
//  Amplitude.h
//
//  Created by Vasiliy on 26.06.19.
//
//

#ifndef Amplitude_h
#define Amplitude_h

#include <Godot.hpp>
#include <Object.hpp>

class AmplitudePlugin : public godot::Object {
    GODOT_CLASS(AmplitudePlugin, godot::Object);

public:
    AmplitudePlugin();
    ~AmplitudePlugin();

    static void _register_methods();
    void _init();

    void init(const godot::String apiKey, const godot::String userId);
    void setUserId(const godot::String userId);
    void logEvent(const godot::String event, const godot::Dictionary params);
    void setUserProperties(const godot::Dictionary params);
    void clearUserProperties();
    void uploadEvents();
    void logRevenue(const godot::String product, int quantity, double price, const godot::String receipt, const godot::String signature /* not used*/);
};

#endif /* Amplitude_h */
