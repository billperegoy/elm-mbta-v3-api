module View exposing (view)

import Html exposing (..)
import Model exposing (..)
import Utils


view : Model -> Html Msg
view model =
    h1 []
        [ text ("Hello " ++ (Utils.capitalize model.name)) ]
