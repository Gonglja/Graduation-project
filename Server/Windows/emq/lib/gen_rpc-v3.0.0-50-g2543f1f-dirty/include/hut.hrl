-define(log(__Level, __Fmt),
        logger:__Level(__Fmt)).
-define(log(__Level, __Fmt, __Args),
        logger:__Level(__Fmt, __Args)).
-define(log(__Level, __Fmt, __Args, __Meta),
        logger:__Level(__Fmt, __Args, __Meta)).