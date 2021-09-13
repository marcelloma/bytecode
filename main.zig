const std = @import("std");
const print = std.debug.print;

const Chunk = @import("./chunk.zig").Chunk;
const OpCode = @import("./common.zig").OpCode;

const debug = @import("./debug.zig");

pub fn main() anyerror!void {
  var chunk = Chunk.init();
  defer chunk.free() catch unreachable;

  var i: usize = 0;
  while (i < 100) {
    i += 1;

    _ = chunk.writeSimpleOp(OpCode.opReturn, 1);
    _ = chunk.writeNumConstOp(1.0, 1);
    _ = chunk.writeNumConstOp(1.5, 1);
    _ = chunk.writeNumConstOp(2.0, 1);
  }

  debug.disassembleChunk(&chunk, "test chunk");
}