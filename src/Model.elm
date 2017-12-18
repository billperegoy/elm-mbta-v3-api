module Model exposing (..)

import Time
import Http
import Date


type alias Prediction =
    { jsonApi : JsonApi
    , data : List PredictionElement
    , included : List RouteInclude
    }


type ResourceInclude
    = RouteResource RouteInclude
    | StopResource StopInclude


type alias PredictionElement =
    { id : String
    , relationships : Relationships
    , attributes : PredictionAttributes
    }


type alias RelationshipData =
    { relationshipType : String
    , id : String
    }


type alias RelationshipElement =
    { data : RelationshipData
    }


type alias Relationships =
    { trip : RelationshipElement
    , stop : RelationshipElement
    , route : RelationshipElement
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


type alias RouteAttributes =
    { routeType : Int
    , sortOrder : Int
    , shortName : String
    , longName : String
    , directionNames : List String
    , description : String
    }


type alias StopAttributes =
    { wheelchairBoarding : String
    , name : String
    , longitude : String
    , latitude : String
    }


type alias RouteInclude =
    { resourceType : String
    , id : String
    , attributes : RouteAttributes
    }


type alias StopInclude =
    { resourceType : String
    , id : String
    , attributes : StopAttributes
    }


type alias JsonApi =
    { version : String }


type alias Model =
    { predictions : Prediction
    , error : String
    }


type Msg
    = NoOp
    | GetPredictions Time.Time
    | ProcessResponse (Result Http.Error Prediction)
