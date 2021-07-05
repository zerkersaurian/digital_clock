import 'dart:html';
import 'dart:io';

abstract class Set {
  List<int> setting(List<int> input);
}

class SetHour implements Set {
  @override
  List<int> setting(List<int> input) {
    print('setting hour... ');
    input[0] += 1;
    return input;
  }
}

class SetMin implements Set {
  @override
  List<int> setting(List<int> input) {
    print('setting minite...');
    input[1] += 1;
    return input;
  }
}

class Context {
  List<int> time = [0, 0];
  Set currentstate = new SetHour();
  void setState(Set state) {
    currentstate = state;
  }

  void inc() {
    time = currentstate.setting(time);
  }
}

void main(List<String> arguments) {
  var input = (stdin.readLineSync() ?? '').split(' ');
  print(input);
}
