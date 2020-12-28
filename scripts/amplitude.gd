extends Node

var _am = null
var _web = false

func _ready():
    pause_mode = Node.PAUSE_MODE_PROCESS
    var device_id = OS.get_unique_id()
    if device_id == null or device_id == "":
        device_id = 'GODOT SIMULATOR'
    if Engine.has_singleton("Amplitude"):
        _am = Engine.get_singleton("Amplitude")
        print('Amplitude plugin inited')
    elif OS.get_name() == 'iOS':
        _am = load("res://addons/amplitude-ios/amplitude.gdns").new()
        print('Amplitude plugin inited')
    elif OS.has_feature('HTML5'):
        _web = true
    else:
        push_warning('Amplitude plugin not found!')
    if ProjectSettings.has_setting('Amplitude/API_KEY'):
        var app_key = ProjectSettings.get_setting('Amplitude/API_KEY')
        init(app_key, device_id)
    else:
        push_warning('You need to init Amplitude with api_key before using it')

func init(key, uid):
    if _am != null:
        _am.init(key, uid)
    elif _web:
        JavaScript.eval("""
        amplitude.getInstance().init('%s');
        """%[key], false)

func setUserId(userId):
    if _am != null:
        _am.setUserId(userId)
    elif _web:
        JavaScript.eval("""
        amplitude.getInstance().setUserId('%s');
        """%userId, false)

func logEvent(event, params={}):
    if params == null:
        params = {}
    if _am != null:
        _am.logEvent(event, params)
    elif _web:
        JavaScript.eval("""
        amplitude.getInstance().logEvent('%s', %s);
        """%[event, JSON.print(params)], false)
    
func setUserProperties(props):
    if _am != null:
        _am.setUserProperties(props)
    elif _web:
        JavaScript.eval("""
        amplitude.getInstance().setUserProperties(%s);
        """%[JSON.print(props)], false)

func clearUserProperties():
    if _am != null:
        _am.clearUserProperties()
    elif _web:
        JavaScript.eval("""
        amplitude.getInstance().clearUserProperties();
        """, false)

func logRevenue(productId, quantity, price, receipt='', signature=''):
    if _am != null:
        _am.logRevenue(productId, quantity, price, receipt, signature)
    elif _web:
        JavaScript.eval("""
        var revenue = new amplitude.Revenue().setProductId('%s').setPrice(%s).setQuantity(%s);
        amplitude.getInstance().logRevenueV2(revenue);
        """%[productId, var2str(price), var2str(quantity)], false)

