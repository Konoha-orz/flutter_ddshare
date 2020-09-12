package com.nbyjy.handlers;


import android.util.Log;

import androidx.annotation.Nullable;

import com.android.dingtalk.share.ddsharemodule.ShareConstant;
import com.android.dingtalk.share.ddsharemodule.message.BaseResp;
import com.android.dingtalk.share.ddsharemodule.message.SendAuth;


import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;


public class IDDShareResponseHandler {

    @Nullable
    private static MethodChannel channel;

    private static final String _mErrCode = "mErrCode";
    private static final String _mErrStr = "mErrStr";
    private static final String _mTransaction = "mTransaction";

    public static IDDShareResponseHandler INSTANCE;

    public static void setChannel(@Nullable MethodChannel channel) {
        IDDShareResponseHandler.channel = channel;
    }

    public static void handleResponse(BaseResp baseResp) {
        int errCode = baseResp.mErrCode;
        Log.d("FlutterDDShare", "errorCode==========>" + errCode);
        String errMsg = baseResp.mErrStr;
        Log.d("FlutterDDShare", "errMsg==========>" + errMsg);
        if (baseResp.getType() == ShareConstant.COMMAND_SENDAUTH_V2 && (baseResp instanceof SendAuth.Resp)) {
            handleAuthResponse(baseResp);
        } else {
            handleShareResponse(baseResp);
        }
    }

    //分享回调处理
    private static void handleShareResponse(BaseResp baseResp) {
        if (channel != null) {
            Map<String, Object> result = new HashMap<>();
            result.put(_mErrCode, baseResp.mErrCode);
            result.put(_mErrStr, baseResp.mErrStr);
            result.put(_mTransaction, baseResp.mTransaction);
            result.put("type", baseResp.getType());
            channel.invokeMethod("onShareResponse", result);
        }
    }

    //授权登录回调处理
    private static void handleAuthResponse(BaseResp baseResp) {
        Log.d("FlutterDDShare", "授权信息回调======>");
        if (channel != null) {
            SendAuth.Resp authResp = (SendAuth.Resp) baseResp;
            Map<String, Object> result = new HashMap<>();
            result.put(_mErrCode, authResp.mErrCode);
            result.put(_mErrStr, authResp.mErrStr);
            result.put(_mTransaction, authResp.mTransaction);
            result.put("code", authResp.code);
            result.put("state", authResp.state);
            channel.invokeMethod("onAuthResponse", result);
        }
    }

    public IDDShareResponseHandler() {
        IDDShareResponseHandler var0 = new IDDShareResponseHandler();
        INSTANCE = var0;
    }
}

