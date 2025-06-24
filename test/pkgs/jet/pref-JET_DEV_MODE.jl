# Preferences
# https://github.com/JuliaPackaging/Preferences.jl

# JET
# https://github.com/aviatesk/JET.jl

using Preferences
if Preferences.load_preference("JET", "JET_DEV_MODE") != true
    Preferences.set_preferences!("JET", "JET_DEV_MODE" => true)
end

using JET
@info "JET.JET_DEV_MODE" JET.JET_DEV_MODE
