import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite_demo/native_communicator.dart';
import 'package:flutter_tflite_demo/speech_service.dart';
import 'package:image_picker/image_picker.dart';
import 'service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tfService = TFService();
  await tfService.loadModel();
  final speechService = SpeechService();

  runApp(MainApp(tfService, speechService: speechService));
}

class MainApp extends StatelessWidget {
  final TFService tfService;
  final SpeechService speechService;
  const MainApp(this.tfService, {super.key, required this.speechService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModelScreen(tfService, speechService: speechService),
    );
  }
}

class ModelScreen extends StatefulWidget {
  final TFService tfService;
  final SpeechService speechService;
  const ModelScreen(this.tfService, {super.key, required this.speechService});

  @override
  _ModelScreenState createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  String _output = "Presiona para ejecutar el modelo";
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery).then(
      (pickedFile) {
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      },
    );
  }

  void _runModel() async {
    if (_image == null) {
      setState(() {
        _output = "Por favor selecciona una imagen primero.";
      });
    }

    try {
      var result = await widget.tfService.runModel(_image);
      setState(() {
        _output = "Resultado del modelo: $result";
      });
    } catch (e) {
      print("Error al ejecutar el modelo: $e");
      setState(() {
        _output = "Error al ejecutar el modelo: $e";
      });
    }
  }

  Future<void> takePicture() async {
    try{
      final String? imagePath = await NativeCommunicator.invokeNativeMethod('takePicture');
      if (imagePath != null) {
        setState(() {
          _image = File(imagePath);
        });
      }
    }on PlatformException catch(e){
      print("Error al tomar la foto: $e");
      _output = "Error al tomar la foto: $e";
    }
  }

  void _toggleListening() async {
    if (widget.speechService.isListening) {
      widget.speechService.stopListening();
    } else {
      await widget.speechService.startListening();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(title: const Text('Modelo TensorFlow Lite')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : const Text('No se ha seleccionado ninguna imagen.'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleccionar Imagen'),
            ),
            Text(_output, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runModel,
              child: const Text('Ejecutar Modelo'),
            ),
            SizedBox(height: 20),
            Text(_output, textAlign: TextAlign.center),
            Text("Texto reconocido: ${widget.speechService.recognizedText}"),
            ElevatedButton(
              onPressed: _toggleListening,
              child: Text(
                widget.speechService.isListening
                    ? 'Detener Escucha'
                    : 'Iniciar Escucha',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String result = await NativeCommunicator.invokeNativeMethod(
                  'getBatteryLevel',
                );
              print(  "Nivel de batería: $result");
              },
              child: Text('Obtener Nivel de bateria'),
            ),
            ElevatedButton(onPressed: takePicture, child: 
            Text('Tomar Foto nativa'))
          ],
        ),
      ),
    );
  }
}
