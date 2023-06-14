import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Globals/globals.dart';
import '../../Models/voitureModel.dart';
import '../VoitureView/AddFillUpVoiture.dart';
import 'Toast.dart';

class CustomAnimatedButton extends StatefulWidget {
  VoitureModel voiture;

  @override
  State<StatefulWidget> createState() {
    return CustomAnimatedButtonState(voiture);
  }
  CustomAnimatedButton(this.voiture, {super.key});
}

class CustomAnimatedButtonState extends State<CustomAnimatedButton> with SingleTickerProviderStateMixin {

  late  bool toggle=true;
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
        reverseDuration: const Duration(milliseconds: 275)
    );
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn
    );
    _controller.addListener(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Alignment alignment1 = Alignment(0, 1);
  Alignment alignment2 = Alignment(0, 1);
  Alignment alignment3 = Alignment(0, 1);
  double size1= 20.0;
  late VoitureModel v;

  CustomAnimatedButtonState(voiture)  {
     v=voiture;
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          onTap: (){
            fToast.showToast(
              child: toastM("Maintenance", Colors.blue),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
          },
          child: AnimatedAlign(
            duration: toggle ? Duration(milliseconds: 275) : Duration(milliseconds: 875),
            alignment: alignment1,
            curve:  toggle ? Curves.easeIn : Curves.easeOut,
            child: AnimatedContainer(
              duration:  const Duration(milliseconds: 275),
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              height: size1,
              width: size1,
              decoration: BoxDecoration(
                color: !toggle ? Colors.blue.withOpacity(0.7) : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(Icons.car_crash_outlined,color: !toggle ? Colors.white : Colors.transparent,),
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            Navigator.push(context,  MaterialPageRoute(builder: (context) => AddFillUpVoiture(v)));
          },
          child: AnimatedAlign(
            duration: toggle ? Duration(milliseconds: 275) : Duration(milliseconds: 875),
            alignment: alignment2,
            curve:  toggle ? Curves.easeIn : Curves.easeOut,
            child: AnimatedContainer(
              duration:  const Duration(milliseconds: 275),
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              height: size1,
              width: size1,
              decoration: BoxDecoration(
                color: !toggle ? Colors.blue.withOpacity(0.7) : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(Icons.local_gas_station_outlined,color: !toggle ? Colors.white : Colors.transparent,),
            ),
          ),
        ),

        Transform.rotate(
          angle: _animation.value * pi*(3/4),
          child: AnimatedContainer(

            duration: const Duration(microseconds: 375),
            curve: Curves.easeInOut,
            height: toggle ? 50 : 40,
            width: toggle ? 50 : 40,
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.7),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Material(
              color: Colors.transparent,
              child: IconButton(

                onPressed: (){
                  setState(() {
                    if(toggle){
                      toggle =!toggle;
                      _controller.forward();
                      Future.delayed(Duration(milliseconds: 100),(){
                        size1=60;
                        alignment1 = Alignment(0.7, 0.7,);
                        alignment2 = Alignment(-0.7, 0.7);

                      });
                     /* Future.delayed(Duration(seconds: 5),(){
                        toggle =!toggle;
                        _controller.reverse();
                        size1=20;
                        alignment1 = Alignment(0, 1);
                        alignment2 = Alignment(0, 1);
                      });*/
                    }else{
                      Future.delayed(Duration(milliseconds: 100),(){
                        toggle =!toggle;
                        _controller.reverse();
                        size1=20;
                        alignment1 = Alignment(0, 1);
                        alignment2 = Alignment(0, 1);
                      });
                    }
                  });
                },
                icon:  Icon(Icons.add,size: 25,color: Colors.black.withOpacity(0.7),),
                splashColor: Colors.black54,

              ),
            ),
          ),
        )
      ],
    );
  }

}


