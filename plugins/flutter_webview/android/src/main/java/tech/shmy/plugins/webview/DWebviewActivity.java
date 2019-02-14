package tech.shmy.plugins.webview;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;
//
//import com.tencent.smtt.sdk.WebView;
//import com.tencent.smtt.sdk.WebViewClient;
//import com.tencent.smtt.sdk.WebChromeClient;

import java.util.HashMap;
import wendu.dsbridge.DWebView;


public class DWebviewActivity extends AppCompatActivity {
    private DWebView dWebView;
    private ProgressBar progressBar;
    private Toolbar toolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dwebview);

        Intent intent = getIntent();
        String url = intent.getStringExtra("url");
        // 获取主题颜色
        Bundle primaryColorBundle = intent.getExtras();
        SerializableHashMap primarySerializableHashMap = (SerializableHashMap) primaryColorBundle.get("primaryColor");
        HashMap<String, Integer> primaryColorMap = primarySerializableHashMap.getMap();
        // 取到主题颜色了
        int primaryColor = Color.argb(
                primaryColorMap.get("alpha"),
                primaryColorMap.get("red"),
                primaryColorMap.get("green"),
                primaryColorMap.get("blue"));

        // 获取title颜色
        Bundle titleColorBundle = intent.getExtras();
        SerializableHashMap titleSerializableHashMap = (SerializableHashMap) titleColorBundle.get("titleColor");
        HashMap<String, Integer> titleColorMap = titleSerializableHashMap.getMap();

        // 取到title颜色了
        int titleColor = Color.argb(
                titleColorMap.get("alpha"),
                titleColorMap.get("red"),
                titleColorMap.get("green"),
                titleColorMap.get("blue"));

        // 状态栏透明
        if (Build.VERSION.SDK_INT >= 21) {
//            View decorView = getWindow().getDecorView();
//            int option = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
//                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
//            decorView.setSystemUiVisibility(option);
            getWindow().setStatusBarColor(primaryColor);
        }

        progressBar = (ProgressBar)findViewById(R.id.progressbar);//进度条

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setBackgroundColor(primaryColor);
        toolbar.setTitle("正在加载...");
        toolbar.setTitleTextColor(titleColor);

        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true); // 设置返回按钮
        getSupportActionBar().setHomeButtonEnabled(true); // 设置事件

        dWebView = (DWebView) findViewById(R.id.webview);
        // set debug mode
        DWebView.setWebContentsDebuggingEnabled(false);
        dWebView.addJavascriptObject(new JsApi(), "dd");
//        dWebView.addJavascriptObject(new JsEchoApi(),"echo");

        dWebView.setWebChromeClient(webChromeClient);
        dWebView.setWebViewClient(webViewClient);
        dWebView.loadUrl(url);

    }

    //WebViewClient主要帮助WebView处理各种通知、请求事件
    private WebViewClient webViewClient = new WebViewClient(){
        @Override
        public void onPageFinished(WebView view, String url) {//页面加载完成
            progressBar.setVisibility(View.GONE);
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {//页面开始加载
            progressBar.setVisibility(View.VISIBLE);
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            // 支持tel://协议
            if (url.startsWith("tel:")) {
                Intent intent = new Intent(Intent.ACTION_VIEW,
                        Uri.parse(url));
                startActivity(intent);
                return true;
            }

            return super.shouldOverrideUrlLoading(view, url);
        }

    };


    //WebChromeClient主要辅助WebView处理Javascript的对话框、网站图标、网站title、加载进度等
    private WebChromeClient webChromeClient = new WebChromeClient(){
        //DSBridge已经实现了 Javascript的弹出框函数(alert/confirm/prompt)


        //获取网页标题
        @Override
        public void onReceivedTitle(WebView view, String title) {
            super.onReceivedTitle(view, title);
//            System.out.println("网页标题:"+title);
            toolbar.setTitle(title);
        }

        //加载进度回调
        @Override
        public void onProgressChanged(WebView view, int newProgress) {
            progressBar.setProgress(newProgress);
        }
    };


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (dWebView.canGoBack() && keyCode == KeyEvent.KEYCODE_BACK){//点击返回按钮的时候判断有没有上一页
            dWebView.goBack(); // goBack()表示返回dWebView的上一页面
            return true;
        }
        return super.onKeyDown(keyCode,event);
    }




    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        menu.add(0,1,0,"刷新")
                .setIcon(R.drawable.baseline_refresh_white_36)
                .setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM);

        return true;
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId())
        {
            case android.R.id.home:
                finish();
                break;
            case 1:
                dWebView.reload();
                break;
            default:
                break;
        }

        return super.onOptionsItemSelected(item);
    }

}
