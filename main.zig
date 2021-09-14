const std = @import("std");
const print = std.debug.print;

const Vm = @import("./vm.zig").Vm;
const Chunk = @import("./chunk.zig").Chunk;
const OpCode = @import("./common.zig").OpCode;

pub fn main() anyerror!void {
  var chunk = Chunk.init();
  var vm = Vm.init();
  defer vm.free() catch unreachable;
  defer chunk.free() catch unreachable;

  var i: usize = 0;
  while (i < 20) {
    i += 1;

    _ = chunk.writeNumConstOp(1.0, i);
    _ = chunk.writeNumConstOp(1.5, i);
    _ = chunk.writeNumConstOp(2.0, i);
    _ = chunk.writeSimpleOp(OpCode.opReturn, i);
  }

  const result = vm.interpret(&chunk);
}