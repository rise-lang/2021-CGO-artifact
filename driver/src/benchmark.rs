use crate::*;

pub fn harris(env: &Env) {
    let (ref mut log, ref mut res) = benchmark_result(&env);

    if let Some(ref cmd) = env.target.before_measuring {
        target_run(cmd).log(log, &env).unwrap();
    }

    target_run("mkdir").arg("-p").arg(env.remote_bin)
        .log(log, &env).unwrap();
    upload_file_to(&Path::new("driver").join("cpp"), "src")
        .log(log, &env).unwrap();

    let halide_path = env.lib.join("halide");
    let polymage_path = env.lib.join("polymage");

    upload_file(&halide_path.join("include").join("HalideRuntime.h"))
        .log(log, env).expect("could not upload Halide headers");
    upload_file(&halide_path.join("include").join("HalideBuffer.h"))
        .log(log, env).expect("could not upload Halide headers");
    upload_file(&halide_path.join("tools").join("halide_image_io.h"))
        .log(log, env).expect("could not upload Halide headers");
    upload_file(&halide_path.join("apps").join("images").join("rgb.png"))
        .log(log, env).expect("could not upload Halide images");

    upload_file(&polymage_path.join("images").join("venice_wikimedia.jpg"))
        .log(log, env).expect("could not upload Polymage images");

    let halide_harris = halide_path.join("apps").join("harris");
    upload_file_to(&halide_harris.join("bin").join(&env.target.halide),
                   "halide-gen")
        .log(log, env).expect("could not upload harris files");

    let rise_n_shine_path = env.lib.join("harris-rise-and-shine");
    let gen_path = rise_n_shine_path.join("gen");
    upload_file_to(&gen_path, "shine-gen")
        .log(log, env).unwrap();

    upload_file(Path::new("lift-gen"))
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
        .arg("-I").arg("/usr/local/include/opencv4")
        .arg("-no-pie")
        .arg("-fdiagnostics-color")
        .arg("-O2").arg("-lstdc++").arg("-std=c++14")
        .arg("-lm").arg("-lpthread").arg("-ldl").arg("-lpng").arg("-ljpeg")
        .arg("-lOpenCL").arg("-fopenmp")
        .arg("-lopencv_core").arg("-lopencv_imgproc")
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
    let output1 = if let Some(ref cpu_a) = env.target.cpu_affinity {
        target_run("taskset").arg("-c").arg(cpu_a).arg(bin)
            .arg("lib/halide/apps/images/rgb.png")
            .arg(&env.target.ocl_platform_name).arg(device_type_str).arg("30")
            .arg("harris.png")
            .envs(envs.iter().cloned())
            .log(log, env).unwrap()
    } else {
        target_run(bin)
            .arg("lib/halide/apps/images/rgb.png")
            .arg(&env.target.ocl_platform_name).arg(device_type_str).arg("30")
            .arg("harris.png")
            .log(log, env).unwrap()
    };
    record_result(&output1, res);
    let output2 = if let Some(ref cpu_a) = env.target.cpu_affinity {
        target_run("taskset").arg("-c").arg(cpu_a).arg(bin)
            .arg("lib/polymage/images/venice_wikimedia.jpg")
            .arg(&env.target.ocl_platform_name).arg(device_type_str).arg("30")
            .arg("venice_harris.jpg")
            .envs(envs.iter().cloned())
            .log(log, env).unwrap()
    } else {
        target_run(bin)
            .arg("lib/polymage/images/venice_wikimedia.jpg")
            .arg(&env.target.ocl_platform_name).arg(device_type_str).arg("30")
            .arg("venice_harris.jpg")
            .log(log, env).unwrap()
    };
    record_result(&output2, res);

    if let Some(ref cmd) = env.target.after_measuring {
        target_run(cmd).log(log, &env).unwrap();
    }
}

fn benchmark_result(env: &Env) -> (fs::File, fs::File) {
    let path = env.results.join("benchmark");
    println!("{} -> {}[.data]", "-- benchmarking".yellow(), path.to_str().unwrap());
    (fs::File::create(&path).unwrap(),
     fs::File::create(path.with_extension("data")).unwrap())
}

fn record_result(out: &str, res: &mut fs::File) {
    let mut sp = out.split_whitespace();
    while let Some(size) = sp.next() {
        let generator = sp.next().unwrap();
        let variant = sp.next().unwrap();
        let med = sp.next().unwrap();
        let min = sp.next().unwrap();
        let max = sp.next().unwrap();
        println!("[{}] {:8} {:12}: {:6} median ms [{:6} - {:6}]", size, generator, variant, med, min, max);
    }
    write!(res, "{}", out).unwrap();
}
