package tech.shmy.plugins.webview;


import android.content.Intent;
import android.os.Bundle;

import java.util.HashMap;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WebviewPlugin */
public class WebviewPlugin implements MethodCallHandler {
  static MethodChannel channel;
  private FlutterActivity activity;
  public WebviewPlugin(FlutterActivity activity) {
    this.activity = activity;
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
//    final MethodChannel channel = new MethodChannel(registrar.messenger(), "webview");
    channel = new MethodChannel(registrar.messenger(), "webview");
    channel.setMethodCallHandler(new WebviewPlugin((FlutterActivity) registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("load")) {
      String url = call.argument("url").toString();
      HashMap primaryColor = call.argument("primaryColor");
      HashMap titleColor = call.argument("titleColor");

      // 传递主题颜色HashMap
      SerializableHashMap primaryColorMap = new SerializableHashMap();
      primaryColorMap.setMap(primaryColor);// 将hashmap数据添加到封装的myMap中
      Bundle primaryColorBundle = new Bundle();
      primaryColorBundle.putSerializable("primaryColor", primaryColorMap);

      // 传递title颜色HashMap
      SerializableHashMap titleColorMap = new SerializableHashMap();
      titleColorMap.setMap(titleColor);// 将hashmap数据添加到封装的myMap中
      Bundle titleColorBundle = new Bundle();
      titleColorBundle.putSerializable("titleColor", titleColorMap);


      Intent intent = new Intent(this.activity, DWebviewActivity.class);
      intent.putExtra("url", url); // 地址
      intent.putExtras(primaryColorBundle); // 主题颜色
      intent.putExtras(titleColorBundle); // title颜色


      this.activity.startActivity(intent);

//      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}
