import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ntodotxt/common_widgets/app_bar.dart';
import 'package:ntodotxt/common_widgets/chip.dart';
import 'package:ntodotxt/common_widgets/confirm_dialog.dart';
import 'package:ntodotxt/common_widgets/scroll_to_top.dart';
import 'package:ntodotxt/constants/app.dart';
import 'package:ntodotxt/domain/filter/filter_model.dart' show Filter;
import 'package:ntodotxt/domain/filter/filter_repository.dart';
import 'package:ntodotxt/domain/settings/setting_repository.dart';
import 'package:ntodotxt/domain/todo/todo_model.dart' show Priority, Todo;
import 'package:ntodotxt/misc.dart' show PopScopeDrawer, SnackBarHandler;
import 'package:ntodotxt/presentation/drawer/states/drawer_cubit.dart';
import 'package:ntodotxt/presentation/filter/states/filter_cubit.dart';
import 'package:ntodotxt/presentation/filter/states/filter_state.dart';
import 'package:ntodotxt/presentation/todo/states/todo_list_bloc.dart';
import 'package:ntodotxt/presentation/todo/states/todo_list_event.dart';
import 'package:ntodotxt/presentation/todo/states/todo_list_state.dart';

class TodoListPage extends StatelessWidget {
  final Filter? filter;

  const TodoListPage({
    this.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      filter == null ? _build(context) : _buildWithFilter(context);

  Widget _build(BuildContext context) {
    final bool isNarrowLayout =
        MediaQuery.of(context).size.width < maxScreenWidthCompact;
    return BlocListener<TodoListBloc, TodoListState>(
      listener: (BuildContext context, TodoListState state) {
        if (state is TodoListError) {
          SnackBarHandler.error(context, state.message);
        }
      },
      child: isNarrowLayout
          ? const TodoListViewNarrow()
          : const TodoListViewWide(),
    );
  }

  Widget _buildWithFilter(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FilterCubit(
        settingRepository: context.read<SettingRepository>(),
        filterRepository: context.read<FilterRepository>(),
        filter: filter,
      )..load(),
      child: Builder(
        builder: (BuildContext context) => _build(context),
      ),
    );
  }
}

///
/// Narrow layout
///

class TodoListViewNarrow extends ScollToTopView {
  const TodoListViewNarrow({super.key});

