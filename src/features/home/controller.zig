const std = @import("std");
const spider = @import("spider");
const i18n = @import("core").i18n;
const presenter = @import("presenter.zig");

pub fn index(c: *spider.Ctx) !spider.Response {
    const locale_raw = c.header("Accept-Language") orelse "pt-BR";
    const locale = i18n.localeFromStr(locale_raw);
    const context = try presenter.buildHomeContext(c.arena, c, locale);
    return c.view("home/index", context, .{});
}
