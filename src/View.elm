module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Date


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text model.error ]
        , h1 [] [ text "South Station Commuter Rail" ]
        , h2 [] [ text "Departures" ]
        , table [ class "table" ]
            [ tableHeader
            , tbody []
                (commuterRail 0 model.predictions.data)
            ]
        , h2 [] [ text "Arrivals" ]
        , table [ class "table" ]
            [ tableHeader
            , tbody []
                (commuterRail 1 model.predictions.data)
            ]
        ]


commuterRail : Int -> List PredictionElement -> List (Html Msg)
commuterRail direction data =
    List.filter (\e -> String.startsWith "CR-" e.relationships.route.data.id)
        data
        |> List.filter (\prediction -> prediction.attributes.directionId == direction)
        |> List.sortWith (sortByDate direction)
        |> List.map (\prediction -> displayPrediction prediction direction)


sortByDate : Int -> PredictionElement -> PredictionElement -> Order
sortByDate direction elem1 elem2 =
    let
        a =
            if direction == 0 then
                elem1.attributes.departureTime
            else
                elem1.attributes.arrivalTime

        b =
            if direction == 0 then
                elem2.attributes.departureTime
            else
                elem1.attributes.arrivalTime
    in
        case ( a, b ) of
            ( Nothing, _ ) ->
                EQ

            ( _, Nothing ) ->
                EQ

            ( Just x, Just y ) ->
                compare (Date.toTime x) (Date.toTime y)


displayPrediction : PredictionElement -> Int -> Html Msg
displayPrediction prediction direction =
    let
        time =
            if direction == 0 then
                prediction.attributes.departureTime
            else
                prediction.attributes.arrivalTime

        timeFormatted =
            case time of
                Nothing ->
                    "-"

                Just t ->
                    let
                        minute =
                            if (Date.minute t) < 10 then
                                "0" ++ (Date.minute t |> toString)
                            else
                                (Date.minute t |> toString)
                    in
                        (Date.hour t |> toString) ++ ":" ++ minute
    in
        tr []
            [ td [] [ text prediction.relationships.route.data.id ]
            , td [] [ text (Maybe.withDefault "-" prediction.attributes.status) ]
            , td [] [ text (Maybe.withDefault "-" prediction.attributes.track) ]
            , td [] [ text timeFormatted ]
            ]


tableHeader : Html Msg
tableHeader =
    thead []
        [ th [] [ text "Route" ]
        , th [] [ text "Status" ]
        , th [] [ text "Track" ]
        , th [] [ text "Time" ]
        ]


findRoute : Prediction -> String
findRoute prediction =
    List.filter (\resource -> resource.resourceType == "route") prediction.included
        |> List.map (\e -> e.attributes.description)
        |> List.head
        |> Maybe.withDefault "unknown"
