port module Main exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Icons
import List.Extra exposing (find, groupsOf, indexedFoldl, transpose)
import Maybe.Extra as MaybeExtra
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }



-- PORTS


port launchConfetti : () -> Cmd msg


port receiveMove : (Int -> msg) -> Sub msg



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url
    , turn : Turn
    , winner : Winner
    , cells : List Cell
    , winPosition : Maybe (List ( Int, Cell ))
    }


type Turn
    = XTurn
    | OTurn


type Winner
    = Tie
    | XWins
    | OWins
    | NotFinished


type Cell
    = X
    | O
    | Empty


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key
      , url = url
      , turn = XTurn
      , winner = NotFinished
      , cells = List.repeat 9 Empty
      , winPosition = Nothing
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UrlRequested UrlRequest
    | UrlChanged Url
    | Mark Int
    | Reset
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Reset ->
            ( { model
                | turn = XTurn
                , winner = NotFinished
                , cells = List.repeat 9 Empty
                , winPosition = Nothing
              }
            , Cmd.none
            )

        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        Mark x ->
            let
                newCells =
                    markCell x model.turn model.cells

                newTurn =
                    case model.turn of
                        XTurn ->
                            OTurn

                        OTurn ->
                            XTurn

                newWinner =
                    hasGameEneded model.turn newCells

                winPos =
                    winPosition model.turn newCells
            in
            ( { model
                | cells = newCells
                , turn = newTurn
                , winner = newWinner
                , winPosition = winPos
              }
            , case newWinner of
                XWins ->
                    launchConfetti ()

                OWins ->
                    launchConfetti ()

                Tie ->
                    Cmd.none

                NotFinished ->
                    Cmd.none
            )


markCell : Int -> Turn -> List Cell -> List Cell
markCell markPos turn cells =
    cells
        |> List.indexedMap
            (\i cell ->
                if i == markPos then
                    case cell of
                        Empty ->
                            mapTurnToCell turn

                        _ ->
                            cell

                else
                    cell
            )


mapTurnToCell : Turn -> Cell
mapTurnToCell turn =
    case turn of
        XTurn ->
            X

        OTurn ->
            O


hasGameEneded : Turn -> List Cell -> Winner
hasGameEneded turn cells =
    let
        turnValue =
            mapTurnToCell turn

        rows =
            groupsOf 3 cells
                |> List.any (List.all ((==) turnValue))

        columns =
            transpose (groupsOf 3 cells)
                |> List.any (List.all ((==) turnValue))

        forwardDiagonal =
            collectValues [ 0, 4, 8 ] cells
                |> List.all ((==) turnValue)

        backwardDiagonal =
            collectValues [ 2, 4, 6 ] cells
                |> List.all ((==) turnValue)

        gameWon =
            rows || columns || forwardDiagonal || backwardDiagonal

        tie =
            List.all ((/=) Empty) cells
    in
    if gameWon then
        case turn of
            XTurn ->
                XWins

            OTurn ->
                OWins

    else if tie then
        Tie

    else
        NotFinished


winPosition : Turn -> List Cell -> Maybe (List ( Int, Cell ))
winPosition turn cells =
    let
        turnValue =
            mapTurnToCell turn

        enumeratedCells =
            List.indexedMap (\i cell -> ( i, cell )) cells

        rows =
            groupsOf 3 enumeratedCells
                |> List.map (completedToMaybe turnValue)

        columns =
            transpose (groupsOf 3 enumeratedCells)
                |> List.map (completedToMaybe turnValue)

        forwardDiagonal =
            collectValues [ 0, 4, 8 ] enumeratedCells
                |> completedToMaybe turnValue

        backwardDiagonal =
            collectValues [ 2, 4, 6 ] enumeratedCells
                |> completedToMaybe turnValue

        winPositions =
            rows ++ columns ++ [ forwardDiagonal, backwardDiagonal ]

        winPos =
            winPositions
                |> find MaybeExtra.isJust
                |> MaybeExtra.join

        tie =
            List.all ((/=) Empty) cells
    in
    if tie then
        Just enumeratedCells

    else
        winPos


completedToMaybe : Cell -> List ( Int, Cell ) -> Maybe (List ( Int, Cell ))
completedToMaybe turnValue lst =
    let
        lstCompleted =
            List.all ((==) turnValue) (List.map (\( _, cell ) -> cell) lst)
    in
    if lstCompleted then
        Just lst

    else
        Nothing


collectValues : List Int -> List a -> List a
collectValues values list =
    indexedFoldl
        (\i cur acc ->
            if List.member i values then
                cur :: acc

            else
                acc
        )
        []
        list



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveMove Mark



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "OXO"
    , body =
        [ section
            [ class "container" ]
            [ header
                [ class "header" ]
                [ Icons.logoSvg ]
            , div
                [ class "board" ]
                (viewBoard model)
            , case model.winPosition of
                Just _ ->
                    button [ class "reset", onClick Reset ]
                        [ Icons.restSvg ]

                Nothing ->
                    div [ class "reset opacity-0" ]
                        [ Icons.restSvg ]
            ]
        ]
    }


viewBoard : Model -> List (Html Msg)
viewBoard model =
    model.cells
        |> List.indexedMap
            (\i cell ->
                let
                    isWinPos =
                        model.winPosition
                            |> Maybe.map (List.member ( i, cell ))
                            |> Maybe.withDefault False
                in
                ( i, cell, isWinPos )
            )
        |> List.map
            (\( i, cell, isWinPos ) ->
                let
                    className =
                        if isWinPos then
                            "cell shadow-2xl"

                        else
                            "cell"

                    clickMsg =
                        case model.winner of
                            NotFinished ->
                                Mark i

                            _ ->
                                NoOp
                in
                case cell of
                    Empty ->
                        button
                            [ class ("cursor-pointer " ++ className), onClick clickMsg ]
                            [ Icons.emptySvg ]

                    X ->
                        button
                            [ class ("cursor-default " ++ className) ]
                            [ Icons.xSvg ]

                    O ->
                        button
                            [ class ("cursor-default " ++ className) ]
                            [ Icons.oSvg ]
            )
