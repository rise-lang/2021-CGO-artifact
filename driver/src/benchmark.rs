use crate::*;

pub fn camera_pipe(env: &Env) {
    let (ref mut log, ref mut res) =
        benchmark_result("camera_pipe", "camera raw pipeline", &env);

    let halide_camera_pipe = env.lib.join("halide")
        .join("apps").join("camera_pipe");
    host_run("make").arg(format!("bin/{}/camera_pipe.a", env.target.halide))
        .current_dir(&halide_camera_pipe)
        .log(log, env).expect("could not build camera pipe");
    host_run("make").arg(format!("bin/{}/camera_pipe_auto_schedule.a", env.target.halide))
        .current_dir(&halide_camera_pipe)
        .log(log, env).expect("could not build camera pipe");
    upload_file_to(&halide_camera_pipe.join("bin").join(&env.target.halide),
                   "halide-gen")
        .log(log, env).expect("could not upload camera pipe files");

    println!("camera pipe, rise and shine!");
    let rise_n_shine_path = env.lib.join("imgproc-rise-and-shine");
    let gen_path = rise_n_shine_path.join("gen").join(&env.target_name);
    let output = host_run("sbt").arg("run")
        .current_dir(&rise_n_shine_path)
        .log(log, env).expect("could not compile Rise & Shine executable");
    let code = output.split(">>> GENERATED CODE <<<").nth(1)
        .expect("could not find start of generated code")
        .split("<<< CODE GENERATED >>>").nth(0)
        .expect("could not find end of generated code");
    let path = gen_path.join("camera_pipe").with_extension("c");
    {
        let mut f = fs::File::create(&path).unwrap();
        f.write_fmt(format_args!(r#"
#include "shine_header.h"
{}
"#, code)).unwrap();
    }

    upload_file_to(&gen_path, "shine-gen")
        .log(log, env).unwrap();

    if target_run(&env.target.remote_cc)
        .arg("shine-gen/camera_pipe.c")
        .arg("-I").arg("src")
        .arg("-no-pie")
        .arg("-fdiagnostics-color")
        .arg("-Ofast")
        .arg("-fopenmp")
        .arg("-lm")
        .arg("-c").arg("-o").arg("shine-gen/camera_pipe.o")
        .log(log, env).is_none()
    {
        return;
    }

    let bin = &format!("{}/camera_pipe", env.remote_bin);
    if target_run(&env.target.remote_cc)
        .arg("src/camera_pipe.cpp")
        .arg("shine-gen/camera_pipe.o")
        .arg("halide-gen/camera_pipe.a")
        .arg("halide-gen/camera_pipe_auto_schedule.a")
        .arg("-I").arg("src")
        .arg("-I").arg("halide-gen")
        .arg("-I").arg("lib/halide/include")
        .arg("-I").arg("lib/halide/tools")
        .arg("-no-pie")
        .arg("-fdiagnostics-color")
        .arg("-O2").arg("-lstdc++").arg("-std=c++14")
        .arg("-fopenmp")
        .arg("-lm").arg("-lpthread").arg("-ldl").arg("-lpng").arg("-ljpeg")
        .arg("-o").arg(bin)
        .log(log, env).is_none()
    {
        return;
    }

    let envs = match env.target.kind {
        TargetKind::GPU => vec![
            ("HL_OCL_DEVICE_TYPE", "gpu"),
            ("HL_OCL_PLATFORM_NAME", &env.target.ocl_platform_name)
        ],
        TargetKind::CPU => vec![]
    };
    if let Some(ref cpu_a) = env.target.cpu_affinity {
        target_run("taskset").arg("-c").arg(cpu_a).arg(bin)
            .arg("lib/halide/apps/images/bayer_raw.png")
            .arg("3700").arg("2.0").arg("50").arg("1.0").arg("5")
            .arg("camera_pipe.png")
            .envs(envs)
            .log(log, env).unwrap();
    } else {
        // TODO: heap allocation instead of stack
        /*
        target_run(bin)
            .arg("lib/halide/apps/images/bayer_raw.png")
            .arg("3700").arg("2.0").arg("50").arg("1.0").arg("5")
            .arg("camera_pipe.png")
            */
        target_run("sh").arg("-c").arg(format!("ulimit -s 1000000 && {} lib/halide/apps/images/bayer_raw.png 3700 2.0 50 1.0 5 camera_pipe.png", bin))
            .envs(envs)
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
