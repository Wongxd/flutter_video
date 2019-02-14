package tech.shmy.clipboard.clipboard;

import android.content.ClipData;
import android.content.Context;
import android.content.ClipboardManager;
import android.util.Log;

import static android.content.Context.CLIPBOARD_SERVICE;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


/** ClipboardPlugin */
public class ClipboardPlugin implements MethodCallHandler {
  ClipboardManager myClipboard;


  public ClipboardPlugin(Context context) {
    this.myClipboard = (ClipboardManager) context.getSystemService(CLIPBOARD_SERVICE);
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "clipboard");
    channel.setMethodCallHandler(new ClipboardPlugin((Context) registrar.context()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("copy")) {
      String content = call.argument("content").toString();
      // 拷贝到剪贴板
      ClipData myClip = ClipData.newPlainText("text", content);//text是内容
      this.myClipboard.setPrimaryClip(myClip);
    } else if (call.method.equals("read")) {

      if(!this.myClipboard.hasPrimaryClip()) {
        result.success(null);
        return;
      }
      try {
        ClipData myClip = this.myClipboard.getPrimaryClip();

        String text = myClip.getItemAt(0).getText().toString();;

        result.success(text);
      }catch (Exception e) {
        e.printStackTrace();
        result.success(null);
      }
    } else {
      result.notImplemented();
    }
  }
}
