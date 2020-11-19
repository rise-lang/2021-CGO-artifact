use crate::*;

pub fn halide(env: &Env) {
    let ref mut log = codegen_result("halide", env);

    let halide_path = env.lib.join("halide");
    host_run("make").arg("-j2")
        .current_dir(&halide_path)
        .log(log, env).expect("could not build Halide");

    let halide_harris = env.lib.join("halide")
        .join("apps").join("harris");
    host_run("make").arg(format!("bin/{}/harris.a", env.target.halide))
        .current_dir(&halide_harris)
        .log(log, env).expect("could not build harris");
    host_run("make").arg(format!("bin/{}/harris_auto_schedule.a", env.target.halide))
        .current_dir(&halide_harris)
        .log(log, env).expect("could not build harris");
    host_run("make").arg(format!("bin/{}/runtime.a", env.target.halide))
        .current_dir(&halide_harris)
        .log(log, env).expect("could not build runtime");
}

pub fn rise(env: &Env) {
    let ref mut log = codegen_result("rise", env);

    host_run("./setup.sh")
        .current_dir(env.lib.join("shine"))
        .log(log, env).expect("could not setup shine repository");

    let rise_n_shine_path = env.lib.join("harris-rise-and-shine");
    fs::create_dir_all(rise_n_shine_path.join("gen")
        .join(format!("vec{}", env.target.vector_width)))
        .expect("could not create Rise codegen directory");

    let rise_n_shine_path = env.lib.join("harris-rise-and-shine");
    host_run("sbt").arg(format!("run {}", env.target.vector_width))
        .current_dir(&rise_n_shine_path)
        .log(log, env).expect("could not rise & shine");
}

fn codegen_result(name: &str, env: &Env) -> fs::File {
    let path = env.results.join(format!("codegen-{}", name));
    println!("{} -> {}.log", format!("-- generating code with {}", name).yellow(), path.to_str().unwrap());
    fs::File::create(path.with_extension("log")).unwrap()
}