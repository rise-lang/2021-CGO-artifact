#pragma once

#include <chrono>
#include <functional>
#include <limits>

// Clock template copied from Halide tools
// Prefer high_resolution_clock if it's steady...
template <bool HighResIsSteady = std::chrono::high_resolution_clock::is_steady>
struct ClockT {
    using type = std::chrono::high_resolution_clock;
};

// ...otherwise use steady_clock.
template <>
struct ClockT<false> {
    using type = std::chrono::steady_clock;
};

using Clock = ClockT<>::type;