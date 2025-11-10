import 'package:speech_to_text/speech_recognition_result.dart' as st;
import 'package:speech_to_text/speech_to_text.dart' as st;

class SpeechService {
  st.SpeechToText _speech = st.SpeechToText();
  bool _isListening = false;
  String _recognizedText = "Dia algo ";

  Future<void> startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      _speech.listen(onResult: _onSpeechResult);
    } else {
      _recognizedText = "El reconocimiento de voz no está disponible";
      print("El reconocimiento de voz no está disponible");
    }
  }
  
  void _onSpeechResult(st.SpeechRecognitionResult result) {
    _recognizedText = result.recognizedWords;
    print("Texto reconocido: $_recognizedText");
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }

  String get recognizedText => _recognizedText;
  bool get isListening => _isListening;
}
