const std = @import("std");
const spider = @import("spider");
const core = @import("core");
const features = @import("features");
const auth = features.auth;
const home = features.home;
const games = features.games;
const todo = features.todo;
const movies = features.movies;
const db = @import("spider").pg;
const migrations = core.db.migrations;
const middleware = core.middleware;
const Response = spider.Response;
pub const spider_templates = @import("embedded_templates.zig").EmbeddedTemplates;

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();
    const io = init.io;

    db.init(arena, io, .{
        .host = "localhost",
        .port = 5434,
        .user = "spider",
        .password = "spider",
        .database = "spiderdb",
    }) catch {
        std.debug.print("Failed to initialize PostgreSQL\n", .{});
        return;
    };
    defer spider.pg.deinit();
    try migrations.run(arena);

    var server = spider.app();
    defer server.deinit();

    server
        // .use(middleware.auth)
        .get("/login", auth.controller.index)
        .post("/login", auth.controller.handleLogin)
        .get("/auth/google", auth.controller.redirectToGoogle)
        .get("/auth/google/callback", auth.controller.googleCallback)
        .post("/auth/email/register", auth.controller.handleEmailAuth)
        .post("/auth/email/login", auth.controller.handleEmailAuth)
        .get("/logout", auth.controller.logout)
        .get("/todo", todo.controller.index)
        .post("/todo/create", todo.controller.create)
        .post("/todo/:id/update", todo.controller.update)
        .post("/todo/:id/delete", todo.controller.delete)
        .get("/", home.controller.index)
        .post("/games/create", games.controller.create)
        .post("/games/:id/update", games.controller.update)
        .post("/games/:id/delete", games.controller.delete)
        .get("/games", games.controller.index)
        .get("/movies", movies.controller.index)
        .get("/movies/search", movies.controller.search)
        .get("/movies/popular", movies.controller.popular)
        .get("/movies/:id", movies.controller.movieDetails)
        .listen(8080) catch |err| return err;
}
