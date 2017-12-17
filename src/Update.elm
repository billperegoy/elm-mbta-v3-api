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



-- Add stop to include list to break things


get : Cmd Msg
get =
    Http.send ProcessResponse (Http.get url decoder)


decoder : Decoder Prediction
decoder =
    decode Prediction
        |> required "data" predictionElementListDecoder
        |> required "included" routeIncludeListDecoder


predictionElementListDecoder : Decoder (List PredictionElement)
predictionElementListDecoder =
    list predictionElementDecoder


predictionElementDecoder : Decoder PredictionElement
predictionElementDecoder =
    decode PredictionElement
        |> required "id" string
        |> required "relationships" relationshipsDecoder
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


routeIncludeListDecoder : Decoder (List RouteInclude)
routeIncludeListDecoder =
    list routeIncludeDecoder


routeIncludeDecoder : Decoder RouteInclude
routeIncludeDecoder =
    decode RouteInclude
        |> required "type" string
        |> required "id" string
        |> required "attributes" routeAttributesDecoder



-- Thie line above needs to be a one-of to choose between the
-- different include types


stopIncludeListDecoder : Decoder (List StopInclude)
stopIncludeListDecoder =
    list stopIncludeDecoder


stopIncludeDecoder : Decoder StopInclude
stopIncludeDecoder =
    decode StopInclude
        |> required "type" string
        |> required "id" string
        |> required "attributes" stopAttributesDecoder


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


stopAttributesDecoder : Decoder StopAttributes
stopAttributesDecoder =
    decode StopAttributes
        |> required "wheelchair_boarding" string
        |> required "name" string
        |> required "longitude" string
        |> required "latitude" string


relationshipDataDecoder : Decoder RelationshipData
relationshipDataDecoder =
    decode RelationshipData
        |> required "type" string
        |> required "id" string


relationshipElementDecoder : Decoder RelationshipElement
relationshipElementDecoder =
    decode RelationshipElement
        |> required "data" relationshipDataDecoder


relationshipsDecoder : Decoder Relationships
relationshipsDecoder =
    decode Relationships
        |> required "trip" relationshipElementDecoder
        |> required "stop" relationshipElementDecoder
        |> required "route" relationshipElementDecoder
