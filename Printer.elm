module Main exposing (..)

import Html exposing (div, text, table, th, tr, td, textarea, input)
import Html.Attributes exposing (class)
import Html.Events exposing (on, onInput)
import Json.Decode exposing (..)

-- MODEL

type alias Model = { input: String }

init: Model
init = { input = """{ "x": 5 }""" }

--  MESSAGE

type Msg 
    = ChangeText String

--  UPDATE
update: Msg -> Model -> Model 
update msg model = 
    case msg of
        ChangeText s -> { model | input = s }

-- VIEW
view: Model -> Html.Html Msg
view model = 
    div [] [ textarea [onInput ChangeText] [ text (model.input) ]
             , text "Hello"
           ]

onChange : (String -> Msg) -> Html.Attribute Msg
onChange msg = 
    on "input" (map msg decodeTextArea)

decodeTextArea : Decoder String
decodeTextArea = field "value" string

---------------

type JsonModel
    = JsonNull
    | JsonBool Bool
    | JsonString String
    | JsonNumber Float
    | JsonObject (List (String, JsonModel))
    | JsonList (List JsonModel)

testCase = JsonList [
                JsonNull,
                JsonBool False,
                JsonString "Hello Meetup!!!",
                JsonNumber 123,
                JsonObject [
                    ("x", JsonNumber 12),
                    ("y", JsonString "test")
                ]
            ]



render json = 
    case json of
        JsonNull -> div [] [ text "null" ]
        JsonBool b -> div [] [ text (toString b)  ]
        JsonString s -> div [] [ text s ]
        JsonNumber n -> div [] [ text (toString n) ]
        JsonObject o -> 
            table [class "table table-bordered"] 
                (o |> List.map(\(name, value) -> tr [] [
                    th [] [ text name ],
                    td [] [ render value ]
                ]))
        JsonList l -> 
            table [class "table table-bordered"] (
                List.map (\item -> tr [] [ td [] [ render item ] ]) l
            )

-- -- tryResult: a -> (a -> Result error b) -> (a -> Result error b) -> Result error b
-- tryResult value first next = 
--     case first value of
--         Ok a -> Ok a
--         Err _ -> case next value of
--                     Ok b -> Ok b
--                     Err x -> Err x

-- tryDecode s =
--     s
--     |> tryResult (\xdecodeString int) 
--     decodeString int s 
--     |> Result.map toString
--     -- |> Result.andThen (decodeString string)
--     |> Result.withDefault "Error"
--         -- Ok v -> toString v
--         -- Err _ -> case decodeString string s of
--         --         Ok s -> s
--         --         Err _ -> "Error"

-- tryDecode "123"
-- tryDecode "\"Hello\""

-- jsonStringToJsonModel s  = 

main = 
    -- div [] [ text "Hello" ]
    -- render testCase
    Html.beginnerProgram ({ model = init, view = view, update = update })
    -- Html.beginnerProgram
