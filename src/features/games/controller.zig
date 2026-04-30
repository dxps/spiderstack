const std = @import("std");
const spider = @import("spider");
const core = @import("core");

const model = @import("model.zig");
const repository = @import("repository.zig");
const presenter = @import("presenter.zig");
const i18n = core.i18n;

pub fn index(c: *spider.Ctx) !spider.Response {
    const locale_raw = c.header("Accept-Language") orelse "pt-BR";
    const locale = i18n.localeFromStr(locale_raw);

    const games = try repository.findAll(c.arena);
    const context = try presenter.buildGameListContext(c.arena, c, locale, games);

    return c.view("games/index", context, .{});
}

pub fn create(c: *spider.Ctx) !spider.Response {
    const input = try c.parseForm(model.CreateInput);

    _ = try repository.create(c.arena, input);

    return c.redirect("/games");
}

pub fn update(c: *spider.Ctx) !spider.Response {
    const id = try core.utils.parseIdFromCtx(c);

    const updates = try c.parseForm(model.UpdateInput);

    _ = try repository.update(c.arena, id, updates);

    return c.redirect("/games");
}

pub fn delete(c: *spider.Ctx) !spider.Response {
    const id = try core.utils.parseIdFromCtx(c);

    try repository.delete(c.arena, id);

    return c.text("", .{});
}
