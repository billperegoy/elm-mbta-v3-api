module Routes exposing (..)

import Time
import Http
import Date


type alias RouteInclude =
    { resourceType : String
    , id : String
    , attributes : RouteAttributes
    }


type alias RouteAttributes =
    { routeType : Int
    , sortOrder : Int
    , shortName : String
    , longName : String
    , directionNames : List String
    , description : String
    }
