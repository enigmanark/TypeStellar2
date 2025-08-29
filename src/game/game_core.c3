module game;

import std::io;
import raylib5::rl;
import std::collections::list;
import std::core::mem;

fn void runGame() {
	io::printfn("INFO: Initializing game engine.");
    rl::initWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE);
	rl::setTargetFPS(60);
    
	GameAssets assets = gameAssetsInitAndLoad();
	GameState* current_state = initTitleState();
	List{GameEventConfig} event_pump;
	event_pump.init(mem);

	io::printfn("INFO: Engine initialized. Starting main loop.");
	while(!rl::windowShouldClose()) {
		//Run the current state
		current_state.run(&event_pump, &assets);

		//Check for engine state change events
		foreach(index, &config : event_pump) {
			if(config.event == GameEvent.CHANGE_STATE) {
				current_state.unload();
				if(config.state_to_change_to == EngineState.PLAY) {
					current_state = initPlayState();
				}
				else if(config.state_to_change_to == EngineState.TITLE) {
					current_state = initTitleState();
				}
				config.completed = true;
			}
		}

		//Now remove completed events
		foreach(index, &config : event_pump) {
			if(config.completed) {
				event_pump.remove_at(index);
			}
		}
	}

	io::printfn("INFO: Main loop terminated. Cleaning up...");
	
	event_pump.free();
	current_state.unload();
	assets.unload();
	rl::closeWindow();
	
	io::printfn("INFO: Cleanup successful. Exiting.");
}

