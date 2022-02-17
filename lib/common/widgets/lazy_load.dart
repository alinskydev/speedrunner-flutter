import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/base/model.dart';
import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class LazyLoad extends StatefulWidget {
  Widget? prepend;
  LazyLoadType type;
  SliverGridDelegate? gridDelegate;
  List<Widget> Function(BuildContext context, List records) builder;
  services.ApiRequest apiRequest;
  int page;

  LazyLoad({
    Key? key,
    this.prepend,
    required this.type,
    this.gridDelegate,
    required this.builder,
    required this.apiRequest,
    this.page = 1,
  }) : super(key: key) {
    if (type == LazyLoadType.gridView && gridDelegate == null) {
      throw '"gridDelegate" is required for this type';
    }
  }

  @override
  _LazyLoadState createState() => _LazyLoadState();
}

class _LazyLoadState extends State<LazyLoad> {
  List<Widget> children = [];
  ScrollController scrollController = ScrollController();
  bool hasMore = true;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels > 0 && hasMore) {
        context.read<LazyLoadCubit>().process(
              context: context,
              builder: widget.builder,
              apiRequest: widget.apiRequest,
              page: ++widget.page,
            );
      }
    });

    context.read<LazyLoadCubit>().process(
          context: context,
          builder: widget.builder,
          apiRequest: widget.apiRequest,
          page: widget.page,
        );

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LazyLoadCubit, Map<String, dynamic>>(
      builder: (context, state) {
        if (state['records'] != null) {
          children.addAll(state['records']);
        }

        if (state.isEmpty) {
          hasMore = false;
        }

        late Widget list;

        switch (widget.type) {
          case LazyLoadType.listView:
            list = SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => children[index],
                childCount: children.length,
              ),
            );
            break;
          case LazyLoadType.gridView:
            list = SliverGrid(
              gridDelegate: widget.gridDelegate!,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => children[index],
                childCount: children.length,
              ),
            );
            break;
        }

        return CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: widget.prepend,
            ),
            list,
            SliverToBoxAdapter(
              child: state['preloader'],
            ),
          ],
        );
      },
    );
  }
}

class LazyLoadCubit extends Cubit<Map<String, dynamic>> {
  LazyLoadCubit() : super({});

  Future<void> process({
    required BuildContext context,
    required List<Widget> Function(BuildContext context, List records) builder,
    required services.ApiRequest apiRequest,
    required int page,
  }) async {
    emit({
      'records': null,
      'preloader': widgets.AppPreloader(),
    });

    apiRequest.queryParameters ??= {};
    apiRequest.queryParameters!['page'] = '$page';

    Map data = await apiRequest.getData();

    int realCurrentPage = int.parse(data['headers']['x-pagination-current-page']);

    if (page == realCurrentPage) {
      List records = data['body']['data'];

      emit({
        'records': builder(context, records),
        'preloader': SizedBox(height: 30),
      });
    } else {
      emit({});
    }
  }
}

enum LazyLoadType { gridView, listView }
