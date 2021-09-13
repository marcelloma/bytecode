const std = @import("std");
const Allocator = std.mem.Allocator;

const OpCode = @import("./common.zig").OpCode;
const DynamicArray = @import("./dynamic_array.zig").DynamicArray;

pub const ByteArr = DynamicArray(u8);
pub const FloatArr = DynamicArray(f128);

pub const Chunk = struct {
  bytes: ByteArr,
  lines: ByteArr,
  numConsts: FloatArr,

  pub fn init() Chunk {
    return Chunk {
      .bytes = ByteArr.init(null),
      .lines = ByteArr.init(null),
      .numConsts = FloatArr.init(null),
    };
  }

  fn write(self: *Chunk, byte: u8, line: u8) void {
    _ = self.lines.add(line) catch unreachable;
    _ = self.bytes.add(byte) catch unreachable;
  }

  pub fn writeSimpleOp(self: *Chunk, opCode: OpCode, line: u8) void {
    _ = self.write(@enumToInt(opCode), line);
  }

  pub fn writeNumConstOp(self: *Chunk, num: f128, line: u8) void {
    const constant = self.numConsts.add(num) catch unreachable;

    if (constant < std.math.maxInt(u8)) {
      _ = self.write(@enumToInt(OpCode.opNumConst), line);
      _ = self.write(@intCast(u8, constant), line);
    } else if (constant < std.math.maxInt(u24)) {
      _ = self.write(@enumToInt(OpCode.opLongNumConst), line);
      _ = self.write(@intCast(u8, (constant >> 0) & 0xFF), line);
      _ = self.write(@intCast(u8, (constant >> 8) & 0xFF), line);
      _ = self.write(@intCast(u8, (constant >> 16) & 0xFF), line);
    } else {
      unreachable;
    }
  }

  pub fn free(self: *Chunk) anyerror!void {
    try self.bytes.free();
    try self.lines.free();
    try self.numConsts.free();
  }
};