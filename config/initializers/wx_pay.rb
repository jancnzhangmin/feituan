WxPay.appid = 'wx9ba0afe3f3f1aa14'
WxPay.key = '22b5134519b4498886c71f44de43bb68'
WxPay.mch_id = '1515191871'
WxPay.debug_mode = true # default is `true`
#WxPay.sandbox_mode = true
WxPay.appsecret = '92bdb66ae430c649d4ef4099fc5115f7'
#WxPay.set_apiclient_by_pkcs12(File.read('/home/cert/posan/apiclient_cert.p12'), '1428913502')

WxPay.extra_rest_client_options = {timeout: 20, open_timeout: 30}