const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const SIZE = 256;

pub const Stack = struct {
  allocator: *Allocator,
  data: [SIZE]f128,
  topPtr: [*]f128,

  pub fn init(_allocator: ?*Allocator) *Stack {
    var allocator = _allocator orelse std.heap.c_allocator;
    var stack: *Stack = allocator.create(Stack) catch unreachable;
    stack.allocator = allocator;
    stack.topPtr = &stack.data;
    return stack;
  }

  pub fn reset(self: *Stack) void {
    self.topPtr = &self.data;
  }

  pub fn push(self: *Stack, v: f128) void {
    self.topPtr[0] = v;
    self.topPtr += 1;
  }

  pub fn pop(self: *Stack) f128 {
    self.topPtr -= 1;
    return self.topPtr[0];
  }

  pub fn free(self: *Stack) void {
    self.allocator.free(self);
  }
};