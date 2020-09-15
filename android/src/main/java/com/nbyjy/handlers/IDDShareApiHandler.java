package com.nbyjy.handlers;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.Nullable;

import com.android.dingtalk.share.ddsharemodule.DDShareApiFactory;
import com.android.dingtalk.share.ddsharemodule.IDDAPIEventHandler;
import com.android.dingtalk.share.ddsharemodule.IDDShareApi;
import com.android.dingtalk.share.ddsharemodule.message.SendAuth;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel;


public class IDDShareApiHandler {

    @Nullable
    private static IDDShareApi iddShareApi;
    private static Context context;
    public static IDDShareApiHandler INSTANCE;
    public static String APP_ID;

    @Nullable
    public final IDDShareApi getIddShareApi() {
        return iddShareApi;
    }

    public static void setContext(@Nullable Context context) {
        Log.d("FlutterDDShareLog", "set context");
        IDDShareApiHandler.context = context;
    }

    ///注册API
    public static void registerApp(Map<String, Object> args, MethodChannel.Result result) {
        assert (args != null && result != null);

        if (context == null) {
            result.error("context not set", "please set context first", (Object) null);
            return;
        }

        if (iddShareApi != null) {
            result.success(true);
            return;
        }

        String appId = (String) args.get("appId");
        if (appId == null || appId.isEmpty()) {
            result.error("invalid app id", "are you sure your app id is correct ?", appId);
            return;
        }
        try {
            iddShareApi = DDShareApiFactory.createDDShareApi(context, appId, true);
            APP_ID = appId;
            result.success(true);
        } catch (Exception e) {
            Log.d("FlutterDDShareLog", "IDDShareApi构建失败");
            Log.d("FlutterDDShareLog", "e=============>" + e.toString());
            e.printStackTrace();
            result.error("IDDSHARE_API_REGISTER", "api register fail", null);
        }
    }

    ///是否安装
    public static void checkDDInstallation(MethodChannel.Result result) {
        if (iddShareApi == null) {
            result.error("Unassigned IDDShareApi", "please registerApp first", (Object) null);
            return;
        } else {
            boolean isInstalled = false;
            try {
                isInstalled = iddShareApi.isDDAppInstalled();
                Log.d("FlutterDDShareLog", "DING DING IS INSTALLED:" + isInstalled);
            } catch (Exception e) {
                Log.d("FlutterDDShareLog", "e=============>" + e.toString());
                e.printStackTrace();
            }
            result.success(isInstalled);
        }
    }

    ///授权登录
    public static void sendDDAppAuth(Map<String, Object> args, MethodChannel.Result result) {
        System.out.println(args);

        if (iddShareApi == null) {
            result.error("Unassigned IDDShareApi", "please registerApp first", (Object) null);
            return;
        } else {
            boolean authResult = false;
            try {
                SendAuth.Req req = new SendAuth.Req();
                req.scope = SendAuth.Req.SNS_LOGIN;
                req.state = (String) args.get("state");
                authResult = iddShareApi.sendReq(req);
                Log.d("FlutterDDShareLog", "授权登录请求");
            } catch (Exception e) {
                Log.d("FlutterDDShareLog", "e=============>" + e.toString());
                e.printStackTrace();
            }
            result.success(authResult);
        }
    }

    public static void handleIntent(Intent var1, IDDAPIEventHandler var2) {
        try {
            iddShareApi.handleIntent(var1, var2);
        } catch (Exception e) {
            e.printStackTrace();
            Log.d("FlutterDDShareLog", "e===========>" + e.toString());
        }
    }

    public IDDShareApiHandler() {
        IDDShareApiHandler var0 = new IDDShareApiHandler();
        INSTANCE = var0;
    }
}

