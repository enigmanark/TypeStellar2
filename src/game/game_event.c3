module game;

enum GameEvent {
    NONE,
    CHANGE_STATE,
}

struct GameEventConfig {
    GameEvent event;
    EngineStateId state_to_change_to;
    bool completed;
}

fn GameEventConfig newEventConfig(GameEvent ev, EngineStateId state) {
    GameEventConfig config = {
        .event = ev,
        .state_to_change_to = state,
        .completed = false,
    };
    return config;
}