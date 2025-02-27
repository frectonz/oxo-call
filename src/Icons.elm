module Icons exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


emptySvg : Html msg
emptySvg =
    svg [ width "200", height "200", viewBox "0 0 200 200", fill "none" ]
        [ g [ Svg.Attributes.clipPath "url(#clip0_6_30)" ] [ rect [ width "200", height "200", fill "#7C3AED" ] [], Svg.path [ fillRule "evenodd", clipRule "evenodd", d "M74 25C46.3858 25 24 47.3858 24 75V125C24 152.614 46.3858 175 74 175H124C151.614 175 174 152.614 174 125V75C174 47.3858 151.614 25 124 25H74ZM99 50C71.3858 50 49 72.3858 49 100C49 127.614 71.3858 150 99 150C126.614 150 149 127.614 149 100C149 72.3858 126.614 50 99 50Z", fill "white", fillOpacity "0.2" ] [], rect [ x "29.3553", y "64.6447", width "50", height "150", rx "8", transform "rotate(-45 29.3553 64.6447)", fill "white", fillOpacity "0.2" ] [], rect [ x "64.7107", y "170.711", width "50", height "150", rx "8", transform "rotate(-135 64.7107 170.711)", fill "white", fillOpacity "0.2" ] [] ]
        , defs [] [ Svg.clipPath [ id "clip0_6_30" ] [ rect [ width "200", height "200", fill "white" ] [] ] ]
        ]


oSvg : Html msg
oSvg =
    svg [ width "200", height "200", viewBox "0 0 200 200", fill "none" ]
        [ rect [ width "200", height "200", fill "#7C3AED" ] []
        , Svg.path [ fillRule "evenodd", clipRule "evenodd", d "M74 25C46.3858 25 24 47.3858 24 75V125C24 152.614 46.3858 175 74 175H124C151.614 175 174 152.614 174 125V75C174 47.3858 151.614 25 124 25H74ZM99 50C71.3858 50 49 72.3858 49 100C49 127.614 71.3858 150 99 150C126.614 150 149 127.614 149 100C149 72.3858 126.614 50 99 50Z", fill "white" ] []
        ]


xSvg : Html msg
xSvg =
    svg [ width "200", height "200", viewBox "0 0 200 200", fill "none" ]
        [ g [ Svg.Attributes.clipPath "url(#clip0_1_2)" ] [ rect [ width "200", height "200", fill "#7C3AED" ] [], rect [ x "29.3553", y "64.6447", width "50", height "150", rx "8", transform "rotate(-45 29.3553 64.6447)", fill "white" ] [], rect [ x "64.7107", y "170.711", width "50", height "150", rx "8", transform "rotate(-135 64.7107 170.711)", fill "white" ] [] ]
        , defs [] [ Svg.clipPath [ id "clip0_1_2" ] [ rect [ width "200", height "200", fill "white" ] [] ] ]
        ]


restSvg : Html msg
restSvg =
    svg [ width "200", height "200", viewBox "0 0 200 200", fill "none" ]
        [ rect [ width "200", height "200", fill "#7C3AED" ] []
        , Svg.path [ fillRule "evenodd", clipRule "evenodd", d "M99 175C132.028 175 160.07 153.651 170.078 124H142.874C134.38 139.495 117.917 150 99 150C71.3858 150 49 127.614 49 100C49 72.3858 71.3858 50 99 50C113.484 50 126.53 56.1586 135.661 66H126.751L151 108L175.249 66H165.869C153.471 41.6664 128.182 25 99 25C57.5786 25 24 58.5786 24 100C24 141.421 57.5786 175 99 175Z", fill "white" ] []
        ]


logoSvg : Html msg
logoSvg =
    svg [ width "600", height "200", viewBox "0 0 600 200", fill "none" ]
        [ rect [ width "600", height "200", fill "#7C3AED" ] []
        , g [ Svg.Attributes.clipPath "url(#clip0_3_17)" ] [ rect [ width "200", height "200", transform "translate(200)", fill "#7C3AED" ] [], rect [ x "229.355", y "64.6447", width "50", height "150", rx "8", transform "rotate(-45 229.355 64.6447)", fill "white" ] [], rect [ x "264.711", y "170.711", width "50", height "150", rx "8", transform "rotate(-135 264.711 170.711)", fill "white" ] [] ]
        , rect [ width "200", height "200", fill "#7C3AED" ] []
        , Svg.path [ fillRule "evenodd", clipRule "evenodd", d "M74 25C46.3858 25 24 47.3858 24 75V125C24 152.614 46.3858 175 74 175H124C151.614 175 174 152.614 174 125V75C174 47.3858 151.614 25 124 25H74ZM99 50C71.3858 50 49 72.3858 49 100C49 127.614 71.3858 150 99 150C126.614 150 149 127.614 149 100C149 72.3858 126.614 50 99 50Z", fill "white" ] []
        , rect [ width "200", height "200", transform "translate(400)", fill "#7C3AED" ] []
        , Svg.path [ fillRule "evenodd", clipRule "evenodd", d "M474 25C446.386 25 424 47.3858 424 75V125C424 152.614 446.386 175 474 175H524C551.614 175 574 152.614 574 125V75C574 47.3858 551.614 25 524 25H474ZM499 50C471.386 50 449 72.3858 449 100C449 127.614 471.386 150 499 150C526.614 150 549 127.614 549 100C549 72.3858 526.614 50 499 50Z", fill "white" ] []
        , defs [] [ Svg.clipPath [ id "clip0_3_17" ] [ rect [ width "200", height "200", fill "white", transform "translate(200)" ] [] ] ]
        ]
