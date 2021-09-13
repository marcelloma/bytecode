const print = @import("std").debug.print;

const Chunk = @import("./chunk.zig").Chunk;
const OpCode = @import("./common.zig").OpCode;

pub fn disassembleChunk(chunk: *Chunk, name: []const u8) void {
  print("== {s} ==\n", .{name});

  var offset: usize = 0;
  while (offset < chunk.bytes.count) {
    offset = disassembleInstruction(chunk, offset);
  }
}

pub fn disassembleInstruction(chunk: *Chunk, offset: usize) usize {
  print("{:0>5} ", .{offset});

  return switch (@intToEnum(OpCode, chunk.bytes.items[offset])) {
    .opReturn => simpleInstruction("OP_RETURN", offset),
    .opNumConst => constantInstruction("OP_NUM_CONST", chunk, offset),
  };
}

pub fn simpleInstruction(instruction: []const u8, offset: usize) usize {
  print("{s}\n", .{instruction});
  return offset + 1;
}

pub fn constantInstruction(instruction: []const u8, chunk: *Chunk, offset: usize) usize {
  const constant = chunk.bytes.items[offset + 1];
  const value = chunk.numConsts.items[constant];
  print("{s} {:0>3} {:.}\n", .{instruction, constant, value});
  return offset + 2;
}