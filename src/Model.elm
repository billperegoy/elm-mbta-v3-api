module Model exposing (..)

import Time
import Http


type alias Prediction =
    { data : List PredictionElement
    , included : List ResourceInclude
    }


type alias PredictionElement =
    { id : String
    , attributes : PredictionAttributes
    }


type alias PredictionAttributes =
    { track : Maybe String
    , stopSuquence : Maybe Int
    , status : Maybe String
    , scheduleRelationShip : Maybe String
    , directionId : Int
    , departureTime : Maybe String
    , arrivalTime : Maybe String
    }


type alias RouteAttributes =
    { routeType : Int
    , sortOrder : Int
    , shortName : String
    , longName : String
    , directionNames : List String
    , description : String
    }


type alias ResourceInclude =
    { resourceType : String
    , id : String
    , attributes : RouteAttributes
    }


type alias Model =
    { predictions : Prediction
    , error : String
    }


type Msg
    = NoOp
    | GetPredictions Time.Time
    | ProcessResponse (Result Http.Error Prediction)
