package tech.shmy.plugins.androidintent;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AndroidIntentPlugin */
public class AndroidIntentPlugin implements MethodCallHandler {
  private Context context;
  AndroidIntentPlugin(Context context) {
    this.context = context;
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "android_intent");
    channel.setMethodCallHandler(new AndroidIntentPlugin((Context) registrar.context()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String packageName = call.argument("packageName").toString();
    if (call.method.equals("launchApp")) {

      launchApp(context, packageName);
    } else if (call.method.equals("isAppInstalled")) {

      result.success(isAppInstalled(context, packageName));
    } else {
      result.notImplemented();
    }
  }

  /**
   * 按包名启动App
   * @param context
   */
  private void launchApp(Context context, String packageName) {
    // 判断是否安装过App，否则去市场下载
    if (isAppInstalled(context, packageName)) {
      context.startActivity(context.getPackageManager().getLaunchIntentForPackage(packageName));
    } else {
      goToMarket(context, packageName);
    }
  }

  /**
   * 检测某个应用是否安装
   *
   * @param context
   * @param packageName
   * @return
   */
  private boolean isAppInstalled(Context context, String packageName) {
    try {
      context.getPackageManager().getPackageInfo(packageName, 0);
      return true;
    } catch (PackageManager.NameNotFoundException e) {
      return false;
    }
  }

  /**
   * 去市场下载页面
   */
  private void goToMarket(Context context, String packageName) {
    Uri uri = Uri.parse("market://details?id=" + packageName);
    Intent goToMarket = new Intent(Intent.ACTION_VIEW, uri);
    try {
      context.startActivity(goToMarket);
    } catch (ActivityNotFoundException e) {
    }
  }

}
