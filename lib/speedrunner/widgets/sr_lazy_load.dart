import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/base/model.dart';
import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class SRLazyLoad extends StatefulWidget {
  SRLazyLoadType type;
  SliverGridDelegate? gridDelegate;
  Widget? prepend;
  Widget emptyChild;

  List<Widget> Function(BuildContext context, List records) builder;
  services.SRApiRequest apiRequest;
  int page;

  SRLazyLoad({
    Key? key,
    required this.type,
    this.gridDelegate,
    this.prepend,
    this.emptyChild = const SizedBox.shrink(),
    required this.builder,
    required this.apiRequest,
    this.page = 1,
  }) : super(key: key) {
    if (type == SRLazyLoadType.gridView && gridDelegate == null) {
      throw '"gridDelegate" is required for this type';
    }
  }

  @override
  _SRLazyLoadState createState() => _SRLazyLoadState();
}

class _SRLazyLoadState extends State<SRLazyLoad> {
  List<Widget> children = [];
  ScrollController scrollController = ScrollController();
  bool hasMore = true;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels > 0 && hasMore) {
        context.read<bloc.SRLazyLoadCubit>().process(
              context: context,
              builder: widget.builder,
              apiRequest: widget.apiRequest,
              page: ++widget.page,
            );
      }
    });

    context.read<bloc.SRLazyLoadCubit>().process(
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
    return BlocBuilder<bloc.SRLazyLoadCubit, Map<String, dynamic>>(
      builder: (context, state) {
        if (state['records'] != null) {
          children.addAll(state['records']);
        }

        if (state.isEmpty) {
          hasMore = false;
        }

        late Widget list = SliverToBoxAdapter(
          child: widget.emptyChild,
        );

        if (children.isNotEmpty) {
          switch (widget.type) {
            case SRLazyLoadType.listView:
              list = SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => children[index],
                  childCount: children.length,
                ),
              );
              break;
            case SRLazyLoadType.gridView:
              list = SliverGrid(
                gridDelegate: widget.gridDelegate!,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => children[index],
                  childCount: children.length,
                ),
              );
              break;
          }
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

enum SRLazyLoadType { gridView, listView }
