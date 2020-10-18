L_ERROR = 0
L_WARN = 1
L_INFO = 2
L_DEBUG = 3
L_VERBOSE = 4

GLOBAL_LOG_LEVEL = 2

function log(level, message) 
    if level <= GLOBAL_LOG_LEVEL then
        console.log(message)
    end
end

function set_loglevel(level) 
    GLOBAL_LOG_LEVEL = level
end