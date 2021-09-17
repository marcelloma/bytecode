pub const OpCode = enum(u8) {
  opReturn,
  opNumConst,
  opLongNumConst,
  opAdd,
  opSub,
  opMul,
  opDiv,
  _,
};