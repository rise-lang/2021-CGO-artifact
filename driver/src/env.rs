use crate::*;

use structopt::StructOpt;

#[derive(Debug)]
pub struct Env<'a> {
    pub lib: &'a Path,
    pub results: &'a Path,
    pub remote_bin: &'a str,
    pub target_name: &'a str,
    pub target: &'a Target,
    pub codegen: bool,
    pub benchmark: bool,
}

#[derive(StructOpt, Debug)]
#[structopt(name = "harris corner detection experiment")]
struct Opt {
    /// Target
    #[structopt(long, short)]
    target: PathBuf,

    /// Codegen?
    #[structopt(long)]
    codegen: bool,

    /// Benchmark?
    #[structopt(long)]
    benchmark: bool,
}

pub fn setup<F>(use_env: F) where F: FnOnce(&Env) {
    println!("{}", "-- setting environment up".yellow());

    let opt = Opt::from_args();

    let target = &Target::load(&opt.target);
    let target_name = opt.target.file_stem().unwrap();
    let target_name_str = target_name.to_str().unwrap();
    let env = Env {
        lib: &Path::new("lib"),
        results: &Path::new("results").join(target_name),
        remote_bin: "bin",
        target_name: target_name_str,
        target,
        codegen: opt.codegen,
        benchmark: opt.benchmark,
    };

    fs::create_dir_all(&env.results).unwrap();

    command::setup(&env);

    use_env(&env);
}