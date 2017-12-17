module Update exposing (update, get)

import Model exposing (..)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        GetPredictions time ->
            model ! [ get ]

        ProcessResponse (Ok response) ->
            { model
                | predictions = response
                , error = ""
            }
                ! []

        ProcessResponse (Err error) ->
            { model | error = toString error } ! []


url : String
url =
    "https://api-v3.mbta.com/predictions?filter[stop]=place-sstat&sort=departure_time&include=route"


get : Cmd Msg
get =
    Http.send ProcessResponse (Http.get url decoder)


decoder : Decoder Prediction
decoder =
    decode Prediction
        |> required "data" predictionElementListDecoder
        |> required "included" resourceIncludeListDecoder


predictionElementListDecoder : Decoder (List PredictionElement)
predictionElementListDecoder =
    list predictionElementDecoder


predictionElementDecoder : Decoder PredictionElement
predictionElementDecoder =
    decode PredictionElement
        |> required "id" string
        |> required "attributes" predictionAttributesDecoder


predictionAttributesDecoder : Decoder PredictionAttributes
predictionAttributesDecoder =
    decode PredictionAttributes
        |> required "track" (nullable string)
        |> required "stop_sequence" (nullable int)
        |> required "status" (nullable string)
        |> required "schedule_relationship" (nullable string)
        |> required "direction_id" int
        |> required "departure_time" (nullable string)
        |> required "arrival_time" (nullable string)


resourceIncludeListDecoder : Decoder (List ResourceInclude)
resourceIncludeListDecoder =
    list resourceIncludeDecoder


resourceIncludeDecoder : Decoder ResourceInclude
resourceIncludeDecoder =
    decode ResourceInclude
        |> required "type" string
        |> required "id" string
        |> required "attributes" routeAttributesDecoder


routeAttributesListDecoder : Decoder (List RouteAttributes)
routeAttributesListDecoder =
    list routeAttributesDecoder


routeAttributesDecoder : Decoder RouteAttributes
routeAttributesDecoder =
    decode RouteAttributes
        |> required "type" int
        |> required "sort_order" int
        |> required "short_name" string
        |> required "long_name" string
        |> required "direction_names" (list string)
        |> required "description" string
