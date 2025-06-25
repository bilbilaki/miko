part of 'home_screen.dart';

class AxesInputPage extends StatefulWidget {
  const AxesInputPage({super.key});

  @override
  State<AxesInputPage> createState() => _AxesInputPageState();
}

class _AxesInputPageState extends State<AxesInputPage> {
  

  // void _refreshModels() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = '';
  //   });

  //   try {
  //     final models = await _openAIService.fetchModels();
  //     setState(() {
  //       _models = models;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = e.toString();
  //       _isLoading = false;
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Axes Input')),
                drawer: const ComponentLibraryDrawer(),
      endDrawer: const ComponentBrowserDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              child: ElevatedButton(
                onPressed: (){},
                child: Text('Fetch Models'),
              ),
            ),
            SizedBox(width: 16),
            // ElevatedButton(
            //   onPressed: _refreshModels,
            //   child: Text('Refresh Models'),
            // ),
    
            const SizedBox(height: 16),
            Expanded(
              child: Scrollbar(
                child: TextField(
                  controller: controller1,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    labelText: 'Input 1',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Scrollbar(
                child: TextField(
                  controller: controller2,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    labelText: 'Input 2',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        // Use the selected model here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Run pressed with mode')),
                        );
                      },
                      child: Text("Run"),
                    )))
          ],
        ),
      ),
    );
  }
}
