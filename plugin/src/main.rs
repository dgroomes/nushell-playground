use nu_plugin::{serve_plugin, MsgPackSerializer};
use my_plugin::{MyPlugin};

fn main() {
    // Start the plugin communication loop using MsgPack for serialization
    serve_plugin(&MyPlugin::new(), MsgPackSerializer {})
}
