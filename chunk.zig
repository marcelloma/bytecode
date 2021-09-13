const std = @import("std");
const Allocator = std.mem.Allocator;

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

  pub fn writeByte(self: *Chunk, byte: u8) u8 {
    return self.bytes.add(byte) catch unreachable;
  }

  pub fn addNumConst(self: *Chunk, num: f128) u8 {
    return self.numConsts.add(num) catch unreachable;
  }

  pub fn free(self: *Chunk) anyerror!void {
    try self.bytes.free();
    try self.lines.free();
    try self.numConsts.free();
  }
};