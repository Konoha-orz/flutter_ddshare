package com.nbyjy.ddshare;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import com.android.dingtalk.share.ddsharemodule.IDDAPIEventHandler;
import com.android.dingtalk.share.ddsharemodule.message.BaseReq;
import com.android.dingtalk.share.ddsharemodule.message.BaseResp;
import com.nbyjy.handlers.IDDShareApiHandler;
import com.nbyjy.handlers.IDDShareResponseHandler;

/**
 * Created by Konoha on 2020/9/10.
 */
public class DDShareActivity extends Activity implements IDDAPIEventHandler {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("FlutterDDShare", "onCreate==========>");
//        IDDShareApiHandler.setContext(this.getApplicationContext());
        IDDShareApiHandler.handleIntent(getIntent(), this);
    }

    @Override
    public void onReq(BaseReq baseReq) {
        Log.d("FlutterDDShare", "onReq=============>");
    }

    @Override
    public void onResp(BaseResp baseResp) {
        IDDShareResponseHandler.handleResponse(baseResp);
        finish();
    }
}
