# tensorflow_lite
Aprendizaje automático integrado en el dispositivo.

```
flutter pub add tflite_flutter
```
¿Cómo configurar TensorFlow Lite en Android?
La configuración en Android requiere modificar algunos parámetros dentro del archivo gradle de tu aplicación:

Abre la carpeta app, ve al archivo build.gradle.
Ajusta la versión del compilador y el SDK mínimo y objetivo. Por ejemplo:

```
compileSdkVersion 33

 defaultConfig {
    minSdkVersion 19
    targetSdkVersion 33
    versionCode 1
    versionName "1.0"
}
```
Añade las dependencias necesarias para TensorFlow Lite:

```
dependencies {
    implementation 'org.tensorflow:tensorflow-lite:2.9.0'
    implementation 'org.tensorflow:tensorflow-lite-support:0.4.3'
}
```
¿Cómo configurar TensorFlow Lite en iOS?
Para hacer la configuración en iOS, simplemente debes ejecutar el comando de pods dentro del directorio de iOS en tu proyecto Flutter:

```
cd ios
pod install
```

Esto configurará automáticamente TensorFlow Lite en tu proyecto para dispositivos iOS.

