const std = @import("std");
const spider = @import("spider");

const model = @import("model.zig");
const repository = @import("repository.zig");
const presenter = @import("presenter.zig");

pub fn index(c: *spider.Ctx) !spider.Response {
    const todos = try repository.findAll(c.arena);
    defer c.arena.free(todos);

    const context = try presenter.buildContext(c.arena, c, todos);

    return c.view("todo/index", context, .{});
}

fn isHxRequest(c: *spider.Ctx) bool {
    return c.header("HX-Request") != null;
}

pub fn create(c: *spider.Ctx) !spider.Response {
    const input = try c.parseForm(model.CreateInput);
    const todo = (try repository.create(c.arena, input)) orelse return c.text("Error creating todo", .{});

    if (isHxRequest(c)) {
        const context = try presenter.buildItemContext(c.arena, c, todo);
        return c.view("todo/item_todo", context, .{});
    }

    return c.redirect("/todo");
}

pub fn update(c: *spider.Ctx) !spider.Response {
    const id = try std.fmt.parseInt(i64, c.params.get("id") orelse "", 10);
    const updates = try c.parseForm(model.UpdateInput);
    const todo = (try repository.update(c.arena, id, updates)) orelse return c.text("Error updating todo", .{});
    if (isHxRequest(c)) {
        const context = try presenter.buildItemContext(c.arena, c, todo);
        std.debug.print("todo.id={d} todo.title={s}\n", .{ context.todo.id, context.todo.title });
        return c.view("todo/item_todo", context, .{});
    }
    return c.redirect("/todo");
}

pub fn delete(c: *spider.Ctx) !spider.Response {
    const id = try std.fmt.parseInt(i64, c.params.get("id") orelse "", 10);
    try repository.delete(c.arena, id);

    if (isHxRequest(c)) {
        return c.text("", .{});
    }

    return c.redirect("/todo");
}
