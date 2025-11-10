import android.os.bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
package com.example.flutter_tflite_demo


class MainActivity : FlutterActivity(){
    private val CHANNEL = "com.example.app/native"

    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success("Nivel de bateria: $batteryLevel%")
                    } else {
                        result.error("UNAVAILABLE", "No se pudo obtener el nivel de bateria", null)
                    }
                }
                "takePicture" -> {
                    pendingResult = result
                    takePicture()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(BATTERY_SERVICE) as android.os.BatteryManager
        return batteryManager.getIntProperty(android.os.BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private void takePicture(MethodChannel.Result.result) {
        Intent takePicture = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if(takePicture.ResolveActivity(getPackageManager ()) != null){
            startActivityResult(takePicture, 1)
        }else {
            result.error("UNAVAILABLE", "No se puede abrir la camara ", null )
        }
    }

    @override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data)

        if(requestCode == 1 && resultCode == Activity.RESULT_OK && data != null){
            String imagePath = data.getData().toString()
        }

        new MethodChannel(getFlutterEngine().getDartExecutor(), CHANNEL).invokeMethod("takePicture", imagePath)
    }
}
