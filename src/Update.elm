module Update exposing (update)

import Model exposing (..)
import Predictions.Http


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        GetPredictions time ->
            model ! [ Predictions.Http.get ]

        ProcessResponse (Ok response) ->
            { model
                | predictions = response
                , error = ""
            }
                ! []

        ProcessResponse (Err error) ->
            { model | error = toString error } ! []
