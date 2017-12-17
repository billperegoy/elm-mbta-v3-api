module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text model.error ]
        , h1 [] [ text "South Station Commuter Rail" ]
        , h2 [] [ text "Departures" ]
        , table [ class "table" ]
            [ tbody []
                (commuterRail 0 model.predictions.data)
            ]
        , h2 [] [ text "Arrivals" ]
        , table [ class "table" ]
            [ tbody []
                (commuterRail 1 model.predictions.data)
            ]
        ]


commuterRail : Int -> List PredictionElement -> List (Html Msg)
commuterRail direction data =
    List.filter (\e -> String.startsWith "CR-" e.relationships.route.data.id)
        data
        |> List.filter (\prediction -> prediction.attributes.directionId == direction)
        |> List.map (\prediction -> displayPrediction prediction direction)


displayPrediction : PredictionElement -> Int -> Html Msg
displayPrediction prediction direction =
    let
        time =
            if direction == 0 then
                prediction.attributes.departureTime
            else
                prediction.attributes.arrivalTime
    in
        tr []
            [ td [] [ text prediction.id ]
            , td [] [ text prediction.relationships.route.data.id ]
            , td [] [ text (Maybe.withDefault "-" prediction.attributes.status) ]
            , td [] [ text (Maybe.withDefault "-" prediction.attributes.track) ]
            , td [] [ text (Maybe.withDefault "-" time) ]
            ]


findRoute : Prediction -> String
findRoute prediction =
    List.filter (\resource -> resource.resourceType == "route") prediction.included
        |> List.map (\e -> e.attributes.description)
        |> List.head
        |> Maybe.withDefault "unknown"
