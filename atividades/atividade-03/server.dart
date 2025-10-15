// server.dart
import 'dart:io';
import 'dart:convert'; // Para usar utf8

// A função main precisa ser 'async' para podermos usar 'await'.
Future<void> main() async {
  // Define o endereço e a porta que o servidor irá escutar.
  // InternetAddress.anyIPv4 escuta em todos os endereços de rede disponíveis.
  final InternetAddress address = InternetAddress.anyIPv4;
  const int port = 4567; // Porta de comunicação

  try {
    // 1. Cria e "amarra" (bind) o servidor ao endereço e porta especificados.
    // O ServerSocket é uma Stream, ou seja, ele emite eventos de conexão.
    final server = await ServerSocket.bind(address, port);
    print('Servidor iniciado e escutando em ${server.address.host}:${server.port}');

    // 2. Usamos 'await for' para escutar de forma assíncrona por novas conexões de clientes.
    // O loop só continua quando um novo cliente se conecta.
    await for (var socket in server) {
      handleConnection(socket);
    }
  } catch (e) {
    print('Erro ao iniciar o servidor: $e');
  }
}

// Função para lidar com a lógica de uma conexão de cliente individual.
void handleConnection(Socket client) {
  print(
    'Cliente conectado: ${client.remoteAddress.address}:${client.remotePort}');

  // 3. Escuta a stream de dados vinda do cliente.
  client.listen(
    // Quando dados são recebidos
    (List<int> data) {
      // Decodifica os bytes recebidos (padrão UTF-8) para uma String.
      final message = utf8.decode(data);
      // O .trim() remove espaços em branco ou quebras de linha extras.
      print('Recebido do IOT: ${message.trim()}');
    },

    // Em caso de erro na conexão
    onError: (error) {
      print('Ocorreu um erro com o cliente: $error');
      client.close();
    },

    // Quando o cliente se desconecta
    onDone: () {
      print('Cliente desconectado.');
      client.close();
    },
  );
}
