use nu_plugin::{EngineInterface, EvaluatedCall, PluginCommand};
use nu_protocol::{Category, LabeledError, PipelineData, Signature, Value};

use crate::MyPlugin;

pub struct Hello;

impl PluginCommand for Hello {
    type Plugin = MyPlugin;

    fn name(&self) -> &str {
        "my hello"
    }

    fn signature(&self) -> Signature {
        Signature::build(self.name())
            .description(self.description())
            .category(Category::Custom("my-plugin".into()))
    }

    fn description(&self) -> &str {
        "Runs 'print hello' by way of destructuring the 'print' command and the 'hello' argument'"
    }

    fn extra_description(&self) -> &str {
        r#"
A "hello world"-style Nushell command that helps me to learn and explore Nushell plugin development.
Consider moving this into https://github.com/dgroomes/nushell-playground
"#
    }

    fn run(
        &self,
        _plugin: &MyPlugin,
        engine: &EngineInterface,
        call: &EvaluatedCall,
        _input: PipelineData,
    ) -> Result<PipelineData, LabeledError> {
        // To debug Nushell plugin commands, just print to stderr. It will appear in the console.
        eprintln!("[my hello] Inside the 'run' function");

        let print_decl_id = engine
            .find_decl("print")?
            .ok_or_else(|| LabeledError::new("Unexpectedly could not find 'print' command"))?;

        let mut new_call = EvaluatedCall::new(call.head);
        new_call.add_positional(Value::string("hello", call.head));

        Ok(engine.call_decl(print_decl_id, new_call, PipelineData::Empty, true, false)?)
    }
}
