const std = @import("std");
const print = std.debug.print;

const Chunk = @import("./chunk.zig").Chunk;
const OpCode = @import("./common.zig").OpCode;

const debug = @import("./debug.zig");

pub fn main() anyerror!void {
  var chunk = Chunk.init();
  defer chunk.free() catch unreachable;

  _ = chunk.writeByte(@enumToInt(OpCode.opNumConst));
  var constant = chunk.addNumConst(1.2);
  _ = chunk.writeByte(constant);

  _ = chunk.writeByte(@enumToInt(OpCode.opNumConst));
  constant = chunk.addNumConst(1.2575);
  _ = chunk.writeByte(constant);

  debug.disassembleChunk(&chunk, "test chunk");
}