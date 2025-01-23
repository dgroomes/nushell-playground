use nu_plugin::{Plugin, PluginCommand};

mod commands;

pub use commands::*;

#[derive(Debug)]
pub struct MyPlugin;

impl MyPlugin {
    pub fn new() -> Self {
        MyPlugin
    }
}

impl Plugin for MyPlugin {
    fn version(&self) -> String {
        env!("CARGO_PKG_VERSION").into()
    }

    fn commands(&self) -> Vec<Box<dyn PluginCommand<Plugin = Self>>> {
        vec![Box::new(Main), Box::new(Hello)]
    }
}
