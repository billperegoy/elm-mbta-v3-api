module Initialize exposing (init)

import Model exposing (..)
import Predictions.Http


init : ( Model, Cmd Msg )
init =
    { error = ""
    , predictions =
        { jsonApi = { version = "-" }
        , data = []
        , included = []
        }
    }
        ! [ Predictions.Http.get ]
