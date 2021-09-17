const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const debug = @import("./debug.zig");
const Chunk = @import("./chunk.zig").Chunk;
const Stack = @import("./stack.zig").Stack;
const OpCode = @import("./common.zig").OpCode;

pub const InterpretResult = enum(u8) {
  ok,
  compileErr,
  runtimeErr,
};

pub const Vm = struct {
  allocator: *Allocator,
  chunk: ?*Chunk,
  iPtr: ?[*]u8,
  stack: *Stack,

  pub fn init(_allocator: ?*Allocator) *Vm {
    var allocator = _allocator orelse std.heap.c_allocator;
    var vm: *Vm = allocator.create(Vm) catch unreachable;
    vm.allocator = allocator;
    vm.stack = Stack.init(allocator);
    return vm;
  }

  fn run(self: *Vm) InterpretResult {
    while(true) {
      // debug.dumpStack(self);

      const offset = @ptrToInt(self.iPtr.?) - @ptrToInt(self.chunk.?.bytes.items);
      _ = debug.logInstruction(self.chunk.?, offset);

      switch (@intToEnum(OpCode, self.readByte())) {
        .opReturn =>  {
          const returnValue = self.stack.pop();
          print("\nResult: {:.}\n", .{returnValue});
          return InterpretResult.ok;
        },
        .opNumConst => {
          const constant = self.readByte();
          const value = self.chunk.?.numConsts.items[constant];
          _ = self.stack.push(value);
        },
        .opLongNumConst => {
          const byte1 = self.readByte();
          const byte2 = self.readByte();
          const byte3 = self.readByte();
          const constant: u24 = (@as(u24, byte3) << 16) + (@as(u24, byte2) << 8) + byte1;
          const value = self.chunk.?.numConsts.items[constant];
          _ = self.stack.push(value);
        },
        .opAdd => {
          const rhs = self.stack.pop();
          const lhs = self.stack.pop();
          _ = self.stack.push(lhs + rhs);
        },
        .opSub => {
          const rhs = self.stack.pop();
          const lhs = self.stack.pop();
          _ = self.stack.push(lhs - rhs);
        },
        .opMul => {
          const rhs = self.stack.pop();
          const lhs = self.stack.pop();
          _ = self.stack.push(lhs * rhs);
        },
        .opDiv => {
          const rhs = self.stack.pop();
          const lhs = self.stack.pop();
          _ = self.stack.push(lhs / rhs);
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