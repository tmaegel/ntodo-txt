import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntodotxt/common_widgets/chip.dart';
import 'package:ntodotxt/common_widgets/priority_dialog.dart';
import 'package:ntodotxt/domain/todo/todo_model.dart';
import 'package:ntodotxt/presentation/todo/pages/todo_create_edit_page.dart';

class TodoCreateEditPageMaterialApp extends StatelessWidget {
  final Todo todo;

  const TodoCreateEditPageMaterialApp({
    required this.todo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoCreateEditPage(todo: todo),
    );
  }
}

Future safeTapByFinder(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
}

void main() {
  group('Todo edit', () {
    group('priority', () {
      testWidgets('set', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(priority: Priority.A, description: 'Code something'),
        ));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoPriorityItem),
            matching: find.text('A'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('unset', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(priority: null, description: 'Code something'),
        ));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoPriorityItem),
            matching: find.text('none'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('update', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(priority: null, description: 'Code something'),
        ));
        await tester.pump();

        await tester.tap(find.byType(TodoPriorityItem));
        await tester.pump();

        await tester.tap(
          find.descendant(
            of: find.byType(PriorityDialog),
            matching: find.text('A'),
          ),
        );
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoPriorityItem),
            matching: find.text('A'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });

    group('completion & completion date', () {
      testWidgets('set', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        final DateTime now = DateTime.now();
        final String today =
            '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(completion: true, description: 'Code something'),
        ));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoCompletionDateItem),
            matching: find.byWidgetPredicate(
              (Widget widget) => widget is Text && widget.data == today,
            ),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('unset', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(completion: false, description: 'Code something'),
        ));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoCompletionDateItem),
            matching: find.byWidgetPredicate(
              (Widget widget) => widget is Text && widget.data == '-',
            ),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('add', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        final DateTime now = DateTime.now();
        final String today =
            '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(completion: false, description: 'Code something'),
        ));
        await tester.pump();

        await tester.tap(find.byType(TodoCompletionDateItem));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoCompletionDateItem),
            matching: find.byWidgetPredicate(
              (Widget widget) => widget is Text && widget.data == today,
            ),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('remove', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(completion: true, description: 'Code something'),
        ));
        await tester.pump();

        await tester.tap(find.byType(TodoCompletionDateItem));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoCompletionDateItem),
            matching: find.byWidgetPredicate(
              (Widget widget) => widget is Text && widget.data == '-',
            ),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });

    group('creation date', () {
      testWidgets('set', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
              creationDate: DateTime(2023, 12, 5),
              description: 'Code something'),
        ));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoCreationDateItem),
            matching: find.byWidgetPredicate(
              (Widget widget) => widget is Text && widget.data == '2023-12-05',
            ),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });

    group('due date', () {
      testWidgets('set', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
            keyValues: const {'due': '2023-12-31'},
          ),
        ));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoDueDateItem),
            matching: find.byWidgetPredicate(
              (Widget widget) => widget is Text && widget.data == '2023-12-31',
            ),
          ),
          findsOneWidget,
        );

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoKeyValueTagsItem),
            matching: find.text('due:2023-12-31'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('unset', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(description: 'Code something'),
        ));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoDueDateItem),
            matching: find.text('-'),
          ),
          findsOneWidget,
        );

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoKeyValueTagsItem),
            matching:
                find.byWidgetPredicate((Widget widget) => widget is BasicChip),
          ),
          findsNothing,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('add', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        final DateTime now = DateTime.now();
        final String today =
            '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
          ),
        ));
        await tester.pump();

        // Unset due date button.
        await tester.tap(find.byType(TodoDueDateItem));
        await tester.pump();

        await tester.tap(
          find.descendant(
            of: find.byType(DatePickerDialog),
            matching: find.text('OK'),
          ),
        );
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoDueDateItem),
            matching: find.text(today),
          ),
          findsOneWidget,
        );

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoKeyValueTagsItem),
            matching: find.text('due:$today'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('remove', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
            keyValues: const {'due': '2023-12-31'},
          ),
        ));
        await tester.pump();

        // Unset due date button.
        await tester.tap(find.byType(TodoDueDateItem));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoDueDateItem),
            matching: find.text('-'),
          ),
          findsOneWidget,
        );

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoKeyValueTagsItem),
            matching:
                find.byWidgetPredicate((Widget widget) => widget is ChoiceChip),
          ),
          findsNothing,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });

    group('project', () {
      testWidgets('set', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
            projects: const {'project1'},
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoProjectTagsItem),
            matching: find.text('project1'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('unset', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoProjectTagsItem),
            matching:
                find.byWidgetPredicate((Widget widget) => widget is BasicChip),
          ),
          findsNothing,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('add', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(description: 'Code something'),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        await tester.tap(find.byType(TodoProjectTagsItem));
        await tester.pump();

        Finder addContextTagDialogFinder =
            find.byKey(const Key('addProjectTagDialog'));
        expect(addContextTagDialogFinder, findsOneWidget);

        // Add new tag.
        await tester.enterText(
          find.descendant(
            of: addContextTagDialogFinder,
            matching: find.byType(TextFormField),
          ),
          'project1',
        );
        await safeTapByFinder(tester, find.text('Add'));
        await tester.pump();
        await safeTapByFinder(tester, find.text('Apply'));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoProjectTagsItem),
            matching: find.text('project1'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('remove', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
            projects: const {'project1'},
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        await tester.tap(find.byType(TodoProjectTagsItem));
        await tester.pump();

        Finder addContextTagDialogFinder =
            find.byKey(const Key('addProjectTagDialog'));
        expect(addContextTagDialogFinder, findsOneWidget);

        await safeTapByFinder(
          tester,
          find.descendant(
            of: addContextTagDialogFinder,
            matching: find.text('project1'),
          ),
        );
        await tester.pump();
        await safeTapByFinder(tester, find.text('Apply'));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoContextTagsItem),
            matching: find.text('project1'),
          ),
          findsNothing,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });

    group('context', () {
      testWidgets('set', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
            contexts: const {'context1'},
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoContextTagsItem),
            matching: find.text('context1'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('unset', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoContextTagsItem),
            matching:
                find.byWidgetPredicate((Widget widget) => widget is BasicChip),
          ),
          findsNothing,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('add', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(description: 'Code something'),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        await tester.tap(find.byType(TodoContextTagsItem));
        await tester.pump();

        Finder addContextTagDialogFinder =
            find.byKey(const Key('addContextTagDialog'));
        expect(addContextTagDialogFinder, findsOneWidget);

        // Add new tag.
        await tester.enterText(
          find.descendant(
            of: addContextTagDialogFinder,
            matching: find.byType(TextFormField),
          ),
          'context1',
        );
        await safeTapByFinder(tester, find.text('Add'));
        await tester.pump();
        await safeTapByFinder(tester, find.text('Apply'));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoContextTagsItem),
            matching: find.text('context1'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('remove', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
            contexts: const {'context1'},
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        await tester.tap(find.byType(TodoContextTagsItem));
        await tester.pump();

        Finder addContextTagDialogFinder =
            find.byKey(const Key('addContextTagDialog'));
        expect(addContextTagDialogFinder, findsOneWidget);

        await safeTapByFinder(
          tester,
          find.descendant(
            of: addContextTagDialogFinder,
            matching: find.text('context1'),
          ),
        );
        await tester.pump();
        await safeTapByFinder(tester, find.text('Apply'));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoContextTagsItem),
            matching: find.text('Context1'),
          ),
          findsNothing,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });

    group('key-value', () {
      testWidgets('set', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
            keyValues: const {'foo': 'bar'},
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoKeyValueTagsItem),
            matching: find.text('foo:bar'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('unset', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoKeyValueTagsItem),
            matching:
                find.byWidgetPredicate((Widget widget) => widget is BasicChip),
          ),
          findsNothing,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('add', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(description: 'Code something'),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        await tester.tap(find.byType(TodoKeyValueTagsItem));
        await tester.pump();

        Finder addKeyValueTagDialogFinder =
            find.byKey(const Key('addKeyValueTagDialog'));
        expect(addKeyValueTagDialogFinder, findsOneWidget);

        // Add new tag.
        await tester.enterText(
          find.descendant(
            of: addKeyValueTagDialogFinder,
            matching: find.byType(TextFormField),
          ),
          'foo:bar',
        );
        await safeTapByFinder(tester, find.text('Add'));
        await tester.pump();
        await safeTapByFinder(tester, find.text('Apply'));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoKeyValueTagsItem),
            matching: find.text('foo:bar'),
          ),
          findsOneWidget,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
      testWidgets('remove', (tester) async {
        // Increase size to ensure all elements in list are visible.
        tester.view.physicalSize = const Size(400, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(TodoCreateEditPageMaterialApp(
          todo: Todo(
            description: 'Code something',
            keyValues: const {'foo': 'bar'},
          ),
        ));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        await tester.tap(find.byType(TodoKeyValueTagsItem));
        await tester.pump();

        Finder addKeyValueTagDialogFinder =
            find.byKey(const Key('addKeyValueTagDialog'));
        expect(addKeyValueTagDialogFinder, findsOneWidget);

        await safeTapByFinder(
          tester,
          find.descendant(
            of: addKeyValueTagDialogFinder,
            matching: find.text('foo:bar'),
          ),
        );
        await tester.pump();
        await safeTapByFinder(tester, find.text('Apply'));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TodoKeyValueTagsItem),
            matching: find.text('foo:bar'),
          ),
          findsNothing,
        );

        // resets the screen to its original size after the test end
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });
  });
}
