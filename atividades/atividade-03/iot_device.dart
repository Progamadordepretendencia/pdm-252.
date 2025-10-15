// iot_device.dart
import 'dart:io';
import 'dart:async'; // Para usar o Timer
import 'dart:math'; // Para gerar números aleatórios
import 'dart:convert'; // Para usar utf8

Future<void> main() async {
  // Endereço e porta do servidor ao qual queremos nos conectar.
  // Use '127.0.0.1' ou 'localhost' para testes locais.
  const String host = '127.0.0.1';
  const int port = 4567;

  try {
    // 1. Conecta-se de forma assíncrona ao servidor.
    final socket = await Socket.connect(host, port);
    print(
      'Dispositivo IOT conectado ao servidor em ${socket.remoteAddress.address}:${socket.remotePort}');

    // 2. Inicia um timer que executa uma função a cada 10 segundos.
    Timer.periodic(const Duration(seconds: 10), (timer) {
      sendTemperatureData(socket);
    });

    // Opcional: Escuta por eventos do servidor (como o servidor se desconectando).
    socket.listen(
      (data) {
        // O cliente não espera receber dados, mas é uma boa prática ter o listener.
      },
      onDone: () {
        print('Conexão com o servidor foi fechada.');
        socket.destroy();
        exit(0); // Encerra o programa do cliente
      },
      onError: (error) {
        print('Ocorreu um erro no socket: $error');
        socket.destroy();
        exit(1); // Encerra com código de erro
      },
    );

  } catch (e) {
    print('Não foi possível conectar ao servidor: $e');
    exit(1);
  }
}

// Função que simula a leitura e o envio da temperatura.
void sendTemperatureData(Socket socket) {
  final random = Random();
  // Gera uma temperatura aleatória entre 18.00 e 27.99
  double temperatura = 18.0 + random.nextDouble() * 10;

  // Formata para ter apenas duas casas decimais.
  String temperaturaFormatada = temperatura.toStringAsFixed(2);

  String mensagem = 'Temperatura: $temperaturaFormatada °C';

  print('Enviando: $mensagem');

  // 3. Escreve a mensagem no socket.
  // O método 'write' converte a String para bytes (usando a codificação padrão)
  // e os envia pela rede.
  socket.write(mensagem);
}
