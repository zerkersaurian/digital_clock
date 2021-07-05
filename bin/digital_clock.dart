import 'dart:io';

abstract class Set {                        //state part
  List<int> setting(List<int> input);
}

class SetHour implements Set {              //concreate state part 1
  @override
  List<int> setting(List<int> input) {      //increasing hour by 1 and %24
    //print('incresing 1 hour... ');
    input[0] += 1;
    input[0] %= 24;
    return input;
  }
}

class SetMin implements Set {               //concreate state part 2
  @override
  List<int> setting(List<int> input) {      //increasing minite by 1 then increase hour if minite is >60 and then minite%=60
    // print('incresing 1 minite...');
    input[1] += 1;
    if (input[1] / 60 >= 1) {
      input[0] += input[1] ~/ 60;
      input[1] %= 60;
    }
    return input;
  }
}

class SetIdle implements Set {              // concreate state part 3
  @override
  List<int> setting(List<int> input) {      // idling part can't increment time
    //print('idling...');
    return input;
  }
}

class Context {                             // context part
  List<int> time = [0, 0];
  Context(this.time) {                      // set initial time from input
    time[0] %= 24;
    if (time[1] ~/ 60 >= 1) {
      time[0] += time[1] ~/ 60;
      time[1] %= 60;
    }
  }

  Set currentstate = SetIdle();             // idle state at first

  void setState(Set state) {                // state setting
    currentstate = state;
  }

  void inc() {                              // increase time by 1 up at which current state
    time = currentstate.setting(time);  
  }

  void telltime() {                         // optional part to tell current time
    print(time[0].toString() + ':' + time[1].toString());
  }
}

void main(List<String> arguments) {
  var input = (stdin.readLineSync() ?? '').split(' ');                            // read input from terminal
  List<int> timeinitial = [int.parse(input[1]), int.parse(input[2])];             // create int list consist of hour and minite
  Context c = new Context(timeinitial);                                           // create context part class
  var set_type;                                                                   // variable to check context's state
  if (input[0] == 'on') {                                                         // only if it's 'on' from input to get program work
    var command = '';                                                             // string contain command input from terminal
    if (timeinitial[0] % 24 == 0 && timeinitial[1] == 0) c.setState(SetHour());   // if initial time is 0:0 then current Set state is to set hour
    while (true) {                                                                // read command until 'out' command
      command = stdin.readLineSync() ?? '';
      if (command == 'out') {
        break;
      } else if (command == 'inc') {                                              // inc command to increament time up to current state
        c.inc();
      } else if (command == 'set') {                                              // set state up to current state ( Hour => Min => Idle => Hour )
        set_type = c.currentstate.runtimeType.toString();                         // get current state class name
        if (set_type == 'SetIdle') {
          c.setState(SetHour());
        } else if (set_type == 'SetMin') {
          c.setState(SetIdle());
        } else {
          c.setState(SetMin());
        }
      } else if (command == 'tell') {                                             // tell current time
        c.telltime();
      }
    }
  }
}
