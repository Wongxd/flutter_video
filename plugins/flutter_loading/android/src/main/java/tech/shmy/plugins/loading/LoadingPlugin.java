package tech.shmy.plugins.loading;

import io.flutter.app.FlutterActivity;
import android.graphics.Color;

import cc.cloudist.acplibrary.ACProgressConstant;
import cc.cloudist.acplibrary.ACProgressFlower;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** LoadingPlugin */
public class LoadingPlugin implements MethodCallHandler {

  private ACProgressFlower dialog;
  private FlutterActivity activity;

  public LoadingPlugin(FlutterActivity activity) {
    this.activity = activity;
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "loading");
    channel.setMethodCallHandler(new LoadingPlugin((FlutterActivity) registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
//    String color = call.argument("color").toString();
    if (call.method.equals("show")) {
      String text = call.argument("text").toString();

      this.dialog = new ACProgressFlower.Builder(this.activity)
              .direction(ACProgressConstant.DIRECT_CLOCKWISE)
              .themeColor(Color.WHITE)
              .text(text)
              .fadeColor(Color.DKGRAY).build();
      this.dialog.setCancelable(false);
      this.dialog.setCanceledOnTouchOutside(false);
      this.dialog.show();
    } else if (call.method.equals("hide")) {
      this.dialog.hide();
      this.dialog.dismiss();
      this.dialog = null;
    } else {
      result.notImplemented();
    }
  }
}
