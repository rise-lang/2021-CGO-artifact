pub use std::{fs, io, fmt, ffi};
pub use io::Write;
pub use std::path::{Path, PathBuf};
pub use colored::*;
pub use command::*;
pub use target::*;
pub use env::Env;

mod command;
mod target;
mod env;
mod collect;
mod benchmark;
mod codegen;

fn main() {
    env::setup(|env| {
        if env.codegen {
            codegen::halide(env);
            codegen::rise(env);
        }

        if env.benchmark {
            collect::info(&env);
            collect::hardware_info(&env);

            benchmark::harris(&env);
        }
    });
}