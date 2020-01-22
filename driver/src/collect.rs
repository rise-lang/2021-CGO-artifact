use crate::*;

pub fn info(env: &Env) {
    let f = &mut collection_result("info", "general information", env);

    writeln!(f, "{:?}", env).unwrap();
    let _ = host_run("date").log(f, env);
    let _ = host_run("hostname").log(f, env);
    let _ = target_run("hostname").log(f, env);
    let _ = host_run("clang").arg("--version").log(f, env);
    let _ = target_run(&env.target.remote_cc).arg("--version").log(f, env);
    let _ = host_run("which").arg("sbt").log(f, env);
    let _ = host_run("java").arg("-version").log(f, env);
    let _ = host_run("R").arg("--version").log(f, env);
    let _ = host_run("git").arg("--version").log(f, env);
    let _ = host_run("git").args(&["show", "-s", "--color"]).log(f, env);
    let _ = host_run("git").args(&["diff", "--color"]).log(f, env);
}

pub fn hardware_info(env: &Env) {
    let f = &mut collection_result("hwinfo", "hardware information", env);

    let _ = target_run("lscpu").log(f, env);
    let _ = target_run("clinfo").log(f, env);
}

fn collection_result(name: &str, desc: &str, env: &Env) -> fs::File {
    let path = env.results.join(name);
    println!("{} -> {}", format!("-- collecting {}", desc).yellow(), path.to_str().unwrap());
    fs::File::create(path).unwrap()
}