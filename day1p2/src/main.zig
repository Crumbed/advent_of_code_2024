const std = @import("std");
const mem = std.mem;

const print = std.debug.print;

pub fn main() !void {
    var lines = try get_file_lines();
    var left: [10000]u32 = [_]u32{0} ** 10000;
    var right: [10000]u32 = [_]u32{0} ** 10000;
    get_values(&lines, &left, &right);
    quick_sort(&left);
    quick_sort(&right);
    //calc_distance(&left, &right);
    calc_diff(&left, &right);
}

fn calc_diff(left: []u32, right: []u32) void {
    var i: usize = 0;
    var diff: u32 = 0;
    for (left) |l| {
        var found: u32 = 0;
        while (i < right.len and right[i] <= l) : (i += 1) {
            if (right[i] != l) continue;
            found += 1;
        }
        diff += l * found;
    }

    print("Difference: {d}\n", .{diff});
}

fn calc_distance(left: []u32, right: []u32) void {
    var total: u32 = 0;
    for (0..10000) |i| {
        const l = left[i];
        const r = right[i];
        total += if (l > r) l - r else r - l;
    }
    print("Total Distance: {d}", .{total});
}

fn get_values(lines: *mem.SplitIterator(u8, .any), l: []u32, r: []u32) void {
    var i: usize = 0;
    while (lines.next()) |line| : (i += 1) {
        if (line.len == 0) break;
        const left = line[0..5];
        const right = line[8..];
        l[i] = to_num(left);
        r[i] = to_num(right);
    }
}

fn to_num(str: []const u8) u32 {
    var num: u32 = 0;
    for (str) |c| {
        num = num * 10 + (c - '0');
    }
    return num;
}

// 10k lines
// line length 14 including \n
fn get_file_lines() !mem.SplitIterator(u8, .any) {
    const cwd = std.fs.cwd();
    var file = try cwd.openFile("input", .{});
    defer file.close();

    const size = 14000;
    var buf = mem.zeroes([size]u8);
    const read = try file.read(&buf);
    print("read: {d}, size was: {d}\n", .{ read, size });

    return mem.splitAny(u8, &buf, "\n");
}

fn quick_sort(arr: []u32) void {
    quick_sort_bounds(arr, 0, arr.len - 1);
}

fn quick_sort_bounds(arr: []u32, low: usize, high: usize) void {
    if (low >= high) return;
    const p = partition(arr, low, high);

    quick_sort_bounds(arr, low, @min(p, p -% 1));
    quick_sort_bounds(arr, p + 1, high);
}

fn partition(arr: []u32, low: usize, high: usize) usize {
    const pivot = arr[high];
    var i = low;

    for (low..high) |j| {
        if (arr[j] >= pivot) continue;
        mem.swap(u32, &arr[i], &arr[j]);
        i += 1;
    }

    mem.swap(u32, &arr[i], &arr[high]);
    return i;
}