  @override
  State<TodoListViewNarrow> createState() => _TodoListViewNarrowState();
}

class _TodoListViewNarrowState extends ScollToTopViewState<TodoListViewNarrow> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      buildWhen: (TodoListState previousState, TodoListState todoListState) =>
          (previousState is! TodoListLoading &&
              todoListState is TodoListLoading) ||
          (previousState is TodoListLoading &&
              todoListState is! TodoListLoading),
      builder: (BuildContext context, TodoListState todoListState) {
        return BlocBuilder<FilterCubit, FilterState>(
          buildWhen: (FilterState previousState, FilterState filterState) =>
              previousState.filter.name != filterState.filter.name,
          builder: (BuildContext context, FilterState filterState) {
            return PopScopeDrawer(
              child: Scaffold(
                appBar: MainAppBar(
                  title: filterState.filter.name.isEmpty
                      ? 'Todos'
                      : 'Filter: ${filterState.filter.name}',
                  toolbar: Row(
                    children: [
                      IconButton(
                        tooltip: 'Search',
                        icon: const Icon(Icons.search),
                        onPressed: () => context.pushNamed('todo-search',
                            extra: filterState.filter),
                      ),
                      const TodoListSaveFilter(),
                      const TodoListDeleteFilter(),
                    ],
                  ),
                  bottom: const AppBarFilterList(),
                ),
                drawer: Container(),
                floatingActionButton: scrolledDown
                    ? FloatingActionButton.small(
                        tooltip: 'Go to top',
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        child: const Icon(Icons.keyboard_arrow_up),
                        onPressed: () => scrollToTop(),
                      )
                    : FloatingActionButton(
                        tooltip: 'Add todo',
                        child: const Icon(Icons.add),
                        onPressed: () => context.pushNamed('todo-create'),
                      ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<TodoListBloc>()
                        .add(const TodoListSynchronizationRequested());
                  },
                  child: LoadingIndicatorWrapper(
                    loading: todoListState is TodoListLoading,
                    child: TodoList(scrollController: scrollController),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

///
/// Wide layout
///

class TodoListViewWide extends ScollToTopView {
  const TodoListViewWide({super.key});

  @override
  State<TodoListViewWide> createState() => _TodoListViewWideState();
}

class _TodoListViewWideState extends ScollToTopViewState<TodoListViewWide> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      buildWhen: (TodoListState previousState, TodoListState todoListState) =>
          (previousState is! TodoListLoading &&
              todoListState is TodoListLoading) ||
          (previousState is TodoListLoading &&
              todoListState is! TodoListLoading),
      builder: (BuildContext context, TodoListState todoListState) {
        return BlocBuilder<FilterCubit, FilterState>(
          buildWhen: (FilterState previousState, FilterState filterState) =>
              previousState.filter.name != filterState.filter.name,
          builder: (BuildContext context, FilterState filterState) {
            return PopScopeDrawer(
              child: Scaffold(
                appBar: MainAppBar(
                  title: filterState.filter.name.isEmpty
                      ? 'Todos'
                      : 'Filter: ${filterState.filter.name}',
                  toolbar: Row(
                    children: [
                      IconButton(
                        tooltip: 'Search',
                        icon: const Icon(Icons.search),
                        onPressed: () => context.pushNamed('todo-search',
                            extra: filterState.filter),
                      ),
                      const TodoListSaveFilter(),
                      const TodoListDeleteFilter(),
                    ],
                  ),
                  bottom: const AppBarFilterList(),
                ),
                floatingActionButton: scrolledDown
                    ? FloatingActionButton.small(
                        tooltip: 'Go to top',
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        child: const Icon(Icons.keyboard_arrow_up),
                        onPressed: () => scrollToTop(),
                      )
                    : FloatingActionButton(
                        tooltip: 'Add todo',
                        child: const Icon(Icons.add),
                        onPressed: () => context.pushNamed('todo-create'),
                      ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<TodoListBloc>()
                        .add(const TodoListSynchronizationRequested());
                  },
                  child: LoadingIndicatorWrapper(
                    loading: todoListState is TodoListLoading,
                    child: TodoList(scrollController: scrollController),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

///
/// Components
///

class LoadingIndicatorWrapper extends StatelessWidget {
  final Widget child;
  final bool loading;

  const LoadingIndicatorWrapper({
    required this.child,
    this.loading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Stack(
        children: <Widget>[
          child,
          // Custom progress indicator.
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return child;
    }
  }
}

class TodoList extends StatelessWidget {
  final ScrollController scrollController;

  const TodoList({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (BuildContext context, TodoListState todoListState) {
        return BlocBuilder<FilterCubit, FilterState>(
          builder: (BuildContext context, FilterState filterState) {
            final Map<String, Iterable<Todo>?> sectionList =
                todoListState.groupedTodoList(
              filterState.filter,
            );
            return ListView.builder(
              key: const PageStorageKey('TodoList'),
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: sectionList.length,
              itemBuilder: (BuildContext context, int index) {
                String section = sectionList.keys.elementAt(index);
                Iterable<Todo> todoList = sectionList[section]!;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        key: PageStorageKey<String>(section),
                        title: Text(
                          section,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                    for (var todo in todoList)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TodoListTile(todo: todo),
                      ),
                    if (index < sectionList.length - 1) const Divider(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class TodoListTile extends StatelessWidget {
  final Todo todo;

  TodoListTile({
    required this.todo,
    Key? key,
  }) : super(key: PageStorageKey<String>(todo.id));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      title: Text(
        todo.fmtDescription,
        style: TextStyle(
          decoration: todo.completion ? TextDecoration.lineThrough : null,
          decorationThickness: 5.0,
        ),
      ),
      subtitle: _buildSubtitle(),
      onTap: () => context.pushNamed('todo-edit', extra: todo),
    );
  }

  Widget? _buildSubtitle() {
    final List<String> items = [
      if (todo.priority != Priority.none) todo.priority.name,
      for (String p in todo.fmtProjects) p,
      for (String c in todo.fmtContexts) c,
      for (String kv in todo.fmtKeyValues) kv,
    ]..removeWhere((value) => value.isEmpty);

    if (items.isEmpty) {
      return null;
    }

    List<String> shortenedItems;
    if (items.length > 5) {
      shortenedItems = items.sublist(0, 5);
      shortenedItems.add('...');
    } else {
      shortenedItems = [...items];
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        for (String attr in shortenedItems) BasicChip(label: attr, mono: true),
      ],
    );
  }
}

class TodoListDeleteFilter extends StatelessWidget {
  const TodoListDeleteFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (BuildContext context, FilterState state) {
        return state is! FilterSaved || state.filter.id == null
            ? Container()
            : IconButton(
                tooltip: 'Delete filter',
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final bool confirm = await ConfirmationDialog.dialog(
                    context: context,
                    title: 'Delete filter',
                    message: 'Do you want to delete the filter?',
                    actionLabel: 'Delete',
                  );
                  if (context.mounted && confirm) {
                    await context.read<FilterCubit>().delete(state.filter);
                    if (context.mounted) {
                      SnackBarHandler.info(context, 'Filter deleted');
                      context.pop();
                      context.read<DrawerCubit>().back();
                    }
                  }
                },
              );
      },
    );
  }
}

class TodoListSaveFilter extends StatelessWidget {
  const TodoListSaveFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (BuildContext context, FilterState state) {
        return state is FilterSaved || state.filter.id == null
            ? Container()
            : IconButton(
                tooltip: 'Save filter',
                icon: const Icon(Icons.save),
                onPressed: () async {
                  await context
                      .read<FilterCubit>()
                      .update(state.filter.copyWith());
                  if (context.mounted) {
                    SnackBarHandler.info(context, 'Filter saved');
                  }
                },
              );
      },
    );
  }
}
