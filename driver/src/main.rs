pub use std::{fs, io, fmt, ffi};
pub use io::Write;
pub use std::path::{Path, PathBuf};
pub use colored::*;
pub use command::*;
pub use config::*;

mod command;
mod config;
mod setup;
mod collect;
mod benchmark;

#[derive(Debug)]
pub struct Env<'a> {
    lib: &'a Path,
    results: &'a Path,
    remote_bin: &'a str,
    target_name: &'a str,
    target: &'a Target,
}

fn main() {
    setup::environment(|env| {
        if let Some(ref cmd) = env.target.before_measuring {
            target_run(cmd).log(&mut io::sink(), &env).unwrap();
        }

        collect::info(&env);
        collect::hardware_info(&env);

        benchmark::harris(&env);

        if let Some(ref cmd) = env.target.after_measuring {
            target_run(cmd).log(&mut io::sink(), &env).unwrap();
        }
    });
}