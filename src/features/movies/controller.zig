const std = @import("std");
const spider = @import("spider");

const service = @import("service.zig");
const model = @import("model.zig");

pub fn index(c: *spider.Ctx) !spider.Response {
    return c.view("movies/index", .{
        .query = null,
        .results = &.{},
    }, .{});
}

pub fn search(c: *spider.Ctx) !spider.Response {
    const query = c.query("q");

    var search_result: ?model.MovieSearchResult = null;
    if (query) |q| {
        search_result = try service.searchMovies(c.arena, c._io, q);
    }

    return c.view("movies/search", .{
        .query = query,
        .results = if (search_result) |sr| sr.results else &.{},
    }, .{});
}

pub fn popular(c: *spider.Ctx) !spider.Response {
    const popular_movies = try service.getPopularMovies(c.arena, c._io);

    return c.view("movies/popular", .{
        .movies = popular_movies.results,
        .page = popular_movies.page,
        .total_pages = popular_movies.total_pages,
    }, .{});
}

pub fn movieDetails(c: *spider.Ctx) !spider.Response {
    const movie_id_str = c.params.get("id") orelse {
        return c.text("Missing movie ID", .{});
    };

    const movie_id = std.fmt.parseInt(u32, movie_id_str, 10) catch {
        return c.text("Invalid movie ID", .{});
    };

    const movie_details = try service.getMovieDetails(c.arena, c._io, movie_id);

    return c.view("movies/details", .{
        .movie = movie_details,
    }, .{});
}
