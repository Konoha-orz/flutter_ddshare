package com.nbyjy.flutter_ddshare;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;


import com.nbyjy.handlers.IDDShareApiHandler;
import com.nbyjy.handlers.IDDShareResponseHandler;

import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterDdsharePlugin
 */
public class FlutterDdsharePlugin extends FlutterActivity implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel channel;

    private final Map<String, Handler> handlerMap = new HashMap<String, Handler>() {{
        //platform version
        put("getPlatformVersion", (args, methodResult) -> {
            methodResult.success("Android " + android.os.Build.VERSION.RELEASE);
        });
        //注册钉钉API
        put("registerApp", (args, methodResult) -> {
            IDDShareApiHandler.registerApp(args, methodResult);
        });
        //钉钉是否安装
        put("isDDAppInstalled", (args, methodResult) -> {
            IDDShareApiHandler.checkDDInstallation(methodResult);
        });
        //钉钉授权登录
        put("sendDDAppAuth", (args, methodResult) -> {
            IDDShareApiHandler.sendDDAppAuth(args, methodResult);
        });
    }};

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.d("FlutterDDShareLog", "onAttachedToEngine==========>");
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "com.nbyjy/flutter_ddshare");
        channel.setMethodCallHandler(this);
        IDDShareResponseHandler.setChannel(channel);
    }

    public static void registerWith(Registrar registrar) {
        Log.d("FlutterDDShareLog", "registerWith==========>");
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.nbyjy/flutter_ddshare");
        channel.setMethodCallHandler(new FlutterDdsharePlugin());
        IDDShareResponseHandler.setChannel(channel);
        IDDShareApiHandler.setContext(registrar.activity().getApplicationContext());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, Object> args = (Map<String, Object>) call.arguments;
        Handler handler = handlerMap.get(call.method);
        if (handler != null) {
            try {
                handler.call(args, result);
            } catch (Exception e) {
                e.printStackTrace();
                result.error(e.getMessage(), null, null);
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
//        IDDShareApiHandler.setContext(this);
        IDDShareApiHandler.setContext(binding.getActivity());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    @FunctionalInterface
    interface Handler {
        void call(Map<String, Object> args, MethodChannel.Result methodResult) throws Exception;
    }
}
