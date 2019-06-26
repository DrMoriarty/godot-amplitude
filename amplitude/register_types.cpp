#include "register_types.h"
#if defined(__APPLE__)
#include "ios/Amplitude.h"
#endif

void register_amplitude_types() {
#if defined(__APPLE__)
	ClassDB::register_class<GodotAmplitude>();
#endif
}

void unregister_amplitude_types() {
}
