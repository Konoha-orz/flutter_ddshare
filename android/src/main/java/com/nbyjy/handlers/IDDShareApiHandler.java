package com.nbyjy.handlers;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.android.dingtalk.share.ddsharemodule.DDShareApiFactory;
import com.android.dingtalk.share.ddsharemodule.IDDAPIEventHandler;
import com.android.dingtalk.share.ddsharemodule.IDDShareApi;
import com.android.dingtalk.share.ddsharemodule.message.DDImageMessage;
import com.android.dingtalk.share.ddsharemodule.message.DDMediaMessage;
import com.android.dingtalk.share.ddsharemodule.message.DDTextMessage;
import com.android.dingtalk.share.ddsharemodule.message.DDWebpageMessage;
import com.android.dingtalk.share.ddsharemodule.message.SendAuth;
import com.android.dingtalk.share.ddsharemodule.message.SendMessageToDD;

import java.io.File;
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

    /**
     * 授权登录
     */
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

    /**
     * 分享文本消息
     */
    public static void sendTextMessage(Map<String, Object> args, MethodChannel.Result result) {

        String text = (String) args.get("text");
        boolean isSendDing = (boolean) args.get("isSendDing");

        //初始化一个DDTextMessage对象
        DDTextMessage textObject = new DDTextMessage();
        textObject.mText = text;

        //用DDTextMessage对象初始化一个DDMediaMessage对象
        DDMediaMessage mediaMessage = new DDMediaMessage();
        mediaMessage.mMediaObject = textObject;

        //构造一个Req
        SendMessageToDD.Req req = new SendMessageToDD.Req();
        req.mMediaMessage = mediaMessage;

        //调用api接口发送消息到钉钉
        if (isSendDing) {
            iddShareApi.sendReqToDing(req);
        } else {
            iddShareApi.sendReq(req);
        }
    }

    /**
     * 分享网页消息
     */
    public static void sendWebPageMessage(Map<String, Object> args, MethodChannel.Result result) {
        String mUrl = (String) args.get("url");
        boolean isSendDing = (boolean) args.get("isSendDing");

        //初始化一个DDWebpageMessage并填充网页链接地址
        DDWebpageMessage webPageObject = new DDWebpageMessage();
        webPageObject.mUrl = mUrl;

        //构造一个DDMediaMessage对象
        DDMediaMessage webMessage = new DDMediaMessage();
        webMessage.mMediaObject = webPageObject;

        webMessage.mTitle = (String) args.get("title");
        webMessage.mContent = (String) args.get("content");
        webMessage.mThumbUrl = (String) args.get("thumbUrl");
        // 网页分享的缩略图也可以使用bitmap形式传输
//         webMessage.setThumbImage(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher));

        //构造一个Req
        SendMessageToDD.Req webReq = new SendMessageToDD.Req();
        webReq.mMediaMessage = webMessage;
//        webReq.transaction = buildTransaction("webpage");

        //调用api接口发送消息到支付宝
        if (isSendDing) {
            iddShareApi.sendReqToDing(webReq);
        } else {

            iddShareApi.sendReq(webReq);
        }
    }

    /**
     * 分享图片消息
     */
    public static void sendImageMessage(Map<String, Object> args, MethodChannel.Result result) {
        boolean isSendDing = (boolean) args.get("isSendDing");
        //初始化一个DDImageMessage
        DDImageMessage imageObject = new DDImageMessage();


        //url图片
        if (args.get("picUrl") != null) {
            String picUrl = (String) args.get("picUrl");
            imageObject.mImageUrl = picUrl;
        } else if (args.get("picPath") != null) {
            //本地图片
            String picPath = (String) args.get("picPath");
            File file = new File(picPath);
            if (!file.exists()) {
                Log.d("FlutterDDShareLog", "图片路径无效: " + picPath);
                result.error("picPath error", "图片路径无效", picPath);
            } else {
                imageObject.mImagePath = picPath;
            }
        } else {
            Log.d("FlutterDDShareLog", "无图片来源");
            result.error("Image error", "请传输图片来源", null);
        }


        //构造一个mMediaObject对象
        DDMediaMessage mediaMessage = new DDMediaMessage();
        mediaMessage.mMediaObject = imageObject;

        //构造一个Req
        SendMessageToDD.Req req = new SendMessageToDD.Req();
        req.mMediaMessage = mediaMessage;
//        req.transaction = buildTransaction("image");

        //调用api接口发送消息到支付宝
        if (isSendDing) {
            iddShareApi.sendReqToDing(req);
        } else {

            iddShareApi.sendReq(req);
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

