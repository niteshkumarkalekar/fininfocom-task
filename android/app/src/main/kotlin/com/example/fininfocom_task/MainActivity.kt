package com.example.fininfocom_task

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Build.VERSION
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val BLUETOOTH_CHANNEL = "com.example.fininfocom_task/bluetooth"
    private val REQUEST_ENABLE_BT = 1
    private val PERMISSION_REQUEST_CODE = 55
    var result: MethodChannel.Result? = null

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BLUETOOTH_CHANNEL).setMethodCallHandler{
            call, result ->
            this.result = result
            if(call.method == "enableBluetooth"){
                // Check to see if the Bluetooth classic feature is available.
                val bluetoothAvailable = packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH)
                val bluetoothManager: BluetoothManager = getSystemService(BluetoothManager::class.java)
                val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
                if(bluetoothAvailable && bluetoothAdapter != null){
                    val isBluetoothIsEnabled = bluetoothAdapter.isEnabled
                    if(!isBluetoothIsEnabled){
                        if (ActivityCompat.checkSelfPermission(
                                this,
                                Manifest.permission.BLUETOOTH_CONNECT
                            ) != PackageManager.PERMISSION_GRANTED
                        ) {
                            if(VERSION.SDK_INT >= Build.VERSION_CODES.S){
                                requestPermissions( arrayOf(Manifest.permission.BLUETOOTH_CONNECT), PERMISSION_REQUEST_CODE)
                            }

                        }else{
                            startActivityForResult(Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), REQUEST_ENABLE_BT)
//                            result.success("Bluetooth Enabled")
                        }


                    }else{
                        result.error("ALREADY_ENABLED", "Bluetooth is already enabled", null);
                    }
                }
            }else{
                result.notImplemented()
            }

        }
    }

    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<String>, grantResults: IntArray) {
        when (requestCode) {
            PERMISSION_REQUEST_CODE -> {
                // If request is cancelled, the result arrays are empty.
                if ((grantResults.isNotEmpty() &&
                            grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    if (ActivityCompat.checkSelfPermission(
                            this,
                            Manifest.permission.BLUETOOTH_CONNECT
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        // TODO: Consider calling
                        //    ActivityCompat#requestPermissions
                        // here to request the missing permissions, and then overriding
                        //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                        //                                          int[] grantResults)
                        // to handle the case where the user grants the permission. See the documentation
                        // for ActivityCompat#requestPermissions for more details.
                        result?.error("PERMISSION_NOT_GRANTED", "Permission not granted. Please Grant permissions from App Settings.", null)
                        return
                    }
                    startActivityForResult(Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), REQUEST_ENABLE_BT)
                } else {
                    // Explain to the user that the feature is unavailable because
                    // the feature requires a permission that the user has denied.
                    // At the same time, respect the user's decision. Don't link to
                    // system settings in an effort to convince the user to change
                    // their decision.
                    result?.error("PERMISSION_NOT_GRANTED", "Permission not granted. Please Grant permissions from App Settings.", null)
                }

            }

            // Add other 'when' lines to check for other
            // permissions this app might request.
            else -> {
                // Ignore all other requests.
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == REQUEST_ENABLE_BT){
            if(resultCode == RESULT_OK){
                result?.success("Bluetooth enabled")
            }else if(resultCode == RESULT_CANCELED){
                result?.error("USER_DENIED","User Denied!", null)

            }
        }
    }
}
