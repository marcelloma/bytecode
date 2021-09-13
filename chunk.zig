const std = @import("std");
const Allocator = std.mem.Allocator;

const DynamicArray = @import("./dynamic_array.zig").DynamicArray;

pub const ByteArr = DynamicArray(u8);
pub const NumConstArr = DynamicArray(f128);

pub const Chunk = struct {
  bytes: ByteArr,
  numConsts: NumConstArr,

  pub fn init() Chunk {
    return Chunk {
      .bytes = ByteArr.init(null),
      .numConsts = NumConstArr.init(null),
    };
  }

  pub fn writeByte(self: *Chunk, byte: u8) u8 {
    return self.bytes.add(byte) catch unreachable;
  }

  pub fn addNumConst(self: *Chunk, num: f128) u8 {
    return self.numConsts.add(num) catch unreachable;
  }
};