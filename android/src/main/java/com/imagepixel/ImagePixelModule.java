package com.imagepixel;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.bridge.WritableNativeMap;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;

import android.util.Log;

import java.util.HashMap;

@ReactModule(name = ImagePixelModule.NAME)
public class ImagePixelModule extends ReactContextBaseJavaModule {
  public static final String NAME = "ImagePixel";

  private static HashMap<String, Bitmap> images = new HashMap<String, Bitmap>();

  public ImagePixelModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void loadImage(String path, Promise promise) {
    Bitmap bitmap = BitmapFactory.decodeFile(path);
    if (bitmap == null) {
      promise.reject("Failed to load image. Path is incorrect or image is corrupt");
      return;
    }

    images.put(path, bitmap);

    WritableNativeMap result = new WritableNativeMap();
    result.putInt("width", bitmap.getWidth());
    result.putInt("height", bitmap.getHeight());
    result.putString("id", path);

    promise.resolve(result);
  }

  @ReactMethod
  public void unloadImage(String id, Promise promise) {
    Bitmap bitmap = images.get(id);
    if (bitmap == null) {
      promise.reject("Failed to unload image. Unknown ID");
      return;
    }

    images.remove(id);

    bitmap.recycle();

    promise.resolve(null);
  }

  @ReactMethod
  public void getPixel(String id, float x, float y, boolean normalized, Promise promise) {
    Bitmap bitmap = images.get(id);
    if (bitmap == null) {
      promise.reject("Failed to find image. Unknown ID");
      return;
    }

    WritableNativeMap result = new WritableNativeMap();

    try {
      int px, py;
      if(normalized) {
        px = (int)(x * bitmap.getWidth());
        py = (int)(y * bitmap.getHeight());
      } else {
        px = (int)x;
        py = (int)y;
      }

      Color color = bitmap.getColor(px, py);

      int r = (int)(color.red() * 0xFF);
      int g = (int)(color.green() * 0xFF);
      int b = (int)(color.blue() * 0xFF);
      float a = color.alpha();
      
      result.putInt("r", r);
      result.putInt("g", g);
      result.putInt("b", b);
      result.putDouble("a", a);
      result.putString("hex", String.format("%02X%02X%02X%02X", r, g, b, (int)(a * 0xFF)));
    } catch (IllegalArgumentException exception) {
      promise.reject("Unable to read pixel data at ["+x+", "+y+"]");
    }

    promise.resolve(result);
  }
}
