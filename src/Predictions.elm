module Predictions exposing (..)

import Time
import Http
import Date
import Routes exposing (..)
import JsonApi exposing (..)


type alias Prediction =
    { jsonApi : JsonApi
    , data : List PredictionElement
    , included : List RouteInclude
    }


type alias PredictionElement =
    { id : String
    , relationships : Relationships
    , attributes : PredictionAttributes
    }


type alias Relationships =
    { trip : RelationshipElement
    , stop : RelationshipElement
    , route : RelationshipElement
    }


type alias RelationshipData =
    { relationshipType : String
    , id : String
    }


type alias RelationshipElement =
    { data : RelationshipData
    }


type alias PredictionAttributes =
    { track : Maybe String
    , stopSuquence : Maybe Int
    , status : Maybe String
    , scheduleRelationShip : Maybe String
    , directionId : Int
    , departureTime : Maybe Date.Date
    , arrivalTime : Maybe Date.Date
    }
