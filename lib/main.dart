import 'package:flutter/material.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';

enum BottomTab {tabs, about, unused}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> with TickerProviderStateMixin {
  late final KeyedTabController<String> _tabController;
  BottomTab _tab = BottomTab.tabs;

  @override
  void initState() {
    super.initState();
    _tabController = KeyedTabController<String>(
      initialKey: 'tab3',
      keys: ['tab1', 'tab2', 'tab3'],
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is a simplified example: IndexedStack and KeyedStack are only
    // meaningful if they contain stateful widgets to preserve state
    // between switches.
    return Scaffold(
      body: KeyedStack<BottomTab>(
        itemKey: _tab,
        children: {
          // Any order here. The order in KeyedBottomNavigationBar is what matters.
          BottomTab.about: const Center(child: Text('keyed_collection_widgets example')),
          BottomTab.unused: const Text('No button for this one, so it is never used.'),
          BottomTab.tabs: _getTabsContent(),
        },
      ),
      bottomNavigationBar: KeyedBottomNavigationBar<BottomTab>(
        currentItemKey: _tab,
        items: const {
          BottomTab.tabs: BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'KeyedTabController',
          ),
          BottomTab.about: BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        },
        onTap: (tab) => setState((){ _tab = tab; }),
      ),
    );
  }

  Widget _getTabsContent() {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) => _getTabsContentOnChange(),
    );
  }

  Widget _getTabsContentOnChange() {
    return Column(
      children: [
        KeyedTabBar(
          tabs: {
            for (final key in _tabController.keys)
              key: Tab(child: Text(key.toString())),
          },
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: KeyedTabBarView(
            children: {
              for (final key in _tabController.keys)
                key: TabContent(text: key + ' content', tabController: _tabController),
            },
            controller: _tabController,
          ),
        ),
      ],
    );
  }
}

class TabContent extends StatelessWidget {
  final String text;
  final KeyedTabController<String> tabController;

  TabContent({
    required this.text,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          ElevatedButton(
            onPressed: () {
              final key = DateTime.now().millisecondsSinceEpoch.toString();

              // Changes both tab list and the currently selected one.
              // Use 'keys' and 'currentKey' to access them separately.
              tabController.setKeysAndCurrentKey([...tabController.keys, key], key);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
