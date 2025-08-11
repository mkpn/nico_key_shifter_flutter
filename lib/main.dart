import 'package:flutter/material.dart';
// Riverpod を使用するために必要なインポート
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateProvider: シンプルな状態管理を行うProvider
// int型の値を保持し、外部から読み取り・更新が可能
// 初期値として0を設定
final counterProvider = StateProvider<int>((ref) => 0);

void main() {
  runApp(
    // ProviderScope: アプリ全体でProviderを使用可能にするためのルートWidget
    // すべてのProviderはこのScope内でのみ利用可能
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// ConsumerWidget: Providerを使用するためのWidget基底クラス
// StatefulWidgetの代わりに使用し、WidgetRefを通じてProviderにアクセス可能
class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  // build メソッドに WidgetRef が追加される
  // WidgetRef: Providerとの橋渡しを行うオブジェクト
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(): Providerの値を監視し、値が変更されると自動的にWidgetを再ビルド
    // StateProviderの現在の値を取得
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$counter', // watchで取得した値を表示
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ref.read(): Providerの値を一度だけ読み取り（監視しない）
          // .notifier: StateProviderの状態を変更するためのNotifierを取得
          // .state++: 状態を直接更新（自動的にリスナーに通知される）
          ref.read(counterProvider.notifier).state++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
