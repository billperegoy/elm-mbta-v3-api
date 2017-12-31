module Model exposing (..)

import Time
import Http
import Predictions exposing (..)


type alias Model =
    { predictions : Prediction
    , error : String
    }


type alias StopAttributes =
    { wheelchairBoarding : String
    , name : String
    , longitude : String
    , latitude : String
    }


type alias StopInclude =
    { resourceType : String
    , id : String
    , attributes : StopAttributes
    }


type Msg
    = NoOp
    | GetPredictions Time.Time
    | ProcessResponse (Result Http.Error Prediction)
