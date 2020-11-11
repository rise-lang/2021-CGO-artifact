use std::io::prelude::*;
use std::process;
use crate::*;

pub fn setup(env: &Env) {
    if env.benchmark {
        let r = &env.target.remote;
        if !remote_output(&"mkdir", &vec!["-p", r.dir.to_str().unwrap()],
                          &[], &r.dst, Path::new("."))
            .unwrap().status.success() {
            panic!("could not create remote directory");
        }
    }
}

pub type HostCommand = std::process::Command;

pub struct TargetCommand {
    program: String,
    args: Vec<String>,
    env: Vec<(String, String)>
}

pub struct UploadCommand<'a> {
    host_path: &'a Path,
    remote_path: Option<&'a str>,
}

pub fn host_run<S: AsRef<ffi::OsStr>>(program: S) -> HostCommand {
    process::Command::new(program)
}

pub fn target_run<S: AsRef<str>>(program: S) -> TargetCommand {
    TargetCommand {
        program: program.as_ref().to_owned(),
        args: Vec::new(),
        env: Vec::new()
    }
}

pub fn upload_file<'a>(path: &'a Path) -> UploadCommand<'a> {
    UploadCommand { host_path: path, remote_path: None }
}

pub fn upload_file_to<'a>(host: &'a Path, remote: &'a str) -> UploadCommand<'a> {
    UploadCommand { host_path: host, remote_path: Some(remote) }
}

pub trait CommandExt {
    fn prompt(&self, env: &Env) -> ColoredString;
    fn output(&mut self, env: &Env) -> io::Result<process::Output>;

    #[must_use]
    fn log<W: Write>(&mut self, w: &mut W, env: &Env) -> Option<String> {
        let prompt = self.prompt(env);
        writeln!(w, "{}", prompt).unwrap();
        println!("{}", prompt);
        self.log_no_prompt(w, env)
    }

    #[must_use]
    fn log_no_println<W: Write>(&mut self, w: &mut W, env: &Env) -> Option<String> {
        let prompt = self.prompt(env);
        writeln!(w, "{}", prompt).unwrap();
        self.log_no_prompt(w, env)
    }

    #[must_use]
    fn log_no_prompt<W: Write>(&mut self, w: &mut W, env: &Env) -> Option<String> {
        match self.output(env) {
            Ok(output) => {
                if !output.status.success() {
                    let s = format!("{} ({})", "failure".red(), output.status);
                    println!("{}", s);
                    writeln!(w, "{}", s).unwrap();
                }
                let out = String::from_utf8_lossy(&output.stdout).into();
                let err = String::from_utf8_lossy(&output.stderr);

                write!(w, "{}", out).unwrap();
                if !err.is_empty() { write!(w, "!: {}", err).unwrap(); }
                if output.status.success() { Some(out) } else { None }
            }
            Err(error) => {
                let s = format!("{}: {}", "could not run command".red(), error);
                println!("{}", s);
                writeln!(w, "{}", s).unwrap();
                None
            }
        }
    }
}

impl CommandExt for HostCommand {
    fn prompt(&self, _: &Env) -> ColoredString {
        format!("h> {:?}", self).blue()
    }

    fn output(&mut self, _: &Env) -> io::Result<process::Output> {
        self.output()
    }
}

impl CommandExt for TargetCommand {
    fn prompt(&self, _: &Env) -> ColoredString {
        format!("t>{:?} {:?}{:?}", FlatDbg(&self.env), self.program, FlatDbg(&self.args)).purple()
    }

    fn output(&mut self, env: &Env) -> io::Result<process::Output> {
        let r = &env.target.remote;
        remote_output(&self.program, &self.args, &self.env, &r.dst, &r.dir)
    }
}

struct FlatDbg<I: IntoIterator + Clone>(I);
impl<I: IntoIterator<Item = E> + Clone, E: fmt::Debug> fmt::Debug for FlatDbg<I> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for e in self.0.clone().into_iter() {
            write!(f, " {:?}", e)?;
        }
        Ok(())
    }
}

impl<'a> CommandExt for UploadCommand<'a> {
    fn prompt(&self, env: &Env) -> ColoredString {
        let r = &env.target.remote;
        let remote_path = &match self.remote_path {
            Some(rp) => r.dir.join(rp),
            None => r.dir.join(self.host_path)
        };
        format!("u> {:?} --> {:?}", self.host_path, remote_path).purple()
    }

    fn output(&mut self, env: &Env) -> io::Result<process::Output> {
        let r = &env.target.remote;
        let remote_path = &match self.remote_path {
            Some(rp) => r.dir.join(rp),
            None => r.dir.join(self.host_path)
        };
        assert!(remote_output(&"mkdir", &vec!["-p", remote_path.parent().unwrap().to_str().unwrap()],
            &[], &r.dst, Path::new(".")
        ).unwrap().status.success());
        assert!(remote_output(&"rm", &vec!["-rf", remote_path.to_str().unwrap()],
                              &[], &r.dst, Path::new(".")
        ).unwrap().status.success());
        let mut cmd = process::Command::new("scp");
        cmd.arg("-r")
            .args(&["-o", "ControlMaster=auto", "-o", "ControlPersist=1m"])
            .arg(self.host_path)
            .arg(format!("{}:{:?}", r.dst, remote_path));
        // DEBUG println!("{:?}", cmd);
        cmd.output()
    }
}

fn remote_output<S: AsRef<str>>(program: &S,
                                args: &[S],
                                env: &[(S, S)],
                                dst: &str,
                                dir: &Path) -> io::Result<process::Output>
{
    let mut r = process::Command::new("ssh");
    r.args(&["-o", "ControlMaster=auto", "-o", "ControlPersist=1m"])
        .arg(dst);
    for (k, v) in env {
        r.arg("export").arg(format!("{}=\"{}\";", k.as_ref(), v.as_ref()));
    }
    let r = r.arg("cd").arg(dir).arg(";")
        .arg(program.as_ref())
        .args(args.iter().map(|a| format!("\"{}\"", a.as_ref())));
    // println!("{:?}", r);
    r.output()
}

impl TargetCommand {
    pub fn arg<S: AsRef<str>>(&mut self, s: S) -> &mut TargetCommand {
        self.args.push(s.as_ref().to_owned());
        self
    }

    pub fn args<I, S>(&mut self, i: I) -> &mut TargetCommand
        where I: IntoIterator<Item = S>, S: AsRef<str>
    {
        self.args.extend(i.into_iter().map(|a| a.as_ref().to_owned()));
        self
    }

    pub fn env<K, V>(&mut self, k: K, v: V) -> &mut TargetCommand
        where K: AsRef<str> , V: AsRef<str>
    {
        self.env.push((k.as_ref().to_owned(), v.as_ref().to_owned()));
        self
    }

    pub fn envs<I, K, V>(&mut self, i: I) -> &mut TargetCommand
        where I: IntoIterator<Item = (K, V)>,
              K: AsRef<str>, V: AsRef<str>
    {
        self.env.extend(i.into_iter().map(|(k, v)| (k.as_ref().to_owned(), v.as_ref().to_owned())));
        self
    }
}