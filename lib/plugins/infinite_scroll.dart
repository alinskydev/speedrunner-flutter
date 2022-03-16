// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;

import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

enum InfiniteScrollType { gridView, listView }

class InfiniteScroll extends StatefulWidget {
  List<Widget> Function(BuildContext context, List records) builder;
  services.AppNetwork network;
  int page;

  InfiniteScrollType type;
  SliverGridDelegate? gridDelegate;

  Widget? prepend;
  Widget noData;

  InfiniteScroll({
    Key? key,
    required this.builder,
    required this.network,
    this.page = 1,
    required this.type,
    this.gridDelegate,
    this.prepend,
    this.noData = const SizedBox.shrink(),
  }) : super(key: key) {
    if (type == InfiniteScrollType.gridView) {
      assert(gridDelegate != null, '"gridDelegate" is required for this type');
    }
  }

  @override
  _InfiniteScrollState createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  Set<Widget> _records = {};
  ScrollController _scrollController = ScrollController();
  Widget _preloader = const widgets.AppPreloader();
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels > 0 && _hasMore) {
        widget.page++;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Widget> get dataFuture async {
    _preloader = widgets.AppPreloader();

    Map<String, String> queryParameters = Map.from(widget.network.uri.queryParameters);
    queryParameters['page'] = '${widget.page}';
    widget.network.uri = widget.network.uri.replace(queryParameters: queryParameters);

    dio.Response response = await widget.network.sendRequest();

    int realCurrentPage = int.parse(response.headers.value('x-pagination-current-page') ?? '1');

    if (widget.page != realCurrentPage) {
      _hasMore = false;
      _preloader = SizedBox.shrink();

      if (_records.isEmpty) return SliverToBoxAdapter(child: widget.noData);
    } else {
      _records.addAll(widget.builder(context, response.data['data']));
      _preloader = Opacity(
        opacity: 0,
        child: widgets.AppPreloader(),
      );
    }

    SliverChildBuilderDelegate delegate = SliverChildBuilderDelegate(
      (BuildContext context, int index) => _records.elementAt(index),
      childCount: _records.length,
    );

    switch (widget.type) {
      case InfiniteScrollType.listView:
        return SliverList(delegate: delegate);

      case InfiniteScrollType.gridView:
        return SliverGrid(
          delegate: delegate,
          gridDelegate: widget.gridDelegate!,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: dataFuture,
      initialData: SliverToBoxAdapter(),
      builder: (context, snapshot) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: widget.prepend,
            ),
            snapshot.data!,
            SliverToBoxAdapter(
              child: _preloader,
            ),
          ],
        );
      },
    );
  }
}
