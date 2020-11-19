use serde::{Serialize, Deserialize};
use serde_yaml;
use crate::*;

impl Target {
    pub fn load<P: AsRef<Path>>(path: P) -> Target {
        let f = fs::File::open(path.as_ref())
            .expect("could not open target file");
        let r = io::BufReader::new(f);
        serde_yaml::from_reader(r)
            .expect("could not read target file")
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Target {
    /// Run the experiment on this remote target (ssh destination)
    pub remote: Remote,

    /// C/C++ compiler on the remote target
    #[serde(rename = "remote-cc")]
    pub remote_cc: String,

    /// Target processor kind, CPU or GPU?
    pub kind: TargetKind,

    /// The size of vectors that should be used
    #[serde(rename = "vector-width")]
    pub vector_width: u16,

    /// Command to run on the target before measuring
    #[serde(rename = "before-measuring")]
    pub before_measuring: Option<String>,
    /// Command to run on the target after measuring
    #[serde(rename = "after-measuring")]
    pub after_measuring: Option<String>,

    /// CPU affinity for the benchmark
    #[serde(rename = "cpu-affinity")]
    pub cpu_affinity: Option<String>,

    /// OpenCL platform name substring
    #[serde(rename = "ocl-platform-name")]
    pub ocl_platform_name: String,

    /// Halide target string
    pub halide: String,

    /// OpenCV headers directory
    #[serde(rename = "opencv-headers")]
    pub opencv_headers: String,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(from = "String", into = "String")]
pub struct Remote {
    pub dst: String,
    pub dir: PathBuf,
}

impl From<String> for Remote {
    fn from(dst: String) -> Remote {
        Remote { dst, dir: PathBuf::from("2021-CGO-experiment") }
    }
}

impl From<Remote> for String {
    fn from(r: Remote) -> String {
        r.dst
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub enum TargetKind {
    #[serde(rename = "cpu")]
    CPU,
    #[serde(rename = "gpu")]
    GPU,
}
