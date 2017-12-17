module View exposing (view)

import Html exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.error ]
        , ul [] (List.map displayPrediction model.predictions.data)
        ]


displayPrediction : PredictionElement -> Html Msg
displayPrediction prediction =
    li [] [ text prediction.id ]


findRoute : Prediction -> String
findRoute prediction =
    List.filter (\resource -> resource.resourceType == "route") prediction.included
        |> List.map (\e -> e.attributes.description)
        |> List.head
        |> Maybe.withDefault "unknown"
