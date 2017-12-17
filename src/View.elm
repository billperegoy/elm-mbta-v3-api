module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text model.error ]
        , h1 [] [ text "Departures" ]
        , table [ class "table" ]
            [ tbody []
                (commuterRail 0 model.predictions.data)
            ]
        , h1 [] [ text "Arrivals" ]
        , table [ class "table" ]
            [ tbody []
                (commuterRail 1 model.predictions.data)
            ]
        ]


commuterRail : Int -> List PredictionElement -> List (Html Msg)
commuterRail direction data =
    List.filter (\e -> String.startsWith "CR-" e.relationships.route.data.id)
        data
        |> List.filter (\e -> e.attributes.directionId == direction)
        |> List.map displayPrediction


displayPrediction : PredictionElement -> Html Msg
displayPrediction prediction =
    tr []
        [ td [] [ text prediction.id ]
        , td [] [ text prediction.relationships.route.data.id ]
        , td [] [ text (Maybe.withDefault "-" prediction.attributes.status) ]
        , td [] [ text (Maybe.withDefault "-" prediction.attributes.track) ]
        ]


findRoute : Prediction -> String
findRoute prediction =
    List.filter (\resource -> resource.resourceType == "route") prediction.included
        |> List.map (\e -> e.attributes.description)
        |> List.head
        |> Maybe.withDefault "unknown"
