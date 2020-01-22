use crate::*;

use structopt::StructOpt;

#[derive(StructOpt, Debug)]
#[structopt(name = "binomial filter experiment")]
struct Opt {
    /// Target
    #[structopt(long, short)]
    target: PathBuf,
}

pub fn environment<F>(use_env: F) where F: FnOnce(&Env) {
    let opt = Opt::from_args();

    let target = &Target::load(&opt.target);
    let target_name = opt.target.file_stem().unwrap();
    let target_name_str = target_name.to_str().unwrap();
    let env = Env {
        lib: &Path::new("lib"),
        results: &Path::new("results").join(target_name),
        remote_bin: "bin",
        target_name: target_name_str,
        target
    };

    fs::create_dir_all(&env.results).unwrap();

    let path = env.results.join("setup");
    println!("{} -> {}", "-- setting environment up".yellow(), path.to_str().unwrap());
    let log = &mut fs::File::create(path).unwrap();

    command::setup(&env);
    halide(&env, log);
    shine(&env, log);

    target_run("mkdir").arg("-p").arg(env.remote_bin)
        .log(log, &env).unwrap();
    upload_file_to(&Path::new("driver").join("cpp"), "src")
        .log(log, &env).unwrap();

    use_env(&env);
}

fn halide<W: io::Write>(env: &Env, w: &mut W) {
    let halide_path = env.lib.join("halide");
    host_run("make")
        .current_dir(&halide_path)
        .log(w, env).expect("could not build Halide");

    upload_file(&halide_path.join("include").join("HalideRuntime.h"))
        .log(w, env).expect("could not upload Halide headers");
    upload_file(&halide_path.join("include").join("HalideBuffer.h"))
        .log(w, env).expect("could not upload Halide headers");
    upload_file(&halide_path.join("tools").join("halide_image_io.h"))
        .log(w, env).expect("could not upload Halide headers");
    upload_file(&halide_path.join("apps").join("images").join("bayer_raw.png"))
        .log(w, env).expect("could not upload Halide images");
}

fn shine<W: io::Write>(env: &Env, w: &mut W) {
    host_run("./setup.sh")
        .current_dir(env.lib.join("shine"))
        .log(w, env).expect("could not setup shine repository");

    let rise_n_shine_path = env.lib.join("imgproc-rise-and-shine");
    fs::create_dir_all(rise_n_shine_path.join("gen").join(&env.target_name))
        .unwrap();
}