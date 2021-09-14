const print = @import("std").debug.print;
const debug = @import("./debug.zig");
const Chunk = @import("./chunk.zig").Chunk;
const OpCode = @import("./common.zig").OpCode;

pub const InterpretResult = enum(u8) {
  ok,
  compileErr,
  runtimeErr,
};

pub const Vm = struct {
  chunk: ?*Chunk,
  iPtr: ?[*]u8,

  pub fn init() @This() {
    return Vm {
      .chunk = undefined,
      .iPtr = undefined,
    };
  }

  fn run(self: *Vm) InterpretResult {
    while(true) {
      const offset = @ptrToInt(self.iPtr.?) - @ptrToInt(self.chunk.?.bytes.items);
      _ = debug.logInstruction(self.chunk.?, offset);

      switch (@intToEnum(OpCode, self.readByte())) {
        .opReturn => return InterpretResult.ok,
        .opNumConst => {
          _ = self.readByte();
        },
        .opLongNumConst => {
          _ = self.readByte();
          _ = self.readByte();
          _ = self.readByte();
        },
        else => {},
      }
    }
  }

  fn readByte(self: *Vm) u8 {
    const byte = self.iPtr.?[0];
    self.iPtr.? += 1;
    return byte;
  }

  pub fn interpret(self: *Vm, chunk: *Chunk) InterpretResult {
    self.chunk = chunk;
    self.iPtr = chunk.bytes.items;
    return self.run();
  }

  pub fn free(self: *Vm) anyerror!void {
    _ = try self.chunk.?.free();
  }
};