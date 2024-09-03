const std = @import("std");

pub fn build(b: *std.Build) void {
    const target_query = b.standardTargetOptionsQueryOnly(.{});
    const optimize = b.standardOptimizeOption(.{});

    const target = b.resolveTargetQuery(target_query);

    var bin_name: []const u8 = undefined;
    switch (target.result.os.tag) {
        .macos => bin_name = "christmas-mac",
        .linux => bin_name = "christmas-linux",
        .windows => bin_name = "christmas",
        else => bin_name = "christmas",
    }

    const exe = b.addExecutable(.{
        .name = bin_name,
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
