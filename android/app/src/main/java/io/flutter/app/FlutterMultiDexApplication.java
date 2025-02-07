package io.flutter.app;

import android.app.Application;
import android.content.Context;
import androidx.annotation.Keep;
import androidx.multidex.MultiDex;

@Keep
public class FlutterMultiDexApplication extends Application {
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}
