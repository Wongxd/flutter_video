package tech.shmy.plugins.txxg;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import com.tencent.android.tpush.XGIOperateCallback;
import com.tencent.android.tpush.XGNotifaction;
import com.tencent.android.tpush.XGPushManager;
import com.tencent.android.tpush.XGPushNotifactionCallback;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Notification.VISIBILITY_PUBLIC;
import static android.content.Context.NOTIFICATION_SERVICE;

/** TxXgPlugin */
public class TxXgPlugin implements EventChannel.StreamHandler, PluginRegistry.NewIntentListener {

  private static String CHANNEL = "tx_xg";

  private EventChannel.EventSink eventSink;

  private Context context;

  private String CHANNEL_ID = "CHANNEL_ID";
  private String CHANNEL_NAME = "CHANNEL_NAME";
  private String CHANNEL_DESCRIPTION = "CHANNEL_DESCRIPTION";
  private int IMPORTANCE_HIGH = NotificationManager.IMPORTANCE_HIGH;
  private String SAMLL_ICON_NAME = "@mipmap/ic_launcher";
  private String SELECT_NOTIFICATION = "SELECT_NOTIFICATION";
  private String DRAWABLE = "drawable";
  private String PAYLOAD = "payload";


  public TxXgPlugin(Registrar registrar) {
    this.context = registrar.context();
    // addNewIntentListener
    registrar.addNewIntentListener(this);
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final EventChannel channel = new EventChannel(registrar.messenger(), CHANNEL);
    TxXgPlugin instance = new TxXgPlugin(registrar);
    channel.setStreamHandler(instance);
  }

  @Override
  public void onListen(Object o, final EventChannel.EventSink eventSink) {
    Log.i("onListen", "onListen");
    this.eventSink = eventSink;
    this.init();

  }

  @Override
  public void onCancel(Object o) {
    Log.i("TxXgPlugin", "TxXgPlugin:onCancel");
  }
  // 初始化
  private void init () {
    setupNotificationChannel();
    XGPushManager.registerPush(context, new XGIOperateCallback() {
      @Override
      public void onSuccess(Object o, int i) {
        Log.i("test", "注册成功:" + o);
        setCallBack();
      }

      @Override
      public void onFail(Object o, int i, String s) {
        Log.i("test", "注册失败:" + o.toString());
        sendMessage("注册信鸽失败", true);
      }
    });

  }

  private void setCallBack () {
    XGPushManager
            .setNotifactionCallback(new XGPushNotifactionCallback() {
              @Override
              public void handleNotify(XGNotifaction xGNotifaction) {
                Log.i("test", "处理信鸽通知：" + xGNotifaction);
                // 获取标签、内容、自定义内容
                int id = xGNotifaction.getNotifyId();
                String title = xGNotifaction.getTitle();
                String content = xGNotifaction.getContent();
                String customContent = xGNotifaction
                        .getCustomContent();
                HashMap m = new HashMap();
                m.put("id", id);
                m.put("title", title);
                m.put("content", content);
                m.put("customContent", customContent);
                  showNotify(id, title, content, m);
              }
            });
  }
  // 发给flutter
  private void sendMessage (Object o, Boolean isError) {
    if (eventSink != null) {
      if (isError) {
        eventSink.error("TxXgPlugin", "error", o);
      } else {
        eventSink.success(o);
      }
    }
  }
  // 显示通知
  private void showNotify (int id, String title, String content, HashMap payload) {

    // 传递 HashMap
    SerializableHashMap payloadMap = new SerializableHashMap();
    payloadMap.setMap(payload);// 将hashmap数据添加到封装的myMap中
    Bundle payloadBundle = new Bundle();
    payloadBundle.putSerializable(PAYLOAD, payloadMap);

    Intent intent = new Intent(context, getMainActivityClass(context));
    intent.setAction(SELECT_NOTIFICATION);
    intent.putExtras(payloadBundle);

    PendingIntent pendingIntent = PendingIntent.getActivity(context, id, intent, PendingIntent.FLAG_UPDATE_CURRENT);

    Notification notification = new NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(getSamllIcon())//设置小图标
            .setContentTitle(title)
            .setContentText(content)
            .setAutoCancel(true)
            .setVisibility(VISIBILITY_PUBLIC)
            .setContentIntent(pendingIntent)
            .build();

    NotificationManagerCompat notificationManagerCompat = getNotificationManager();
    notificationManagerCompat.notify(id, notification);
  }

  private NotificationManagerCompat getNotificationManager() {
    return NotificationManagerCompat.from(context);
  }

  private int getSamllIcon () {
    return context.getResources().getIdentifier(SAMLL_ICON_NAME, DRAWABLE, context.getPackageName());
  }

  // 获取主类
  private Class getMainActivityClass(Context context) {
    String packageName = context.getPackageName();
    Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(packageName);
    String className = launchIntent.getComponent().getClassName();
    try {
      return Class.forName(className);
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
      return null;
    }
  }

  @Override
  public boolean onNewIntent(Intent intent) {

    if (SELECT_NOTIFICATION.equals(intent.getAction())) {
      Bundle extras = intent.getExtras();
      SerializableHashMap payloadHashMap = (SerializableHashMap) extras.get(PAYLOAD);
      sendMessage(payloadHashMap.getMap(), false); // 发送给flutter
      return true;
    }
    return false;
  }

  private void setupNotificationChannel() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
      NotificationChannel notificationChannel = notificationManager.getNotificationChannel(CHANNEL_ID);
      if (notificationChannel == null) {
        notificationChannel = new NotificationChannel(CHANNEL_ID, CHANNEL_NAME, IMPORTANCE_HIGH);
        notificationChannel.setDescription(CHANNEL_DESCRIPTION);
//        notificationChannel.setShowBadge(BooleanUtils.getValue(notificationDetails.channelShowBadge));
        notificationManager.createNotificationChannel(notificationChannel);
      }
    }
  }
}
