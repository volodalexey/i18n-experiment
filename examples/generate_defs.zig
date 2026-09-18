const std = @import("std");
const i18n = @import("i18n");

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer std.debug.assert(gpa.deinit() == .ok);
    const alloc = gpa.allocator();

    const input =
        \\def "Hello {%name}!"
        \\    "Moikka {%name}!"
        \\end
        \\
    ;

    var ctx = i18n.Context{ .arena = std.heap.ArenaAllocator.init(alloc) };
    defer ctx.deinit();
    try i18n.parse(&ctx, input);

    var out_buf = std.ArrayList(u8).empty;
    defer out_buf.deinit(alloc);

    try ctx.format(&out_buf, "Hello foo {s}!", .{"Veikka"});
    try ctx.format(&out_buf, "Hello baz {s}!", .{"Veikka"});
    try ctx.format(&out_buf, "Hello bar {s}!", .{"Veikka"});
}
