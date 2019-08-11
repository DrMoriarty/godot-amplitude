package org.godotengine.godot;

import android.app.Activity;
import android.util.Log;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import com.amplitude.api.Amplitude;
import com.amplitude.api.Revenue;

public class AmplitudePlugin extends Godot.SingletonBase {
    //variable
    private static final String TAG = "Amplitude";
    private Activity activity = null;

    static public Godot.SingletonBase initialize(Activity p_activity) {

        return new AmplitudePlugin(p_activity);
    }

    //constructor
    public AmplitudePlugin(Activity p_activity) {
        //The registration of this and its functions
        registerClass("Amplitude", new String[]{
                "init",
                "setUserId",
                "logEvent",
                "setUserProperties",
                "clearUserProperties",
                "logRevenue"
        });

        activity = p_activity;
        Log.i(TAG, "Amplitude module started");
    }

    public void init(final String apiKey, final String userId) {
        if(userId != null && userId.length() > 0)
            Amplitude.getInstance().initialize(activity, apiKey, userId);
        else
            Amplitude.getInstance().initialize(activity, apiKey);
        Amplitude.getInstance().enableForegroundTracking(activity.getApplication());
        Amplitude.getInstance().enableLocationListening();
        Log.i(TAG, "Amplitude module inited");
    }

    public void setUserId(final String userId) {
        Amplitude.getInstance().setUserId(userId);
    }

    public void logEvent(final String event, final Dictionary properties) {
        if(properties != null)
            Amplitude.getInstance().logEvent(event, jsonFromDictionary(properties));
        else
            Amplitude.getInstance().logEvent(event);
        Log.i(TAG, "Send event: "+event);
    }

    public void setUserProperties(final Dictionary properties) {
        Amplitude.getInstance().setUserProperties(jsonFromDictionary(properties));
    }

    public void clearUserProperties() {
        Amplitude.getInstance().clearUserProperties();
    }
    
    public void logRevenue(final String productId, int quantity, float price) {
        //Log.i(TAG, "Revenue: " + productId + " " + Integer.toString(quantity) + " " + Float.toString(price));
        //Amplitude.getInstance().logRevenue(productId, quantity, price);
        Revenue revenue = new Revenue().setProductId(productId).setPrice(price).setQuantity(quantity);
        Amplitude.getInstance().logRevenueV2(revenue);
    }

    private JSONObject jsonFromDictionary(final Dictionary dict) {
        try {
            JSONObject json = new JSONObject();
            for(String key: dict.get_keys()) {
                if(dict.get(key) != null) {
                    String val = dict.get(key).toString();
                    json.put(key, val);
                }
            }
            return json;
        } catch (JSONException e) {
            Log.e(TAG, "JSON Exception:"+e.toString());
            return null;
        }
    }
}
