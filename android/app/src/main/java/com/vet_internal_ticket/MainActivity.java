package com.vet_internal_ticket;
import static com.vet_internal_ticket.KmSend.getSeconds;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.Manifest;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import com.hztytech.printer.sdk.km_blebluetooth.KmBlebluetooth;
import com.hztytech.printer.sdk.km_blebluetooth.KmBlebluetoothAdapter;
import com.hztytech.printer.sdk.km_bluetooth.Kmbluetooth;
import com.hztytech.printer.sdk.km_bluetooth.KmbluetoothAdapter;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.udaya.bluetooth";
    private static final String STREAM = "com.udaya.bluetooth.stream";
    private static final String FOCUS_STREAM = "com.udaya.keyboard.focus";
    private static final int BLUETOOTH_PERMISSION_REQUEST_CODE = 100;

    private Kmbluetooth kmBluetooth;
    private EventChannel.EventSink eventSink;
    private EventChannel.EventSink focusEventSink;

    private boolean isKeyboardVisible = false;
    private EditText scanner;
    private FrameLayout nativeContainer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        createNativeEditText();
    }

    private boolean isBluetoothReady() {
        return kmBluetooth != null && KmBlebluetooth.getInstance() != null;
    }

    private void checkBluetoothPermissions() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            String[] permissions = {
                    Manifest.permission.BLUETOOTH_CONNECT,
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_ADVERTISE
            };

            boolean allPermissionsGranted = true;
            for (String permission : permissions) {
                if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                    allPermissionsGranted = false;
                    break;
                }
            }

            if (!allPermissionsGranted) {
                ActivityCompat.requestPermissions(this, permissions, BLUETOOTH_PERMISSION_REQUEST_CODE);
            } else {
                initializeBluetooth();
            }
        } else {
            initializeBluetooth();
        }
    }

    private void initializeBluetooth() {
        try {
            kmBluetooth = Kmbluetooth.getInstance();
            if (kmBluetooth != null) {
                kmBluetooth.openBluetoothAdapter(this);
            }
            KmBlebluetooth.getInstance().openBluetoothAdapter(this);
            Log.d("MainActivity", "Bluetooth initialized successfully");
        } catch (Exception e) {
            Log.e("MainActivity", "Failed to initialize Bluetooth: " + e.getMessage());
            kmBluetooth = null;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == BLUETOOTH_PERMISSION_REQUEST_CODE) {
            boolean allGranted = true;
            for (int result : grantResults) {
                if (result != PackageManager.PERMISSION_GRANTED) {
                    allGranted = false;
                    break;
                }
            }

            if (allGranted) {
                initializeBluetooth();
            } else {
                Log.e("MainActivity", "Bluetooth permissions denied");
            }
        }
    }

    private void createNativeEditText() {
        scanner = new EditText(this);
        scanner.setHint("Scan QR Code...");
        scanner.setVisibility(View.GONE);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(1, 1);
        params.setMargins(32, 100, 32, 0);
        scanner.setLayoutParams(params);
        scanner.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        scanner.setOnKeyListener((v, keyCode, event) -> {
            if (keyCode == KeyEvent.KEYCODE_ENTER && event.getAction() == KeyEvent.ACTION_DOWN) {
                String scannedText = scanner.getText().toString().trim();
                if (!scannedText.isEmpty()) {
                    sendScanCompleteToFlutter(scannedText);
                    scanner.setText("");
                }
                return true;
            }
            return false;
        });

        nativeContainer = new FrameLayout(this);
        nativeContainer.addView(scanner);

        addContentView(nativeContainer, new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
        ));
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getKeyCode() == 317 || event.getKeyCode() == 318 || event.getKeyCode() == 319) {
            if (event.getAction() == KeyEvent.ACTION_DOWN) {
                if (!isKeyboardVisible) {
                    isKeyboardVisible = true;
                    scanner.setVisibility(View.VISIBLE);
                    scanner.requestFocus();
                }
            } else if (event.getAction() == KeyEvent.ACTION_UP) {
                if (isKeyboardVisible) {
                    isKeyboardVisible = false;
                    scanner.setVisibility(View.GONE);
                    scanner.clearFocus();
                }
            }
            return true;
        }

        return super.dispatchKeyEvent(event);
    }

    private void sendScanCompleteToFlutter(String text) {
        if (focusEventSink != null) {
            Map<String, Object> eventData = new HashMap<>();
            eventData.put("type", "SCAN_COMPLETE");
            eventData.put("value", text);
            focusEventSink.success(eventData);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        checkBluetoothPermissions();

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("startScan")) {
                        if (isBluetoothReady()) {
                            startScanning();
                            result.success(null);
                        } else {
                            result.error("BLUETOOTH_NOT_READY", "Bluetooth not initialized. Please grant permissions first.", null);
                        }
                    }
                    if (call.method.equals("connectToDevice")) {
                        if (isBluetoothReady()) {
                            String address = call.argument("address");
                            String type = call.argument("type");
                            connectToDevice(address, type, result);
                        } else {
                            result.error("BLUETOOTH_NOT_READY", "Bluetooth not initialized. Please grant permissions first.", null);
                        }
                    }
                    if (call.method.equals("printData")) {
                        if (isBluetoothReady()) {
                            byte[] imageData = call.argument("imageData");
                            int paperHeight = call.argument("height");
                            double percentDouble = call.argument("percent");
                            float percent = (float) percentDouble;
                            if (imageData != null) {
                                Bitmap bitmap = byteArrayToBitmap(imageData, percent);
                                byte[] printData = UseCase.tspl_caseWithPaperSize(bitmap, 80, paperHeight);
                                printData(printData, result);
                            }
                        } else {
                            result.error("BLUETOOTH_NOT_READY", "Bluetooth not initialized. Please grant permissions first.", null);
                        }
                    }
                    if (call.method.equals("isBluetoothReady")) {
                        result.success(isBluetoothReady());
                    }
                });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSink = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        eventSink = null;
                    }
                });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), FOCUS_STREAM)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        focusEventSink = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        focusEventSink = null;
                    }
                });
    }

    public static Bitmap byteArrayToBitmap(byte[] byteArray, float percent) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inPreferredConfig = Bitmap.Config.ARGB_4444;
        Bitmap originalBitmap = BitmapFactory.decodeByteArray(byteArray, 0, byteArray.length, options);
        Bitmap scaledBitmap = scaleBitmap(originalBitmap, percent);
        return addPaddingToCenter(scaledBitmap, 640, 800);
    }

    private static Bitmap addPaddingToCenter(Bitmap bitmap, int paperWidth, int paperHeight) {
        Bitmap paddedBitmap = Bitmap.createBitmap(paperWidth, paperHeight, Bitmap.Config.ARGB_4444);
        int offsetX = (paperWidth - bitmap.getWidth()) / 2;
        int offsetY = (paperHeight - bitmap.getHeight()) / 2;
        android.graphics.Canvas canvas = new android.graphics.Canvas(paddedBitmap);
        canvas.drawColor(android.graphics.Color.WHITE);
        canvas.drawBitmap(bitmap, offsetX, offsetY, null);
        return paddedBitmap;
    }

    public static Bitmap scaleBitmap(Bitmap originalBitmap, float scaleFactor) {
        int width = originalBitmap.getWidth();
        int height = originalBitmap.getHeight();
        int newWidth = Math.round(width * scaleFactor);
        int newHeight = Math.round(height * scaleFactor);
        return Bitmap.createScaledBitmap(originalBitmap, newWidth, newHeight, true);
    }

    private void startScanning() {
        if (kmBluetooth == null) {
            Log.e("MainActivity", "kmBluetooth is null, attempting to reinitialize");
            initializeBluetooth();
            if (kmBluetooth == null) {
                if (eventSink != null) {
                    eventSink.error("BLUETOOTH_ERROR", "Failed to initialize Bluetooth", null);
                }
                return;
            }
        }

        kmBluetooth.openBluetoothAdapter(this);
        try {
            kmBluetooth.startBluetoothDevicesDiscovery(new Kmbluetooth.KmbluetoothListener() {
                @Override
                public void findDevice(BluetoothDevice device) {
                    if (device.getName() != null) {
                        String deviceInfo = device.getName() + " - " + device.getAddress() + " - " + device.getType();
                        Log.d("BluetoothScan", "Discovered: " + deviceInfo);
                        eventSink.success(deviceInfo);
                    }
                }

                @Override
                public void connectSuccess() {
                }

                @Override
                public void connectFailed(String error) {
                }

                @Override
                public void connectSuccess(BluetoothSocket socket) {
                }

                @Override
                public void writeSuccess() {
                }

                @Override
                public void writeFail(String error) {
                }
            });
        } catch (Exception e) {
            if (eventSink != null) {
                eventSink.error("SCAN_ERROR", "Error during scan: " + e.getMessage(), null);
            }
        }
    }

    private void connectToDevice(String address, String type, MethodChannel.Result result) {
        try {
            BluetoothDevice device = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(address);
            if (Objects.equals(type, "1")) {
                kmBluetooth.getConnectDeviceOnly(device, new KmbluetoothAdapter() {
                    @Override
                    public void connectSuccess() {
                        System.out.println("连接成功");
                        KmCreate.getInstance().connectType = 1;
                        KmCreate.getInstance().connectName = device.getName();
                        result.success("CONNECTED");
                    }

                    @Override
                    public void connectFailed(String reasonFailed) {
                        result.success("CONNECT_FAILED");
                    }
                });
            }
            if (Objects.equals(type, "2")) {
                KmBlebluetooth.getInstance().getConnectDevice(device, new KmBlebluetoothAdapter() {
                    @Override
                    public void connectSuccess(BluetoothSocket kmSocket) {
                        super.connectSuccess(kmSocket);
                        System.out.println("BLE连接成功");
                        KmCreate.getInstance().connectType = 2;
                        KmCreate.getInstance().connectName = device.getName();
                    }
                });
            }
        } catch (Exception e) {
            result.error("CONNECTION_ERROR", "Failed to connect: " + e.getMessage(), null);
        }
    }

    public void printData(byte[] printData, MethodChannel.Result result) {
        Date startDate = new Date(System.currentTimeMillis());
        if (KmCreate.getInstance().connectType == 1) {
            Log.e("", "writeData: connection 1");
            Kmbluetooth.getInstance().writeData(printData, new KmbluetoothAdapter() {
                @Override
                public void writeSuccess() {
                    Date endDate = new Date(System.currentTimeMillis());
                    long time = getSeconds(startDate, endDate);
                    result.success("Print Success");
                }

                @Override
                public void writeFail(String reason) {
                    super.writeFail(reason);
                    System.out.println(reason);
                    result.success("Print Fail");
                }
            });
        }
        if (KmCreate.getInstance().connectType == 2) {
            Log.e("", "writeData: connection 2 blue");
            System.out.println("BLE小票---");
            KmBlebluetooth.getInstance().writeData(printData, new KmBlebluetoothAdapter() {
                @Override
                public void writeSuccess() {
                    super.writeSuccess();
                    System.out.println("写入成功");
                    Date endDate = new Date(System.currentTimeMillis());
                    long time = getSeconds(startDate, endDate);
                    result.success("Print Success");
                }

                @Override
                public void writeProgress(int progress) {
                    super.writeProgress(progress);
                    System.out.println("当前进度返回" + progress);
                    result.success("Print Fail");
                }
            });
        }
    }
}