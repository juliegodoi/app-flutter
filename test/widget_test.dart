import 'package:flutter_test/flutter_test.dart';

import 'package:app_todo/main.dart';

void main() {
  testWidgets('App inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    // Verifica se o título está presente
    expect(find.text('📋 Minhas Tarefas'), findsOneWidget);

    // Verifica se o botão de adicionar tarefa está presente
    expect(find.text('Nova Tarefa'), findsOneWidget);

    // Verifica mensagem de lista vazia
    expect(find.text('Nenhuma tarefa ainda!'), findsOneWidget);
  });
}
