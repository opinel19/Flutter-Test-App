import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.blue),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double _sliderValue = 51.10;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isChangingValue = false;
  bool _isSliderEnabled = true;
  Timer? _timer;

  // Checkbox states
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller.text = _sliderValue.toStringAsFixed(2);
    _tabController = TabController(length: 3, vsync: this);
  }

  void _startShimmerEffect() {
    setState(() {
      _isChangingValue = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isChangingValue = false;
      });
    });
  }

  void _updateTextBoxFromSlider(double value) {
    if (!_isChangingValue) {
      setState(() {
        _sliderValue = value;
        _controller.text = value.toStringAsFixed(2);
      });
    }
  }

  void _updateSliderFromTextBox() {
    double? parsedValue = double.tryParse(_controller.text);
    if (parsedValue != null) {
      parsedValue = parsedValue.clamp(0, 100);
      setState(() {
        _sliderValue = parsedValue!;
        _controller.text = parsedValue.toStringAsFixed(2);
      });
    }
  }

  void _filterInput(String input) {
    String filteredInput = input.replaceAll(RegExp(r'[^0-9.]'), '');
    if (filteredInput != input) {
      _controller.text = filteredInput;
      _controller.selection =
          TextSelection.collapsed(offset: filteredInput.length);
    }
  }

  void _setSliderToMin() {
    setState(() {
      _sliderValue = 0;
      _controller.text = _sliderValue.toStringAsFixed(2);
    });
  }

  void _setSliderToMax() {
    setState(() {
      _sliderValue = 100;
      _controller.text = _sliderValue.toStringAsFixed(2);
    });
  }

  void _setSliderToRandom() {
    setState(() {
      _sliderValue = Random().nextDouble() * 100;
      _controller.text = _sliderValue.toStringAsFixed(2);
    });
  }

  void _incrementCounter() {
    setState(() {
      _sliderValue = (_sliderValue + 1).clamp(0, 100);
      _controller.text = _sliderValue.toStringAsFixed(2);
    });
  }

  void _decrementCounter() {
    setState(() {
      _sliderValue = (_sliderValue - 1).clamp(0, 100);
      _controller.text = _sliderValue.toStringAsFixed(2);
    });
  }

  void _selectAllCheckboxes() {
    setState(() {
      _checkbox1 = true;
      _checkbox2 = true;
      _checkbox3 = true;
    });
  }

  void _deselectAllCheckboxes() {
    setState(() {
      _checkbox1 = false;
      _checkbox2 = false;
      _checkbox3 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("test"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Slider"),
            Tab(text: "Dropdown"),
            Tab(text: "Checkbox"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSliderTab(),
          _buildDropdownTab(),
          _buildCheckboxTab(),
        ],
      ),
    );
  }

  Widget _buildSliderTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Slider Value Control',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: _isSliderEnabled,
                onChanged: (value) {
                  setState(() {
                    _isSliderEnabled = value;
                  });
                },
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isChangingValue)
                        Animate(
                          effects: [
                            ShimmerEffect(
                              color: Colors.grey.shade300,
                              duration: const Duration(milliseconds: 500),
                            )
                          ],
                          child: Container(
                            height: 48,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      AbsorbPointer(
                        absorbing: !_isSliderEnabled || _isChangingValue,
                        child: Slider(
                          value: _sliderValue,
                          min: 0,
                          max: 100,
                          divisions: 9900,
                          activeColor:
                              _isSliderEnabled ? Colors.blue : Colors.grey,
                          onChanged: _updateTextBoxFromSlider,
                          onChangeEnd: (value) {
                            _startShimmerEffect();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      isDense: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      labelText: "Slider Value",
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      alignLabelWithHint: true,
                      filled: true,
                    ),
                    onChanged: (value) {
                      if (_isSliderEnabled) {
                        _filterInput(value);
                      }
                    },
                    onEditingComplete: () {
                      if (_isSliderEnabled) {
                        FocusScope.of(context).unfocus();
                        _updateSliderFromTextBox();
                      }
                    },
                    readOnly: !_isSliderEnabled,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Min: 0, Max: 100',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSliderButton("Minimum", _setSliderToMin),
                const SizedBox(width: 10),
                _buildSliderButton("Random", _setSliderToRandom),
                const SizedBox(width: 10),
                _buildSliderButton("Maximum", _setSliderToMax),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSliderButton("Decrease", _decrementCounter),
                const SizedBox(width: 10),
                _buildSliderButton("Increase", _incrementCounter),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: InkWell(
        onTap: _isSliderEnabled ? onPressed : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _isSliderEnabled ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownTab() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: CustomDropdownMenu(),
    );
  }

  Widget _buildCheckboxTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'Checkbox Selection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildCheckbox("Checkbox 1", _checkbox1, (value) {
            setState(() {
              _checkbox1 = value ?? false;
            });
          }),
          _buildCheckbox("Checkbox 2", _checkbox2, (value) {
            setState(() {
              _checkbox2 = value ?? false;
            });
          }),
          _buildCheckbox("Checkbox 3", _checkbox3, (value) {
            setState(() {
              _checkbox3 = value ?? false;
            });
          }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCheckboxButton(
                  "Deselect All", _deselectAllCheckboxes, Colors.red),
              _buildCheckboxButton(
                  "Select All", _selectAllCheckboxes, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return InkWell(
      onTap: () {
        setState(() {
          onChanged(!value);
        });
      },
      splashColor: Colors.blue.withOpacity(0.3),
      highlightColor: Colors.blue.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxButton(
      String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }
}

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({Key? key}) : super(key: key);

  @override
  _CustomDropdownMenuState createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? _selectedOption;
  final List<String> _options = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Dropdown Menu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        DropdownSearch<String>(
          items: _options,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Select Option",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            constraints: const BoxConstraints(
              maxHeight: 175,
              maxWidth: 300,
            ),
            itemBuilder: (context, item, isSelected) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
            });
          },
          selectedItem: _selectedOption,
        ),
      ],
    );
  }
}
