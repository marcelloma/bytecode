const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const Vm = @import("./vm.zig").Vm;
const Chunk = @import("./chunk.zig").Chunk;
const Stack = @import("./stack.zig").Stack;
const OpCode = @import("./common.zig").OpCode;

pub fn main() anyerror!void {
  var chunk = Chunk.init();
  var vm = Vm.init(null);

  //  5 + 5 * 10 - 3 = 52
  _ = chunk.writeNumConstOp(5.0, 1);
  _ = chunk.writeNumConstOp(10.0, 1);
  _ = chunk.writeNumConstOp(5.0, 1);
  _ = chunk.writeSimpleOp(OpCode.opMul, 1);
  _ = chunk.writeSimpleOp(OpCode.opAdd, 1);
  _ = chunk.writeNumConstOp(3.0, 1);
  _ = chunk.writeSimpleOp(OpCode.opSub, 1);
  _ = chunk.writeSimpleOp(OpCode.opReturn, 1);

  _ = vm.interpret(&chunk);
}