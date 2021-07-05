import 'dart:io';

abstract class Set {
  List<int> setting(List<int> input);
}

class SetHour implements Set {
  @override
  List<int> setting(List<int> input) {
    //print('incresing 1 hour... ');
    input[0] += 1;
    input[0] %= 24;
    return input;
  }
}

class SetMin implements Set {
  @override
  List<int> setting(List<int> input) {
    // print('incresing 1 minite...');
    input[1] += 1;
    if (input[1] / 60 >= 1) {
      input[0] += input[1] ~/ 60;
      input[1] %= 60;
    }
    return input;
  }
}

class SetIdle implements Set {
  @override
  List<int> setting(List<int> input) {
    //print('idling...');
    return input;
  }
}

class Context {
  List<int> time = [0, 0];
  Context(this.time) {
    time[0] %= 24;
    if (time[1] ~/ 60 >= 1) {
      time[0] += time[1] ~/ 60;
      time[1] %= 60;
    }
  }
  Set currentstate = SetIdle();
  void setState(Set state) {
    currentstate = state;
  }

  void inc() {
    time = currentstate.setting(time);
  }

  void telltime() {
    print(time[0].toString() + ':' + time[1].toString());
  }
}

void main(List<String> arguments) {
  var input = (stdin.readLineSync() ?? '').split(' ');
  List<int> timeinitial = [int.parse(input[1]), int.parse(input[2])];
  Context c = new Context(timeinitial);
  var set_type;
  if (input[0] == 'on') {
    var command = '';
    if (timeinitial[0] % 24 == 0 && timeinitial[1] == 0) c.setState(SetHour());
    while (true) {
      command = stdin.readLineSync() ?? '';
      if (command == 'out') {
        break;
      } else if (command == 'inc') {
        c.inc();
      } else if (command == 'set') {
        set_type = c.currentstate.runtimeType.toString();
        if (set_type == 'SetIdle') {
          c.setState(SetHour());
        } else if (set_type == 'SetMin') {
          c.setState(SetIdle());
        } else {
          c.setState(SetMin());
        }
      } else if (command == 'tell') {
        c.telltime();
      }
    }
  }
}
