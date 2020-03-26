use crate::*;

pub fn harris(env: &Env) {
    let (ref mut log, ref mut res) =
        benchmark_result("harris", "harris corner detection", &env);

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
    upload_file_to(&halide_harris.join("bin").join(&env.target.halide),
                   "halide-gen")
        .log(log, env).expect("could not upload harris files");

    println!("harris, rise & shine!");
    let rise_n_shine_path = env.lib.join("harris-rise-and-shine");
    let gen_path = rise_n_shine_path.join("gen");
    host_run("sbt").arg(format!("run {}", env.target.vector_width))
        .current_dir(&rise_n_shine_path)
        .log(log, env).expect("could not rise & shine");

    upload_file_to(&gen_path, "shine-gen")
        .log(log, env).unwrap();

    let bin = &format!("{}/harris", env.remote_bin);
    if target_run(&env.target.remote_cc)
        .arg("src/harris.cpp")
        .arg("halide-gen/harris.a")
        .arg("halide-gen/harris_auto_schedule.a")
        .arg("halide-gen/runtime.a")
        .arg("-I").arg("src")
        .arg("-I").arg("halide-gen")
        .arg("-I").arg("lib/halide/include")
        .arg("-I").arg("lib/halide/tools")
        .arg("-no-pie")
        .arg("-fdiagnostics-color")
        .arg("-O2").arg("-lstdc++").arg("-std=c++14")
        .arg("-lm").arg("-lpthread").arg("-ldl").arg("-lpng").arg("-ljpeg")
        .arg("-lOpenCL")
        .arg("-o").arg(bin)
        .log(log, env).is_none()
    {
        return;
    }

    let (envs, device_type_str) = match env.target.kind {
        TargetKind::GPU => (vec![
            ("HL_OCL_DEVICE_TYPE", "gpu"),
            ("HL_OCL_PLATFORM_NAME", &env.target.ocl_platform_name)
        ], "gpu"),
        TargetKind::CPU => (vec![], "cpu")
    };
    if let Some(ref cpu_a) = env.target.cpu_affinity {
        target_run("taskset").arg("-c").arg(cpu_a).arg(bin)
            .arg("lib/halide/apps/images/rgba.png")
            .arg(&env.target.ocl_platform_name).arg(device_type_str).arg("20")
            .arg("harris.png")
            .envs(envs)
            .log(log, env).unwrap();
    } else {
        target_run(bin)
            .arg("lib/halide/apps/images/rgba.png")
            .arg(&env.target.ocl_platform_name).arg(device_type_str).arg("20")
            .arg("harris.png")
            .log(log, env).unwrap();
    }
}

fn benchmark_result(name: &str, desc: &str, env: &Env) -> (fs::File, fs::File) {
    let path = env.results.join(name);
    println!("{} -> {}[.bench]",
             format!("-- benchmarking {}", desc).yellow(),
             path.to_str().unwrap());
    (fs::File::create(&path).unwrap(),
     fs::File::create(path.with_extension("bench")).unwrap())
}

fn record_result(name: &str, out: &str, res: &mut fs::File) {
    print!("{}: ", name.green());
    for (a, b) in out.split_whitespace().zip(&[" [", "-", "] ms"]) {
        print!("{}{}", a, b);
    }
    println!();
    write!(res, "{} {}", name, out).unwrap();
}
