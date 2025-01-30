import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_overflow/src/db/database.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void onCreate() async {
    final title = _titleController.text;
    final content = _contentController.text;

    // Riverpod stuff to refresh the future being user to get all todo
    // You don't want to call this if you are using streams
    // After creating an entry this is used to refresh it using riverpod
    await ref.read(dbProvider).createEntry(title, content);
    ref.invalidate(dbProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod stuff to get db provider
    final db = ref.watch(dbProvider);

    // Get results using the allTodos query defined in todo_queries.drift file
    // Returns a Future so use FutureBuilder and does not refresh when todos are added to the table
    final result = db.allTodos();
    // Listen to stream provided in the TodosDao class
    // Returns a stream so use StreamBuilder and refreshes when todos are added to the table automatically
    // final stream = db.todosDao.watchTodos();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: const Text("Title")),
              controller: _titleController,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(label: const Text("Content")),
              controller: _contentController,
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(onPressed: onCreate, child: const Text("Create")),
            const SizedBox(
              height: 30,
            ),
            // If you wanna use streams using the daos
            // StreamBuilder(
            //   stream: stream,
            //   builder: (context, snapshot) {
            //     final state = snapshot.connectionState;

            //     if (state == ConnectionState.waiting) {
            //       return Center(
            //         child: SizedBox(
            //           height: 10,
            //           width: 10,
            //           child: CircularProgressIndicator(),
            //         ),
            //       );
            //     }

            //     if (snapshot.hasError) {
            //       print("---------------");
            //       print("Error: ${snapshot.error}");
            //       print("---------------");

            //       return const Center(
            //         child: Text("Error"),
            //       );
            //     }

            //     final data = snapshot.data!;

            //     if (data.isEmpty) {
            //       return const Center(
            //         child: Text("No data"),
            //       );
            //     }

            //     return Column(
            //       children: data
            //           .map((todo) => ListTile(
            //                 title: Text(todo.title),
            //                 subtitle: Text(todo.content),
            //               ))
            //           .toList(),
            //     );
            //   },
            // ),
            FutureBuilder(
              future: result.get(),
              builder: (context, snapshot) {
                final state = snapshot.connectionState;

                if (state == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  print("---------------");
                  print("Error: ${snapshot.error}");
                  print("---------------");

                  return const Center(
                    child: Text("Error"),
                  );
                }

                final data = snapshot.data!;

                if (data.isEmpty) {
                  return const Center(
                    child: Text("No data"),
                  );
                }

                return Column(
                  children: data
                      .map((todo) => ListTile(
                            title: Text(todo.title),
                            subtitle: Text(todo.content),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
