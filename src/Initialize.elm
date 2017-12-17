module Initialize exposing (init)

import Model exposing (..)
import Update


init : ( Model, Cmd Msg )
init =
    { error = ""
    , predictions =
        { jsonApi = { version = "-" }
        , data = []
        , included = []
        }
    }
        ! [ Update.get ]
