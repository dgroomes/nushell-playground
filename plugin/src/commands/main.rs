use nu_plugin::{EngineInterface, EvaluatedCall, SimplePluginCommand};
use nu_protocol::{Category, LabeledError, Signature, Value};

use crate::MyPlugin;

pub struct Main;

impl SimplePluginCommand for Main {
    type Plugin = MyPlugin;

    fn name(&self) -> &str {
        "my"
    }

    fn description(&self) -> &str {
        "The 'my' command is my example Nushell plugin"
    }

    fn signature(&self) -> Signature {
        Signature::build(self.name())
            .category(Category::Custom("my-plugin".into()))
    }

    fn run(
        &self,
        _plugin: &Self::Plugin,
        engine: &EngineInterface,
        call: &EvaluatedCall,
        _input: &Value,
    ) -> Result<Value, LabeledError> {
        Ok(Value::string(engine.get_help()?, call.head))
    }
}