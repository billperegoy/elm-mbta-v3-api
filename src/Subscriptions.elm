module Subscriptions exposing (subscriptions)

import Model exposing (..)
import Time


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.second * 20) GetPredictions
