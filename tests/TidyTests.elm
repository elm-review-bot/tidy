module TidyTests exposing (suite)

import Expect exposing (Expectation)
import Test exposing (..)
import Tidy


suite : Test
suite =
    let
        table1CSV =
            """Treatment,John Smith,Jane Doe,Mary Johnson
treatmenta,  , 16, 3
treatmentb, 2, 11, 1"""
                |> Tidy.fromCSV

        table2 =
            Tidy.empty
                |> Tidy.insertColumn "Treatment" [ "treatmenta", "treatmentb" ]
                |> Tidy.insertColumn "John Smith" [ "", "2" ]
                |> Tidy.insertColumn "Jane Doe" [ "16", "11" ]
                |> Tidy.insertColumn "Mary Johnson" [ "3", "1" ]

        table3 =
            Tidy.empty
                |> Tidy.insertColumn "Treatment" []
                |> Tidy.insertColumn "John Smith" []
                |> Tidy.insertColumn "Jane Doe" []
                |> Tidy.insertColumn "Mary Johnson" []
                |> Tidy.insertRow [ ( "Treatment", "treatmenta" ), ( "John Smith", "" ), ( "Jane Doe", "16" ), ( "Mary Johnson", "3" ) ]
                |> Tidy.insertRow [ ( "Treatment", "treatmentb" ), ( "John Smith", "2" ), ( "Jane Doe", "11" ), ( "Mary Johnson", "1" ) ]

        table4 =
            Tidy.empty
                |> Tidy.insertColumn "Person" [ "John Smith", "Jane Doe", "Mary Johnson" ]
                |> Tidy.insertColumn "treatmenta" [ "", "16", "3" ]
                |> Tidy.insertColumn "treatmentb" [ "2", "11", "1" ]

        jTable1DiffKey =
            Tidy.empty
                |> Tidy.insertColumn "Key1" [ "k1", "k2", "k3", "k4" ]
                |> Tidy.insertColumn "colA" [ "a1", "a2", "a3", "a4" ]
                |> Tidy.insertColumn "colB" [ "b1", "b2", "b3", "b4" ]

        jTable1SameKey =
            Tidy.empty
                |> Tidy.insertColumn "Key" [ "k1", "k2", "k3", "k4" ]
                |> Tidy.insertColumn "colA" [ "a1", "a2", "a3", "a4" ]
                |> Tidy.insertColumn "colB" [ "b1", "b2", "b3", "b4" ]

        jTable2DiffKey =
            Tidy.empty
                |> Tidy.insertColumn "Key2" [ "k2", "k4", "k6", "k8" ]
                |> Tidy.insertColumn "colC" [ "c2", "c4", "c6", "c8" ]
                |> Tidy.insertColumn "colD" [ "d2", "d4", "d6", "d8" ]

        jTable2SameKey =
            Tidy.empty
                |> Tidy.insertColumn "Key" [ "k2", "k4", "k6", "k8" ]
                |> Tidy.insertColumn "colC" [ "c2", "c4", "c6", "c8" ]
                |> Tidy.insertColumn "colD" [ "d2", "d4", "d6", "d8" ]

        ljTableDiffKey =
            Tidy.empty
                |> Tidy.insertColumn "Key1" [ "k1", "k2", "k3", "k4" ]
                |> Tidy.insertColumn "colA" [ "a1", "a2", "a3", "a4" ]
                |> Tidy.insertColumn "colB" [ "b1", "b2", "b3", "b4" ]
                |> Tidy.insertColumn "Key2" [ "", "k2", "", "k4" ]
                |> Tidy.insertColumn "colC" [ "", "c2", "", "c4" ]
                |> Tidy.insertColumn "colD" [ "", "d2", "", "d4" ]

        ljTableSameKey =
            Tidy.empty
                |> Tidy.insertColumn "Key" [ "k1", "k2", "k3", "k4" ]
                |> Tidy.insertColumn "colA" [ "a1", "a2", "a3", "a4" ]
                |> Tidy.insertColumn "colB" [ "b1", "b2", "b3", "b4" ]
                |> Tidy.insertColumn "colC" [ "", "c2", "", "c4" ]
                |> Tidy.insertColumn "colD" [ "", "d2", "", "d4" ]

        rjTableDiffKey =
            Tidy.empty
                |> Tidy.insertColumn "Key2" [ "k2", "k4", "k6", "k8" ]
                |> Tidy.insertColumn "colC" [ "c2", "c4", "c6", "c8" ]
                |> Tidy.insertColumn "colD" [ "d2", "d4", "d6", "d8" ]
                |> Tidy.insertColumn "Key1" [ "k2", "k4", "", "" ]
                |> Tidy.insertColumn "colA" [ "a2", "a4", "", "" ]
                |> Tidy.insertColumn "colB" [ "b2", "b4", "", "" ]

        rjTableSameKey =
            Tidy.empty
                |> Tidy.insertColumn "Key" [ "k2", "k4", "k6", "k8" ]
                |> Tidy.insertColumn "colC" [ "c2", "c4", "c6", "c8" ]
                |> Tidy.insertColumn "colD" [ "d2", "d4", "d6", "d8" ]
                |> Tidy.insertColumn "colA" [ "a2", "a4", "", "" ]
                |> Tidy.insertColumn "colB" [ "b2", "b4", "", "" ]

        ijTable =
            Tidy.empty
                |> Tidy.insertColumn "NewKey" [ "k2", "k4" ]
                |> Tidy.insertColumn "colA" [ "a2", "a4" ]
                |> Tidy.insertColumn "colB" [ "b2", "b4" ]
                |> Tidy.insertColumn "colC" [ "c2", "c4" ]
                |> Tidy.insertColumn "colD" [ "d2", "d4" ]

        ojTable =
            Tidy.empty
                |> Tidy.insertColumn "NewKey" [ "k1", "k2", "k3", "k4", "k6", "k8" ]
                |> Tidy.insertColumn "colA" [ "a1", "a2", "a3", "a4", "", "" ]
                |> Tidy.insertColumn "colB" [ "b1", "b2", "b3", "b4", "", "" ]
                |> Tidy.insertColumn "colC" [ "", "c2", "", "c4", "c6", "c8" ]
                |> Tidy.insertColumn "colD" [ "", "d2", "", "d4", "d6", "d8" ]
    in
    describe "Table generation and column output conversion"
        [ describe "fromCSV"
            [ test "CSV treatment column" <|
                \_ ->
                    Tidy.strColumn "Treatment" table1CSV |> Expect.equal [ "treatmenta", "treatmentb" ]
            , test "CSV column with all items" <|
                \_ ->
                    Tidy.strColumn "Jane Doe" table1CSV |> Expect.equal [ "16", "11" ]
            , test "CSV column with missing items" <|
                \_ ->
                    Tidy.strColumn "John Smith" table1CSV |> Expect.equal [ "", "2" ]
            , test "CSV numeric output of column with all items" <|
                \_ ->
                    Tidy.numColumn "Jane Doe" table1CSV |> Expect.equal [ 16, 11 ]
            , test "CSV numeric column with missing items" <|
                \_ ->
                    Tidy.numColumn "John Smith" table1CSV |> Expect.equal [ 0, 2 ]
            , test "CSV numeric conversion of non-numeric column" <|
                \_ ->
                    Tidy.numColumn "Treatment" table1CSV |> Expect.equal [ 0, 0 ]
            ]
        , describe "programaticTables"
            [ test "addingColumns" <|
                \_ ->
                    table1CSV |> Expect.equal table2
            , test "addingRows" <|
                \_ ->
                    table1CSV |> Expect.equal table3
            , test "transposing" <|
                \_ ->
                    table4 |> Expect.equal (Tidy.transposeTable "Treatment" "Person" table2)
            ]
        , describe "leftJoins"
            [ test "leftJoinDiffKey" <|
                \_ ->
                    Tidy.leftJoin ( jTable1DiffKey, "Key1" ) ( jTable2DiffKey, "Key2" ) |> Expect.equal ljTableDiffKey
            , test "leftJoinSameKey" <|
                \_ ->
                    Tidy.leftJoin ( jTable1SameKey, "Key" ) ( jTable2SameKey, "Key" ) |> Expect.equal ljTableSameKey
            , test "leftJoinReflexive" <|
                \_ ->
                    Tidy.leftJoin ( jTable1SameKey, "Key" ) ( jTable1SameKey, "Key" ) |> Expect.equal jTable1SameKey
            , test "leftJoinUnmatchedKey1" <|
                \_ ->
                    Tidy.leftJoin ( jTable1SameKey, "Unmatched" ) ( jTable2SameKey, "Key" ) |> Expect.equal jTable1SameKey
            , test "leftJoinUnmatchedKey2" <|
                \_ ->
                    Tidy.leftJoin ( jTable1SameKey, "Key" ) ( jTable2SameKey, "Unmatched" ) |> Expect.equal jTable1SameKey
            ]
        , describe "rightjoins"
            [ test "rightJoinDiffKey" <|
                \_ ->
                    Tidy.rightJoin ( jTable1DiffKey, "Key1" ) ( jTable2DiffKey, "Key2" ) |> Expect.equal rjTableDiffKey
            , test "rightJoinSameKey" <|
                \_ ->
                    Tidy.rightJoin ( jTable1SameKey, "Key" ) ( jTable2SameKey, "Key" ) |> Expect.equal rjTableSameKey
            , test "rightJoinReflexive" <|
                \_ ->
                    Tidy.rightJoin ( jTable1DiffKey, "Key1" ) ( jTable1DiffKey, "Key1" ) |> Expect.equal jTable1DiffKey
            , test "rightJoinUnmatchedKey1" <|
                \_ ->
                    Tidy.rightJoin ( jTable1SameKey, "Unmatched" ) ( jTable2SameKey, "Key" ) |> Expect.equal jTable2SameKey
            , test "rightJoinUnmatchedKey2" <|
                \_ ->
                    Tidy.rightJoin ( jTable1SameKey, "Key" ) ( jTable2SameKey, "Unmatched" ) |> Expect.equal jTable2SameKey
            ]
        , describe "innerjoins"
            [ test "innerJoinDiffKey" <|
                \_ ->
                    Tidy.innerJoin "NewKey" ( jTable1DiffKey, "Key1" ) ( jTable2DiffKey, "Key2" ) |> Expect.equal ijTable
            , test "innerJoinSameKey" <|
                \_ ->
                    Tidy.innerJoin "NewKey" ( jTable1SameKey, "Key" ) ( jTable2SameKey, "Key" ) |> Expect.equal ijTable
            , test "innerJoinReflexive" <|
                \_ ->
                    Tidy.innerJoin "Key" ( jTable1SameKey, "Key" ) ( jTable1SameKey, "Key" ) |> Expect.equal jTable1SameKey
            , test "innerJoinUnmatchedKey1" <|
                \_ ->
                    Tidy.innerJoin "NewKey" ( jTable1SameKey, "Unmatched" ) ( jTable2SameKey, "Key" ) |> Expect.equal Tidy.empty
            , test "innerJoinUnmatchedKey2" <|
                \_ ->
                    Tidy.innerJoin "NewKey" ( jTable1SameKey, "Key" ) ( jTable2SameKey, "Unmatched" ) |> Expect.equal Tidy.empty
            ]
        , describe "outerjoins"
            [ test "outerJoinDiffKey" <|
                \_ ->
                    Tidy.outerJoin "NewKey" ( jTable1DiffKey, "Key1" ) ( jTable2DiffKey, "Key2" ) |> Expect.equal ojTable
            , test "outerJoinSameKey" <|
                \_ ->
                    Tidy.outerJoin "NewKey" ( jTable1SameKey, "Key" ) ( jTable2SameKey, "Key" ) |> Expect.equal ojTable
            , test "outerJoinReflexive" <|
                \_ ->
                    Tidy.outerJoin "Key" ( jTable1SameKey, "Key" ) ( jTable1SameKey, "Key" ) |> Expect.equal jTable1SameKey
            , test "outerJoinUnmatchedKey1" <|
                \_ ->
                    Tidy.outerJoin "NewKey" ( jTable1SameKey, "Unmatched" ) ( jTable2SameKey, "Key" ) |> Expect.equal Tidy.empty
            , test "outerJoinUnmatchedKey2" <|
                \_ ->
                    Tidy.outerJoin "NewKey" ( jTable1SameKey, "Key" ) ( jTable2SameKey, "Unmatched" ) |> Expect.equal Tidy.empty
            ]
        ]
