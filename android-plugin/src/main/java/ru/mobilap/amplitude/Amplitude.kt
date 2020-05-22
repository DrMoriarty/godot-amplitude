package ru.mobilap.amplitude

import android.app.Activity
import android.util.Log
import android.view.View
import org.json.JSONObject
import org.json.JSONArray
import org.json.JSONException
import java.util.Arrays
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.GodotLib
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import com.amplitude.api.Amplitude as AMP
import com.amplitude.api.AmplitudeClient
import com.amplitude.api.Revenue

class Amplitude(godot:Godot):GodotPlugin(godot) {
    //variable
    companion object {
        val TAG = Amplitude::class.java.simpleName
    }

    private val activity:Godot
    private val sdk:AmplitudeClient

    override fun getPluginName():String {
        return "Amplitude"
    }

    override fun getPluginMethods():List<String> {
        return Arrays.asList<String>(
            "init",
            "setUserId",
            "logEvent",
            "setUserProperties",
            "clearUserProperties",
            "logRevenue"
        )
    }

    /*
     val pluginSignals:Set<SignalInfo>
        get() {
           return Collections.singleton(loggedInSignal)
        }
     */

    init {
        activity = godot
        sdk = AMP.getInstance()
        Log.i(TAG, "Amplitude module started")
    }

    override fun onMainCreateView(activity:Activity):View? {
        return null
    }

    fun init(apiKey:String, userId:String) {
        if (userId != null && userId.length > 0) {
            sdk.initialize(activity, apiKey, userId)
        } else {
            sdk.initialize(activity, apiKey)
        }
        sdk.enableForegroundTracking(activity.getApplication())
        sdk.enableLocationListening()
        Log.i(TAG, "Amplitude module inited")
    }

    fun setUserId(userId:String) {
        sdk.setUserId(userId)
    }

    fun logEvent(event:String, properties:Dictionary) {
        if (properties != null) {
            sdk.logEvent(event, jsonFromDictionary(properties))
        } else {
            sdk.logEvent(event)
        }
        Log.i(TAG, "Send event: " + event)
    }

    fun setUserProperties(properties:Dictionary) {
        sdk.setUserProperties(jsonFromDictionary(properties))
    }

    fun clearUserProperties() {
        sdk.clearUserProperties()
    }

    fun logRevenue(productId:String, quantity:Int, price:Float, receipt:String, signature:String) {
        //Log.i(TAG, "Revenue: " + productId + " " + Integer.toString(quantity) + " " + Float.toString(price));
        //sdk.logRevenue(productId, quantity, price);
        val revenue = Revenue().setProductId(productId).setPrice(price.toDouble()).setQuantity(quantity).setReceipt(receipt, signature)
        sdk.logRevenueV2(revenue)
    }

    private fun jsonFromDictionary(dict:Dictionary):JSONObject? {
        try {
            val json = JSONObject()
            for (key in dict.get_keys()) {
                if (dict.get(key) != null) {
                    val v = dict.get(key).toString()
                    json.put(key, v)
                }
            }
            return json
        }
        catch (e:JSONException) {
            Log.e(TAG, "JSON Exception:" + e.toString())
            return null
        }
    }
}
