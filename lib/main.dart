import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: DrawTriangle2()));

class DrawTriangle2 extends StatefulWidget {
  @override
  _DrawTriangle2State createState() => _DrawTriangle2State();
}

class _DrawTriangle2State extends State<DrawTriangle2> {
  double numberOfCycles = 0;
  Color _selectedColor;
  int shaderValue = 0;
  double _selectedSize = 300;
  int randomValue = 50;
  double opacity = 1;
  Color gradientStart = Colors.grey;
  Color gradientEnd = Colors.deepPurpleAccent;
  bool colorChooserVisible = false;
  double canvasPositionX = 70;
  double canvasPositionY = 150;
  double difference = 300;
  bool incrementClock = true;
  List<Color> colors = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.deepPurple
  ];

  void clock() {
    Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      incrementClock == true
          ? setState(() {
              numberOfCycles > 19 ? incrementClock = false : numberOfCycles++;
            })
          : setState(() {
              numberOfCycles < 1 ? incrementClock = true : numberOfCycles--;
            });
    });
  }

  Widget sliderSizeChooser(double _width) {
    return Slider(
        label: "()=> Size",
        activeColor: _selectedColor,
        inactiveColor: Colors.black,
        min: 10,
        max: 300,
        value: _selectedSize,
        onChanged: (newValue) {
          difference = _width - newValue;
          _selectedSize = newValue;
          canvasPositionX = difference / 2;

          canvasPositionY = difference / 2 + 70;
        });
  }

  Widget sliderShaderChooser() {
    return Slider(
        label: "()=> Size",
        activeColor: _selectedColor,
        inactiveColor: Colors.black,
        min: 0,
        max: 20,
        value: shaderValue.toDouble(),
        onChanged: (newValue) {
          shaderValue = newValue.toInt();
        });
  }

  Widget colorOpacity() {
    return Slider(
        label: "()=> Opacity",
        activeColor: _selectedColor,
        inactiveColor: Colors.black,
        min: 0,
        max: 1,
        value: opacity.toDouble(),
        onChanged: (newValue) {
          opacity = newValue;
        });
  }

  Widget counter() {
    return Container(
      child: Text(
        numberOfCycles.round().toString(),
        style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget colorPicker() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Container(
          child: Expanded(
            child: ListView.builder(
                itemCount: colors.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      colorChooserVisible = false;
                      _selectedColor = this.colors[index];
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                      ),
                      height: 50,
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    clock();
    _selectedColor = Colors.red;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.grey,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [gradientStart, gradientEnd],
                        begin: const FractionalOffset(1, 1),
                        end: const FractionalOffset(0.0, 0.5),
                        stops: [0, 1],
                        tileMode: TileMode.clamp),
                  )),
              Positioned(
                left: canvasPositionX,
                top: canvasPositionY,
                child: Opacity(
                  opacity: opacity.toDouble(),
                  child: CustomPaint(
                    size: Size(_width, _height),
                    painter: DrawTriangle(numberOfCycles.round(),
                        _selectedColor, _selectedSize.toInt(), shaderValue),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 100,
                child: Row(children: <Widget>[
                  Text(
                    "(Size)      =>",
                    style: TextStyle(fontSize: 30),
                  ),
                  sliderSizeChooser(_width),
                ]),
              ),
              Positioned(
                left: 20,
                bottom: 55,
                child: Row(children: <Widget>[
                  Text(
                    "(Shader) =>",
                    style: TextStyle(fontSize: 30),
                  ),
                  sliderShaderChooser(),
                ]),
              ),
              Positioned(
                left: 20,
                bottom: 10,
                child: Row(children: <Widget>[
                  Text(
                    "(Opacity)=>",
                    style: TextStyle(fontSize: 30),
                  ),
                  colorOpacity(),
                ]),
              ),
              colorChooserVisible == true
                  ? colorPicker()
                  : InkWell(
                      onTap: () => setState(() {
                        colorChooserVisible = true;
                      }),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "  (Color)   => ",
                            style: TextStyle(fontSize: 30),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: _selectedColor,
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                    ),
              Positioned(left: -200, child: counter()),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawTriangle extends CustomPainter {
  double startX = 150;
  double startY = 0;
  double secondX = 0;
  double secondY = 300;
  double thirdX = 300;
  double thirdY = 300;
  int numberOfLoops;
  Color chosenColor;
  int _chosenSize;
  int _shaderValue;

  DrawTriangle(this.numberOfLoops, this.chosenColor, this._chosenSize,
      this._shaderValue);

  Random _random = Random();
  int i = 0;

  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, _shaderValue.toDouble())
      ..color = chosenColor;

    final paintStroke = Paint()
      ..color = Colors.white
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    var path = Path();

    void draw() {
      path.moveTo(startX, startY);
      path.lineTo(secondX, secondY);
      path.lineTo(thirdX, thirdY);
      path.close();
      canvas.drawPath(path, paintFill);

      canvas.drawPath(path, paintStroke);
    }

    while (numberOfLoops > 0) {
      startX = _random.nextInt(_chosenSize).toDouble();
      startY = _random.nextInt(_chosenSize).toDouble();
      secondX = _random.nextInt(_chosenSize).toDouble();
      secondY = _random.nextInt(_chosenSize).toDouble();
      thirdX = _random.nextInt(_chosenSize).toDouble();
      thirdY = _random.nextInt(_chosenSize).toDouble();
      draw();

      numberOfLoops--;
    }
  }

  @override
  bool shouldRepaint(DrawTriangle oldDelegate) {
    return false;
  }
}
