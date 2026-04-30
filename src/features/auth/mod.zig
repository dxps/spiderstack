pub const spider = @import("spider");
pub const model = @import("model.zig");
pub const repository = @import("repository.zig");
pub const presenter = @import("presenter.zig");
pub const service = @import("service.zig");
pub const use_case = @import("use_case/index.zig");
pub const controller = @import("controller.zig");

const std = @import("std");
const google = spider.google;

pub fn getGoogleConfig() google.GoogleConfig {
    return .{
        .client_id = spider.env.getOr("GOOGLE_CLIENT_ID", ""),
        .client_secret = spider.env.getOr("GOOGLE_CLIENT_SECRET", ""),
        .redirect_uri = spider.env.getOr("GOOGLE_REDIRECT_URI", "http://localhost:3000/auth/google/callback"),
    };
}

pub const index = controller.index;
pub const redirectToGoogle = controller.redirectToGoogle;
pub const googleCallback = controller.googleCallback;
pub const handleLogin = controller.handleLogin;
