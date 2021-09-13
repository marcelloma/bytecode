const std = @import("std");

const Allocator = std.mem.Allocator;

pub fn DynamicArray(comptime T: type) type {
  return struct {
    allocator: *Allocator,
    capacity: u8,
    count: u8,
    items: [*]T,

    pub fn init(allocator: ?*Allocator) @This() {
      return @This() {
        .allocator = allocator orelse std.heap.c_allocator,
        .capacity = 0,
        .count = 0,
        .items = undefined
      };
    }

    fn growCapacity(self: *@This()) void {
      self.capacity = if (self.capacity < 8) 8 else self.capacity * 2;
    }

    pub fn add(self: *@This(), item: T) anyerror!u8 {
      if (self.capacity < self.count + 1) {
        const oldCapacity = self.capacity;
        self.growCapacity();

        if (oldCapacity == 0) {
          const memory = try self.allocator.alloc(T, self.capacity);
          self.items = memory.ptr;
        } else {
          const memory = try self.allocator.realloc(self.items[0..oldCapacity], self.capacity);
          self.items = memory.ptr;
        }
      }

      self.items[self.count] = item;
      self.count += 1;
      return self.count - 1;
    }

    pub fn free(self: *@This()) anyerror!void {
      self.allocator.free(self.items[0..self.capacity]);
      self.* = @This().init(self.allocator);
    }
  };
}